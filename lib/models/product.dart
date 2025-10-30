import 'package:cloud_firestore/cloud_firestore.dart';

// Product model for Firestore
class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;
  final DateTime createdAt;
  final String? createdBy;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    DateTime? createdAt,
    this.createdBy,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Product(
      id: documentId,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: json['createdBy'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'createdAt': Timestamp.fromDate(createdAt),
      if (createdBy != null) 'createdBy': createdBy,
    };
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? image,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}


