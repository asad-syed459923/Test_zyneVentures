import 'package:get/get.dart';

import '../models/product.dart';
import '../services/api_service.dart';

// GetX controller to manage product list, pagination, and CRUD.
class ProductController extends GetxController {
  ProductController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  final RxList<Product> allProducts = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Pagination settings
  final int pageSize = 8;
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
      final List<Product> items = await _api.fetchProducts();
      allProducts.assignAll(items);
      currentPage.value = 1;
    } catch (e) {
      error.value = '$e';
      Get.snackbar('Error', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    isLoading.value = true;
    try {
      final Product created = await _api.addProduct(product);
      allProducts.insert(0, created);
      Get.back();
      Get.snackbar('Success', 'Product added');
    } catch (e) {
      Get.snackbar('Add failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct(Product product) async {
    isLoading.value = true;
    try {
      final Product updated = await _api.updateProduct(product);
      final int index = allProducts.indexWhere((Product p) => p.id == updated.id);
      if (index != -1) {
        allProducts[index] = updated;
        allProducts.refresh();
      }
      Get.back();
      Get.snackbar('Success', 'Product updated');
    } catch (e) {
      Get.snackbar('Update failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(int id) async {
    isLoading.value = true;
    try {
      final bool ok = await _api.deleteProduct(id);
      if (ok) {
        allProducts.removeWhere((Product p) => p.id == id);
        Get.snackbar('Deleted', 'Product removed');
      } else {
        Get.snackbar('Delete failed', 'Server rejected the request');
      }
    } catch (e) {
      Get.snackbar('Delete failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages) currentPage.value++;
  }

  void prevPage() {
    if (currentPage.value > 1) currentPage.value--;
  }
}


