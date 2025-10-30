import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  late final ProductController controller;
  Product? editing;

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController imageCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController customCategoryCtrl = TextEditingController();

  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ProductController>();
    editing = Get.arguments as Product?;
    titleCtrl.text = editing?.title ?? '';
    priceCtrl.text = editing?.price.toString() ?? '';
    imageCtrl.text = editing?.image ?? '';
    descCtrl.text = editing?.description ?? '';
    selectedCategory = editing?.category;
  }

  void onSubmit() {
    final double? price = double.tryParse(priceCtrl.text.trim());
    if (titleCtrl.text.trim().isEmpty ||
        price == null ||
        imageCtrl.text.trim().isEmpty) {
      Get.snackbar(
        'Invalid input',
        'Please fill title, valid price and image URL',
      );
      return;
    }
    final String categoryValue =
        (selectedCategory == null || selectedCategory!.isEmpty)
            ? (customCategoryCtrl.text.trim().isEmpty
                ? 'misc'
                : customCategoryCtrl.text.trim())
            : selectedCategory!;

    final Product payload = Product(
      id: editing?.id,
      title: titleCtrl.text.trim(),
      description: descCtrl.text.trim(),
      price: price,
      category: categoryValue,
      image: imageCtrl.text.trim(),
    );
    if (editing != null) {
      controller.updateProduct(payload);
    } else {
      controller.addProduct(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdit = editing != null;
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit product' : 'Add product')),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(
                () => Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.inventory_2_outlined,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isEdit ? 'Edit product' : 'Add product',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Left: image preview
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: scheme.surfaceVariant.withOpacity(
                                        0.3,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child:
                                        imageCtrl.text.trim().isEmpty
                                            ? const Icon(
                                              Icons.image_outlined,
                                              size: 48,
                                              color: Colors.grey,
                                            )
                                            : Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Image.network(
                                                imageCtrl.text.trim(),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: imageCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Image URL',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Right: fields
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    controller: titleCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Title',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: priceCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Price',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: DropdownButtonFormField<String>(
                                      value:
                                          controller.categories.contains(
                                                selectedCategory,
                                              )
                                              ? selectedCategory
                                              : null,
                                      items: <DropdownMenuItem<String>>[
                                        ...controller.categories
                                            .map(
                                              (c) => DropdownMenuItem<String>(
                                                value: c,
                                                child: Text(c),
                                              ),
                                            )
                                            .toList(),
                                        const DropdownMenuItem<String>(
                                          value: '__custom__',
                                          child: Text('Other…'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == '__custom__') {
                                            selectedCategory = '';
                                          } else {
                                            selectedCategory = value;
                                          }
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        labelText: 'Category',
                                      ),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                      ),
                                    ),
                                  ),
                                  if (selectedCategory == null ||
                                      selectedCategory!.isEmpty) ...<Widget>[
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: customCategoryCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'Custom category',
                                      ),
                                    ),
                                  ],
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: descCtrl,
                                    decoration: const InputDecoration(
                                      labelText: 'Description',
                                    ),
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed:
                                controller.isLoading.value ? null : onSubmit,
                            child:
                                controller.isLoading.value
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(isEdit ? 'Save changes' : 'Create'),
                          ),
                        ),
                        if (controller.categories.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Tip: Categories are populated from existing products. You can add a custom one.',
                              style: TextStyle(
                                color: scheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
