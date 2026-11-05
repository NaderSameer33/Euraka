import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/forgot_password_request_body.dart';
import '../models/forgot_password_response_model.dart';

class ForgotPasswordRepo {
  final ApiService _apiService;

  ForgotPasswordRepo(this._apiService);

  Future<({Failure? failure, ForgotPasswordResponseModel? response})> forgotPassword(
    ForgotPasswordRequestBody body,
  ) async {
    try {
      final res = await _apiService.post(
        endpoint: '/auth/forgot-password',
        data: body.toJson(),
      );

      final responseModel = ForgotPasswordResponseModel.fromJson(res.data as Map<String, dynamic>);
      return (failure: null, response: responseModel);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'حدث خطأ في إرسال رمز التحقق')
          : 'حدث خطأ في الاتصال بالخادم';
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

