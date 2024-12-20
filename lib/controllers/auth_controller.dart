import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';
import 'package:dio/dio.dart';

class AuthController extends GetxController {
  final storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  String _formatErrors(Map<String, dynamic> errors) {
    StringBuffer errorMessage = StringBuffer();
    errors.forEach((field, messages) {
      if (messages is List) {
        errorMessage.writeln(messages.first);
      } else if (messages is String) {
        errorMessage.writeln(messages);
      }
    });
    return errorMessage.toString();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final response = await apiService.login(email, password);
      if (response != null) {
        await storage.write(key: 'token', value: response['access_token']);
        isLoggedIn(true);
        Get.offAllNamed('/home');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        Get.snackbar(
          'Error de validación',
          _formatErrors(errors),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          e.response?.data['message'] ?? 'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading(true);
      final response = await apiService.register(name, email, password);
      if (response != null) {
        Get.snackbar(
          'Éxito',
          'Registro exitoso',
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.toNamed('/login');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'] as Map<String, dynamic>;
        Get.snackbar(
          'Error de validación',
          _formatErrors(errors),
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          e.response?.data['message'] ?? 'Ha ocurrido un error',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await apiService.logout();
      await storage.delete(key: 'token');
      isLoggedIn(false);
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Error al cerrar sesión');
    }
  }
}