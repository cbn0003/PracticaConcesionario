import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _collection = FirebaseFirestore.instance.collection('products');

  // Stream en tiempo real de todos los productos
  Stream<List<ProductModel>> getProducts() {
    return _collection
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
        .toList());
  }

  // Añadir producto
  Future<void> addProduct(ProductModel product) async {
    await _collection.add(product.toMap());
  }

  // Editar producto
  Future<void> updateProduct(ProductModel product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  // Eliminar producto
  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }
}