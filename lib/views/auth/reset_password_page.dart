import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/app_text_field.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Password Reset')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppTextField(controller: emailCtrl, label: 'Email', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: auth.isLoading.value
                          ? null
                          : () => auth.forgotPassword(emailCtrl.text.trim()),
                      child:
                          auth.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Send reset email'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
