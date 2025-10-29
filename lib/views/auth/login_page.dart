import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';


class    extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.put(AuthController());
    final TextEditingController usernameCtrl = TextEditingController(text: 'mor_2314');
    final TextEditingController passwordCtrl = TextEditingController(text: '83r5^_');

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(controller: usernameCtrl, decoration: const InputDecoration(labelText: 'Username')),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordCtrl,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: auth.isLoading.value
                            ? null
                            : () => auth.login(usernameCtrl.text.trim(), passwordCtrl.text),
                        child: auth.isLoading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextButton(onPressed: () => Get.toNamed(AppRoutes.signup), child: const Text('Create account')),
                        TextButton(onPressed: () => Get.toNamed(AppRoutes.forgotPassword), child: const Text('Forgot password?')),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}


