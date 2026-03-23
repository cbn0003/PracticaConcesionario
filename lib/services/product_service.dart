import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final _firestore = FirebaseFirestore.instance;
  late final _collection = _firestore.collection('products');

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
    // 1. Genera referencia con ID automático (sin escribir aún)
    final newProductRef = _collection.doc();

    // 2. Referencia al documento de categoría en Firebase
    final categoryRef = _firestore
        .collection('category')
        .doc(_categoryDocId(product.category));

    // 3. Batch: ambas operaciones son atómicas
    final batch = _firestore.batch();
    batch.set(newProductRef, product.toMap());

    // Si el documento de categoría no existe → lo crea con el array
    // Si ya existe → simplemente añade el ID al array sin tocar el resto
    batch.set(
      categoryRef,
      {'list': FieldValue.arrayUnion([newProductRef.id])},
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  // Editar producto
  Future<void> updateProduct(ProductModel product) async {
    await _collection.doc(product.id).update(product.toMap());
  }

  // Eliminar producto
  Future<void> deleteProduct(String id) async {
    await _collection.doc(id).delete();
  }

  // Traduce la categoría del formulario al doc de Firebase
  String _categoryDocId(String category) {
    switch (category.toLowerCase()) {
      case 'coche':
        return 'cars';
      case 'moto':
        return 'bikes';
      case 'furgoneta':
        return 'vans';
      default:
        return category.toLowerCase();
    }
  }
}