import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({
    super.key,
    required this.product,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: Get.height * 0.80, // 👈 dynamic responsive height
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: Hero(
                    tag: 'product_${product.id ?? product.title}',
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          product.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (_, __, ___) => const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '\$${product.price.toStringAsFixed(1)}',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: colorScheme.primary,
                                  ),
                                  tooltip: 'Edit product',
                                  onPressed: onEdit,
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: colorScheme.error,
                                  ),
                                  tooltip: 'Delete product',
                                  onPressed: onDelete,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
