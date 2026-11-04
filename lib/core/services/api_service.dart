import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiService {
  final Dio dio;

  ApiService([Dio? dio]) : dio = dio ?? Dio() {
    this.dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  void addInterceptor(Interceptor interceptor) {
    dio.interceptors.add(interceptor);
  }

  Interceptors get interceptors => dio.interceptors;

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.get(
      endpoint,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.post(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> put({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.put(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete({
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return await dio.delete(
      endpoint,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }
}
