import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore Item model. Firestore stores timestamps as Timestamp.
class Item {
  Item({this.id, required this.title, required this.description, required this.price, this.createdAt});

  final String? id;
  final String title;
  final String description;
  final double price;
  final Timestamp? createdAt;

  Item copyWith({String? id, String? title, String? description, double? price, Timestamp? createdAt}) {
    return Item(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Item.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic>? data = doc.data();
    return Item(
      id: doc.id,
      title: (data?['title'] as String?) ?? '',
      description: (data?['description'] as String?) ?? '',
      price: (data?['price'] is num) ? (data?['price'] as num).toDouble() : double.tryParse('${data?['price']}') ?? 0.0,
      createdAt: data?['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'price': price,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}


