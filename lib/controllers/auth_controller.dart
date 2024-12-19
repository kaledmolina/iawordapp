import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final storage = FlutterSecureStorage();
  final ApiService apiService = ApiService();
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final response = await apiService.login(email, password);
      if (response != null) {
        await storage.write(key: 'token', value: response['token']);
        isLoggedIn(true);
        Get.offAllNamed('/home');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading(true);
      final response = await apiService.register(name, email, password);
      if (response != null) {
        Get.snackbar('Success', 'Registration successful');
        Get.toNamed('/login');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
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
      Get.snackbar('Error', e.toString());
    }
  }
}