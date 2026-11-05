import 'package:dio/dio.dart';
import '../caching/secure_storage_service.dart';
import '../constants/app_constants.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorageService secureStorageService;
  Dio? _refreshDio;

  AuthInterceptor({
    required this.dio,
    required this.secureStorageService,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!options.headers.containsKey('Authorization')) {
      final token = await secureStorageService.read(AppConstants.userTokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      if (path.contains('/auth/refresh') || path.contains('/auth/login')) {
        return handler.next(err);
      }

      final storedRefreshToken = await secureStorageService.read(AppConstants.userRefreshTokenKey);
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        return handler.next(err);
      }

      _refreshDio ??= Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      try {
        final response = await _refreshDio!.post(
          '/auth/refresh',
          data: {'refreshToken': storedRefreshToken},
        );

        if (response.statusCode == 200 && response.data != null) {
          final data = response.data['data'] as Map<String, dynamic>?;
          final newToken = data?['token'] as String?;
          final newRefreshToken = data?['refreshToken'] as String?;

          if (newToken != null && newToken.isNotEmpty) {
            await secureStorageService.write(AppConstants.userTokenKey, newToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await secureStorageService.write(AppConstants.userRefreshTokenKey, newRefreshToken);
            }

            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await dio.fetch(options);
            return handler.resolve(retryResponse);
          }
        }
      } catch (_) {
        await secureStorageService.delete(AppConstants.userTokenKey);
        await secureStorageService.delete(AppConstants.userRefreshTokenKey);
      }
    }

    handler.next(err);
  }
}

