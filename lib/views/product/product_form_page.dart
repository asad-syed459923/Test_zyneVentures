import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';

// Form for adding or editing a product via Fake Store API.
class ProductFormPage extends StatelessWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find<ProductController>();
    final Product? editing = Get.arguments as Product?;

    final TextEditingController titleCtrl = TextEditingController(text: editing?.title ?? '');
    final TextEditingController priceCtrl = TextEditingController(text: editing?.price.toString() ?? '');
    final TextEditingController categoryCtrl = TextEditingController(text: editing?.category ?? '');
    final TextEditingController imageCtrl = TextEditingController(text: editing?.image ?? '');
    final TextEditingController descCtrl = TextEditingController(text: editing?.description ?? '');

    final bool isEdit = editing != null;

    void onSubmit() {
      final double? price = double.tryParse(priceCtrl.text.trim());
      if (titleCtrl.text.trim().isEmpty || price == null || (imageCtrl.text.trim().isEmpty)) {
        Get.snackbar('Invalid input', 'Please fill title, valid price and image URL');
        return;
      }
      final Product payload = Product(
        id: editing?.id,
        title: titleCtrl.text.trim(),
        description: descCtrl.text.trim(),
        price: price,
        category: categoryCtrl.text.trim().isEmpty ? 'misc' : categoryCtrl.text.trim(),
        image: imageCtrl.text.trim(),
      );
      if (isEdit) {
        controller.updateProduct(payload);
      } else {
        controller.addProduct(payload);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit product' : 'Add product')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
                    const SizedBox(height: 12),
                    TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'Category')),
                    const SizedBox(height: 12),
                    TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'Image URL')),
                    const SizedBox(height: 12),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: controller.isLoading.value ? null : onSubmit,
                        child: controller.isLoading.value
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : Text(isEdit ? 'Save changes' : 'Create'),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}


