import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxBool isLoading = false.obs;
  final Rxn<User> firebaseUser = Rxn<User>();

  @override
  void onInit() {
    firebaseUser.bindStream(_auth.authStateChanges());
    super.onInit();
  }

  bool get isLoggedIn => firebaseUser.value != null;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email.');
      isLoading.value = false;
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Invalid Password', 'Password must be at least 6 characters.');
      isLoading.value = false;
      return;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(AppRoutes.products);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login failed', e.message ?? '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup({required String email, required String password}) async {
    isLoading.value = true;
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Email', 'Please enter a valid email.');
      isLoading.value = false;
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Invalid Password', 'Password must be at least 6 characters.');
      isLoading.value = false;
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Signup successful', 'Account created. You are now logged in.');
      Get.offAllNamed(AppRoutes.products);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Signup failed', e.message ?? '');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    if (!GetUtils.isEmail(email)) {
      
      Get.snackbar('Invalid Email', 'Please enter a valid email.');
      isLoading.value = false;
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Reset Email Sent', 'Check your inbox to reset your password.');
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Reset failed', e.message ?? '');
    } finally {
      isLoading.value = false;
    }
  }
}


