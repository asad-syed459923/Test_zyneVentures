import 'package:flutter/material.dart';

import '../models/product.dart';


class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key, required this.product, required this.onTap, required this.onEdit, required this.onDelete});

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 3,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: 'product_${product.id ?? product.title}',
                  child: Image.network(product.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('\$${product.price.toStringAsFixed(2)}'),
                      Row(
                        children: <Widget>[
                          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 18)),
                          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, size: 18)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


