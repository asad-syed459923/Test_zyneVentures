import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/item_controller.dart';
import '../../models/item.dart';
import '../../widgets/app_text_field.dart';

class ItemsStreamPage extends StatelessWidget {
  const ItemsStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.put(ItemController());
    final RxBool gridMode = true.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Items'),
        actions: <Widget>[
          Obx(() => IconButton(
                icon: Icon(gridMode.value ? Icons.view_list : Icons.grid_view),
                onPressed: () => gridMode.value = !gridMode.value,
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => _ItemForm()),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: controller.itemsStream(),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<Item> items = snap.data ?? <Item>[];
          if (items.isEmpty) {
            return const Center(child: Text('No items'));
          }
          return Obx(() => gridMode.value
              ? GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 4 / 3,
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int i) => _ItemTile(item: items[i]),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (BuildContext context, int i) => _ItemTile(item: items[i]),
                ));
        },
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  const _ItemTile({required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.find<ItemController>();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(item.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('\$${item.price.toStringAsFixed(2)}'),
                Row(children: <Widget>[
                  IconButton(onPressed: () => Get.to(() => _ItemForm(editing: item)), icon: const Icon(Icons.edit_outlined)),
                  IconButton(onPressed: () => controller.deleteItem(item.id!), icon: const Icon(Icons.delete_outline)),
                ])
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ItemForm extends StatelessWidget {
  _ItemForm({Item? editing, super.key}) : _editing = editing;
  final Item? _editing;

  @override
  Widget build(BuildContext context) {
    final ItemController controller = Get.find<ItemController>();
    final TextEditingController titleCtrl = TextEditingController(text: _editing?.title ?? '');
    final TextEditingController descCtrl = TextEditingController(text: _editing?.description ?? '');
    final TextEditingController priceCtrl = TextEditingController(text: _editing?.price.toString() ?? '');
    final bool isEdit = _editing != null;

    void onSubmit() {
      final double? price = double.tryParse(priceCtrl.text.trim());
      if (price == null) {
        Get.snackbar('Validation', 'Enter a valid price');
        return;
      }
      if (isEdit) {
        controller.updateItem(_editing!.copyWith(
          title: titleCtrl.text.trim(),
          description: descCtrl.text.trim(),
          price: price,
        ));
      } else {
        controller.addItem(title: titleCtrl.text.trim(), description: descCtrl.text.trim(), price: price);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit item' : 'Add item')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppTextField(controller: titleCtrl, label: 'Title'),
                    const SizedBox(height: 12),
                    AppTextField(controller: descCtrl, label: 'Description'),
                    const SizedBox(height: 12),
                    AppTextField(controller: priceCtrl, label: 'Price', keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: controller.isBusy.value ? null : onSubmit,
                        child: controller.isBusy.value
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


