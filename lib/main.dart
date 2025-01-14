import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/src/app.dart';
import 'services/api_service.dart';
import 'controllers/auth_controller.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar servicios
  Get.put(ApiService());
  Get.put(AuthController());
  runApp(const MyApp());
}
