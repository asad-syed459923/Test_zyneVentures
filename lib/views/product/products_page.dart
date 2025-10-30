import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';
import '../../widgets/product_grid_item.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final AuthController auth =
        Get.isRegistered()
            ? Get.find<AuthController>()
            : Get.put(AuthController());
    final RxString selectedCategory = 'All'.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => controller.loadProducts(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh products',
          ),
          IconButton(
            onPressed: () => auth.logout(),
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.productForm),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading products...'),
              ],
            ),
          );
        }

        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.error.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: controller.loadProducts,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Category filtering
        final List<String> categoryOptions = <String>[
          'All',
          ...controller.categories,
        ];
        final String currentCat = selectedCategory.value;
        final List<Product> baseItems = controller.pagedProducts;
        final List<Product> items =
            currentCat == 'All'
                ? baseItems
                : baseItems
                    .where((Product p) => p.category == currentCat)
                    .toList();

        return Column(
          children: <Widget>[
            // Category dropdown filter
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: <Widget>[
                  const Text('Category:'),
                  const SizedBox(width: 12),
                  Obx(
                    () => DropdownButton<String>(
                      value: selectedCategory.value,
                      items:
                          categoryOptions
                              .map(
                                (String c) => DropdownMenuItem<String>(
                                  value: c,
                                  child: Text(c),
                                ),
                              )
                              .toList(),
                      onChanged: (String? value) {
                        if (value != null) selectedCategory.value = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  items.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Icon(
                              Icons.inventory_2_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No products found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed:
                                  () => Get.toNamed(AppRoutes.productForm),
                              icon: const Icon(Icons.add),
                              label: const Text('Add your first product'),
                            ),
                          ],
                        ),
                      )
                      : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 280,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.62,
                            ),
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Product p = items[index];
                          return ProductGridItem(
                            product: p,
                            onTap:
                                () => Get.toNamed(
                                  AppRoutes.productDetail,
                                  arguments: p,
                                ),
                            onEdit:
                                () => Get.toNamed(
                                  AppRoutes.productForm,
                                  arguments: p,
                                ),
                            onDelete: () => controller.deleteProduct(p.id!),
                          );
                        },
                      ),
            ),
            // Pagination
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed:
                        controller.currentPage.value > 1
                            ? controller.prevPage
                            : null,
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Previous page',
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Page ${controller.currentPage} of ${controller.totalPages}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed:
                        controller.currentPage.value < controller.totalPages
                            ? controller.nextPage
                            : null,
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Next page',
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
