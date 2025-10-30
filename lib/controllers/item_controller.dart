import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/item.dart';

// Controller for Firestore items collection with real-time stream and CRUD.
class ItemController extends GetxController {
  ItemController() : _col = FirebaseFirestore.instance.collection('items');

  final CollectionReference<Map<String, dynamic>> _col;
  final RxBool isBusy = false.obs;

  Stream<List<Item>> itemsStream() {
    return _col.orderBy('createdAt', descending: true).snapshots().map((QuerySnapshot<Map<String, dynamic>> snap) =>
        snap.docs.map((DocumentSnapshot<Map<String, dynamic>> d) => Item.fromDoc(d)).toList());
  }

  Future<void> addItem({required String title, required String description, required double price}) async {
    if (title.trim().isEmpty) {
      Get.snackbar('Validation', 'Title is required');
      return;
    }
    if (price.isNaN) {
      Get.snackbar('Validation', 'Price is invalid');
      return;
    }
    isBusy.value = true;
    try {
      await _col.add(<String, dynamic>{
        'title': title.trim(),
        'description': description.trim(),
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.back();
      Get.snackbar('Success', 'Item added');
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> updateItem(Item item) async {
    if (item.id == null) return;
    isBusy.value = true;
    try {
      await _col.doc(item.id).update(<String, dynamic>{
        'title': item.title.trim(),
        'description': item.description.trim(),
        'price': item.price,
      });
      Get.back();
      Get.snackbar('Success', 'Item updated');
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isBusy.value = false;
    }
  }

  Future<void> deleteItem(String id) async {
    isBusy.value = true;
    try {
      await _col.doc(id).delete();
      Get.snackbar('Deleted', 'Item removed');
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isBusy.value = false;
    }
  }
}


