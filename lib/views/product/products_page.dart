import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product.dart';
import '../../routes/app_routes.dart';
import '../../widgets/product_grid_item.dart';

// Products grid with simple client-side pagination.
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());
    final AuthController auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(onPressed: () => controller.loadProducts(), icon: const Icon(Icons.refresh)),
          IconButton(onPressed: () => auth.logout(), icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.productForm),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(controller.error.value),
                const SizedBox(height: 8),
                FilledButton(onPressed: controller.loadProducts, child: const Text('Retry')),
              ],
            ),
          );
        }
        final List<Product> items = controller.pagedProducts;
        return Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product p = items[index];
                  return ProductGridItem(
                    product: p,
                    onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: p),
                    onEdit: () => Get.toNamed(AppRoutes.productForm, arguments: p),
                    onDelete: () => controller.deleteProduct(p.id!),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: controller.currentPage.value > 1 ? controller.prevPage : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('Page ${controller.currentPage} / ${controller.totalPages}'),
                  IconButton(
                    onPressed: controller.currentPage.value < controller.totalPages ? controller.nextPage : null,
                    icon: const Icon(Icons.chevron_right),
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


