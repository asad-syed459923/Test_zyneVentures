import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/product.dart';


class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments as Product;
    return Scaffold(
      appBar: AppBar(title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Hero(tag: 'product_${product.id ?? product.title}', child: Image.network(product.image, height: 260, fit: BoxFit.contain)),
            ),
            const SizedBox(height: 16),
            Text(product.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Chip(label: Text(product.category)),
                const SizedBox(width: 8),
                Text('\$${product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(product.description),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


