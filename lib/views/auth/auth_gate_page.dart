import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../product/products_page.dart';
import 'login_page.dart';

// Simple gate that shows Products when authenticated, otherwise Login.
class AuthGatePage extends StatelessWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return const ProductsPage();
        }
        return const LoginPage();
      },
    );
  }
}


