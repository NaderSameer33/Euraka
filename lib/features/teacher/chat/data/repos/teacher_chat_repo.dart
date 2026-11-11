import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/api_service.dart';
import '../models/chat_contact_model.dart';
import '../models/chat_message_model.dart';
import '../models/teacher_conversation_model.dart';

class TeacherChatRepo {
  final ApiService _apiService;

  TeacherChatRepo(this._apiService);

  Map<String, dynamic>? _extractMap(dynamic source) {
    if (source == null) return null;
    if (source is Map) {
      return Map<String, dynamic>.from(source);
    }
    if (source is String && source.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(source);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (_) {}
    }
    return null;
  }

  Future<Either<Failure, List<TeacherConversationModel>>> getTeacherConversations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/teacher/conversations?page=$page&limit=$limit',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']);
      final rawList = dataMap?['conversations'] as List<dynamic>? ?? [];

      final list = <TeacherConversationModel>[];
      for (final item in rawList) {
        if (item is Map) {
          list.add(TeacherConversationModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب المحادثات')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatContactModel>>> getChatContacts({
    required String groupId,
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/contacts?groupId=$groupId&page=$page&limit=$limit',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']);
      final rawList = dataMap?['contacts'] as List<dynamic>? ?? [];

      final list = <ChatContactModel>[];
      for (final item in rawList) {
        if (item is Map) {
          list.add(ChatContactModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب جهات الاتصال')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherConversationModel>> startOrRetrieveConversation({
    required String groupId,
    required String studentId,
  }) async {
    try {
      final res = await _apiService.post(
        endpoint: '/chat/teacher/conversations',
        data: {
          'groupId': groupId,
          'studentId': studentId,
        },
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']) ?? bodyMap;
      if (dataMap != null) {
        return Right(TeacherConversationModel.fromJson(dataMap));
      }
      return Left(ServerFailure('تعذر فتح المحادثة'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل بدء المحادثة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, TeacherConversationModel>> getConversationDetails(
    String conversationId,
  ) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/conversations/$conversationId',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']) ?? bodyMap;
      if (dataMap != null) {
        return Right(TeacherConversationModel.fromJson(dataMap));
      }
      return Left(ServerFailure('تعذر جلب تفاصيل المحادثة'));
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب بيانات المحادثة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatMessageModel>>> getMessageHistory(
    String conversationId, {
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/conversations/$conversationId/messages?page=$page&limit=$limit',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']);
      final rawList = dataMap?['messages'] as List<dynamic>? ?? [];

      final list = <ChatMessageModel>[];
      for (final item in rawList) {
        if (item is Map) {
          list.add(ChatMessageModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب سجل الرسائل')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatMessageModel>>> getOlderMessages(
    String conversationId, {
    required String beforeMessageId,
    int limit = 30,
  }) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/conversations/$conversationId/messages?before=$beforeMessageId&limit=$limit',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']);
      final rawList = dataMap?['messages'] as List<dynamic>? ?? [];

      final list = <ChatMessageModel>[];
      for (final item in rawList) {
        if (item is Map) {
          list.add(ChatMessageModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب الرسائل السابقة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<ChatMessageModel>>> getMissedMessages(
    String conversationId, {
    required String afterMessageId,
  }) async {
    try {
      final res = await _apiService.get(
        endpoint: '/chat/conversations/$conversationId/messages?after=$afterMessageId',
      );
      final bodyMap = _extractMap(res.data);
      final dataMap = _extractMap(bodyMap?['data']);
      final rawList = dataMap?['messages'] as List<dynamic>? ?? [];

      final list = <ChatMessageModel>[];
      for (final item in rawList) {
        if (item is Map) {
          list.add(ChatMessageModel.fromJson(Map<String, dynamic>.from(item)));
        }
      }
      return Right(list);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل جلب الرسائل الفائتة')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> markConversationAsRead(
    String conversationId,
  ) async {
    try {
      await _apiService.patch(
        endpoint: '/chat/conversations/$conversationId/read',
      );
      return const Right(true);
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response?.data['message'] as String? ?? 'فشل تحديث قراءة الرسائل')
          : 'حدث خطأ في الاتصال بالخادم';
      return Left(ServerFailure(message, e.response?.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
