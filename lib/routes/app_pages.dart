import 'package:get/get.dart';

import '../views/auth/login_page.dart';
import '../views/auth/signup_page.dart';
import '../views/auth/forgot_password_page.dart';
import '../views/auth/reset_password_page.dart';
import '../views/product/products_page.dart';
import '../views/product/product_detail_page.dart';
import '../views/product/product_form_page.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordPage(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordPage(),
    ),
    GetPage(name: AppRoutes.products, page: () => const ProductsPage()),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailPage(),
    ),
    GetPage(name: AppRoutes.productForm, page: () => const ProductFormPage()),
  ];
}
