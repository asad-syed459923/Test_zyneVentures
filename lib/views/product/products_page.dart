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
            onPressed: () => controller.resetAndFetch(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                  onPressed: controller.resetAndFetch,
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
        final List<Product> baseItems = controller.allProducts;
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
                      : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification n) {
                          if (n.metrics.pixels >=
                                  n.metrics.maxScrollExtent - 200 &&
                              controller.hasMore.value &&
                              !controller.isFetchingMore.value) {
                            controller.fetchMore();
                          }
                          return false;
                        },
                        child: GridView.builder(
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
            ),
            Obx(
              () =>
                  controller.isFetchingMore.value
                      ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(child: CircularProgressIndicator()),
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }
}
