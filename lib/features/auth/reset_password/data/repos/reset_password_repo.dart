import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/reset_password_request_body.dart';
import '../models/reset_password_response_model.dart';

class ResetPasswordRepo {
  final ApiService _apiService;

  ResetPasswordRepo(this._apiService);

  Future<({Failure? failure, ResetPasswordResponseModel? response})> resetPassword(
    ResetPasswordRequestBody body,
  ) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/reset-password',
        data: body.toJson(),
      );

      final responseModel = ResetPasswordResponseModel.fromJson(res.data as Map<String, dynamic>);
      return (failure: null, response: responseModel);
    } on DioException catch (e) {
      String message = 'حدث خطأ في إعادة تعيين كلمة المرور';
      if (e.response?.data is Map) {
        final data = e.response!.data as Map;
        if (data['message'] != null) {
          message = data['message'] as String;
        } else if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
          final firstError = (data['errors'] as List).first;
          if (firstError is Map && firstError['message'] != null) {
            message = firstError['message'] as String;
          }
        }
      }
      return (
        failure: ServerFailure(message, e.response?.statusCode),
        response: null,
      );
    } catch (e) {
      return (
        failure: ServerFailure(e.toString()),
        response: null,
      );
    }
  }
}

