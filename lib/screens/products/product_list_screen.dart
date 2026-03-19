import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product_model.dart';
import '../../core/theme.dart';
import '../auth/profile_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().listenToProducts();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario', textAlign: TextAlign.center,),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProductFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Buscador
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              onChanged: provider.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: AppTheme.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // Chips de categoría
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: provider.categories.length,
              itemBuilder: (_, i) {
                final cat = provider.categories[i];
                final isSelected = provider.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => provider.setCategory(cat),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // Grid de productos
          Expanded(
            child: provider.filteredProducts.isEmpty
                ? const Center(
              child: Text(
                'No hay productos',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemCount: provider.filteredProducts.length,
              itemBuilder: (_, i) {
                final product = provider.filteredProducts[i];
                return _ProductCard(product: product);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.stock <= product.lowStock;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductFormScreen(product: product),
        ),
      ),
      onLongPress: () => _confirmDelete(context, product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppTheme.primary.withAlpha(15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.directions_car_rounded,
                  size: 48,
                  color: AppTheme.primary,
                ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${product.price.toStringAsFixed(2)} €',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Badge de stock
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isLowStock
                          ? Colors.red.withAlpha(20)
                          : Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Stock: ${product.stock}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isLowStock ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar producto'),
        content:
        Text('¿Seguro que quieres eliminar "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductProvider>().deleteProduct(product.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}