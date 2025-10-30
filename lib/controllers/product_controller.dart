import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/product.dart';

class ProductController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  
  final RxList<Product> allProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<String> categories = <String>[].obs;

  final int pageSize = 12;
  final RxInt currentPage = 1.obs;

  List<Product> get pagedProducts {
    final int start = (currentPage.value - 1) * pageSize;
    final int end = (start + pageSize).clamp(0, allProducts.length);
    if (start >= allProducts.length) return <Product>[];
    return allProducts.sublist(start, end);
  }

  int get totalPages => (allProducts.length / pageSize).ceil().clamp(1, 1 << 30);

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    error.value = '';
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').orderBy('createdAt', descending: true).get();
      
      final List<Product> items = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product.fromFirestore(data, doc.id);
      }).toList();
      
      allProducts.assignAll(items);
      currentPage.value = 1;
      
      // Load unique categories
      final Set<String> uniqueCategories = items.map((p) => p.category).toSet();
      categories.assignAll(uniqueCategories.toList()..sort());
      
    } catch (e) {
      error.value = '$e';
      Get.snackbar('Error', 'Failed to load products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'User not authenticated';
      
      final productData = product.toFirestore()
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
      
      await _firestore.collection('products').doc(product.id).update(product.toFirestore());
      
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void prevPage() {
    if (currentPage.value > 1) currentPage.value--;
  }
}


