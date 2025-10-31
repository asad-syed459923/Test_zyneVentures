import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class ProductController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final RxList<Product> allProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxBool hasMore = false.obs;
  final RxString error = ''.obs;
  final RxList<String> categories = <String>[].obs;

  final int pageSize = 12;
  DocumentSnapshot<Map<String, dynamic>>? _lastDoc;

  @override
  void onInit() {
    super.onInit();
    resetAndFetch();
  }

  Future<void> resetAndFetch() async {
    isLoading.value = true;
    error.value = '';
    hasMore.value = true;
    _lastDoc = null;
    allProducts.clear();
    categories.clear();
    await _fetchPage();
    isLoading.value = false;
  }

  Future<void> fetchMore() async {
    if (!hasMore.value || isFetchingMore.value) return;
    isFetchingMore.value = true;
    await _fetchPage();
    isFetchingMore.value = false;
  }

  Future<void> _fetchPage() async {
    try {
      Query<Map<String, dynamic>> q = _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .limit(pageSize);
      if (_lastDoc != null) {
        q = q.startAfterDocument(_lastDoc!);
      }
      final QuerySnapshot<Map<String, dynamic>> snap = await q.get();
      if (snap.docs.isEmpty) {
        hasMore.value = false;
        return;
      }
      _lastDoc = snap.docs.last;
      final List<Product> items = snap.docs
          .map((d) => Product.fromFirestore(d.data(), d.id))
          .toList();
      allProducts.addAll(items);
      final Set<String> unique = <String>{...categories, ...items.map((e) => e.category)};
      categories.assignAll(unique.toList()..sort());
    } catch (e) {
      error.value = '$e';
      Get.snackbar('Error', 'Failed to load products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      final productData =
          product.toFirestore()
            ..['createdBy'] = user.uid
            ..['createdAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('products').add(productData);
      final newProduct = product.copyWith(id: docRef.id, createdBy: user.uid);

      allProducts.insert(0, newProduct);
      Get.back();
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(Product product) async {
    isLoading.value = true;
    try {
      if (product.id == null) throw 'Product ID is required';

      await _firestore
          .collection('products')
          .doc(product.id)
          .update(product.toFirestore());

      final int index = allProducts.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        allProducts[index] = product;
        allProducts.refresh();
      }

      Get.back();
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';

      // Optional: Check if user has permission to delete
      final doc = await _firestore.collection('products').doc(id).get();
      final data = doc.data();
      if (data?['createdBy'] != user.uid) {
        throw 'You can only delete your own products';
      }

      await _firestore.collection('products').doc(id).delete();
      allProducts.removeWhere((p) => p.id == id);
      Get.snackbar('Success', 'Product deleted successfully');
      allProducts.refresh();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  // Client-side next/prev removed in favor of Firestore cursor pagination
}
