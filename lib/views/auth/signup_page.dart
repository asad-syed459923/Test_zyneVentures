import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/app_text_field.dart';
import '../../routes/app_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final AuthController auth = Get.put(AuthController());

    void submit() => auth.signup(email: _emailCtrl.text.trim(), password: _passwordCtrl.text);

    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final ColorScheme scheme = Theme.of(context).colorScheme;
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: <Color>[
                      scheme.primaryContainer.withOpacity(0.5),
                      scheme.surface,
                    ],
                  ),
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SvgPicture.asset('assets/icons/signup.svg', height: 32),
                                  const SizedBox(width: 10),
                                  Text('Create account', style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Join us to get started',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 20),
                              AppTextField(
                                controller: _emailCtrl,
                                label: 'Email',
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icons.email_outlined,
                                textInputAction: TextInputAction.next,
                                autofillHints: const <String>[AutofillHints.email],
                              ),
                              const SizedBox(height: 12),
                              AppTextField(
                                controller: _passwordCtrl,
                                label: 'Password',
                                obscureText: _obscure,
                                prefixIcon: Icons.lock_outline,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                ),
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => submit(),
                                autofillHints: const <String>[AutofillHints.newPassword],
                              ),
                              const SizedBox(height: 18),
                              FilledButton.icon(
                                onPressed: auth.isLoading.value ? null : submit,
                                icon: auth.isLoading.value
                                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                                    : const Icon(Icons.person_add_alt),
                                label: const Text('Create account'),
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('Already have an account?'),
                                  TextButton(
                                    onPressed: () => Get.toNamed(AppRoutes.login),
                                    child: const Text('Sign in'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


