import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/word.dart';

class ApiService {
  final String baseUrl = 'https://apiv1.soldadurasherrerotierralta.com/api';
  final storage = const FlutterSecureStorage();
  late Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {'Accept': 'application/json'},
      validateStatus: (status) {
        return status! < 500;
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 422) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    return response.data;
  }

  Future<Map<String, dynamic>?> register(
      String name, String email, String password) async {
    final response = await _dio.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });

    if (response.statusCode == 422) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }

    return response.data;
  }

  Future<void> logout() async {
    await _dio.post('/logout');
  }

  Future<Word> getNextWord() async {
    final response = await _dio.get('/english-verbs/next-word');
    if (response.statusCode == 200) {
      return Word.fromJson(response.data['word']);
    }
    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  Future<void> markWordAsLearned(int wordId) async {
    await _dio.post('/english-verbs/$wordId/mark-learned');
  }
}
