import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/app_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';


class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.find<AuthController>();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController passwordCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Create your account')),
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
                        Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/icons/signup.svg', height: 28),
                            const SizedBox(width: 8),
                            Text('Sign up', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppTextField(controller: emailCtrl, label: 'Email', keyboardType: TextInputType.emailAddress, prefixIcon: Icons.email_outlined),
                        const SizedBox(height: 12),
                        AppTextField(controller: passwordCtrl, label: 'Password', obscureText: true, prefixIcon: Icons.lock_outline),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: auth.isLoading.value
                              ? null
                              : () => auth.signup(email: emailCtrl.text.trim(), password: passwordCtrl.text),
                          icon: auth.isLoading.value
                              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.person_add_alt),
                          label: const Text('Create account'),
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


