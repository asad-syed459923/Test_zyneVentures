import 'package:flutter/material.dart';
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

    return AnimatedContainer(
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
               Stack(
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
                           borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                           child: LayoutBuilder(
                             builder: (BuildContext context, BoxConstraints constraints) {
                               final int cacheWidth = (constraints.maxWidth * MediaQuery.of(context).devicePixelRatio).round();
                               return Image.network(
                                 product.image,
                                 fit: BoxFit.cover,
                                 width: double.infinity,
                                 height: double.infinity,
                                 filterQuality: FilterQuality.medium,
                                 cacheWidth: cacheWidth > 0 ? cacheWidth : null,
                                 loadingBuilder: (context, child, progress) {
                                   if (progress == null) return child;
                                   return Center(
                                     child: CircularProgressIndicator(
                                       strokeWidth: 2,
                                       value: progress.expectedTotalBytes != null
                                           ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                                           : null,
                                     ),
                                   );
                                 },
                                 errorBuilder: (_, __, ___) => const Center(
                                   child: Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
                                 ),
                               );
                             },
                           ),
                         ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Colors.black45, Colors.transparent],
                        ),
                      ),
                    ),
                  ),
                   // Category badge (pill with icon)
                   Positioned(
                     top: 8,
                     left: 8,
                     child: DecoratedBox(
                       decoration: BoxDecoration(
                         color: colorScheme.surface.withOpacity(0.85),
                         borderRadius: BorderRadius.circular(999),
                         border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
                         boxShadow: [
                           BoxShadow(
                             color: Colors.black12.withOpacity(0.08),
                             blurRadius: 6,
                             offset: const Offset(0, 2),
                           ),
                         ],
                       ),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             Icon(Icons.sell_outlined, size: 14, color: colorScheme.primary),
                             const SizedBox(width: 6),
                             Text(
                               product.category,
                               style: textTheme.labelSmall?.copyWith(
                                 color: colorScheme.onSurface,
                                 fontWeight: FontWeight.w600,
                                 letterSpacing: 0.2,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                ],
              ),

              // --- Product Info Section ---
               Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                       Text(
                         product.description,
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                         style: textTheme.bodySmall?.copyWith(
                           color: colorScheme.onSurfaceVariant,
                         ),
                       ),
                      const Spacer(),
                      // --- Price + Action Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
                                tooltip: 'Edit product',
                                onPressed: onEdit,
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(Icons.delete_outline, color: colorScheme.error),
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
    );
  }
}
