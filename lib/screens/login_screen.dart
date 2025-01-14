import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final storage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    getToken();
  }

  Future getToken() async {
    var token = await storage.read(key: 'token');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (token != null) {
        Get.toNamed('/home');
      } else {
        Get.toNamed('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Obx(() => ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              authController.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  )),
              TextButton(
                onPressed: () => Get.toNamed('/register'),
                child: const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
