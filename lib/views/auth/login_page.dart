import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_text_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key}); 

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.put(AuthController());
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome back')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Sign in', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        AppTextField(controller: emailCtrl, label: 'Email', keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined),
                        const SizedBox(height: 12),
                        AppTextField(controller: passwordCtrl, label: 'Password', obscureText: true, prefixIcon: Icons.lock_outline),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: auth.isLoading.value ? null : () => auth.login(emailCtrl.text.trim(), passwordCtrl.text),
                          icon: auth.isLoading.value
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.login),
                          label: const Text('Login'),
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
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}


