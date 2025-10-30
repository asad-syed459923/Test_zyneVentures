import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../../controllers/auth_controller.dart';
import '../../widgets/app_text_field.dart';


class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final TextEditingController emailCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot password')),
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
                        Text('Reset your password', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        AppTextField(controller: emailCtrl, label: 'Email', keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: auth.isLoading.value ? null : () => auth.forgotPassword(emailCtrl.text.trim()),
                          icon: auth.isLoading.value
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.send),
                          label: const Text('Send password reset email'),
                        ),
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


