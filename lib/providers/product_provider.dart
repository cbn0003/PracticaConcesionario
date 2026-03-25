import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../repository/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  String get selectedCategory => _selectedCategory;

  // Productos filtrados según búsqueda y categoría
  List<ProductModel> get filteredProducts {
    return _products.where((p) {
      final matchesSearch = p.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == 'Todos' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Lista de categorías únicas para el filtro
  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    return ['Todos', ...cats];
  }

  // Escucha el stream de Firestore y actualiza el estado
  void listenToProducts() {
    _service.getProducts().listen((data) {
      _products = data;
      notifyListeners();
    });
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    await _service.addProduct(product);
  }

  Future<void> updateProduct(ProductModel product) async {
    await _service.updateProduct(product);
  }

  Future<void> deleteProduct(String id, String category) async {
    await _service.deleteProduct(id, category);
  }
}