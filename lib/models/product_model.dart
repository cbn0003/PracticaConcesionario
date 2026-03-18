class ProductModel {

  final String id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final int lowStock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    this.lowStock = 5,
  });

  //Convierte documento en ProductModel
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id){
    return ProductModel(
        id: id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        category: data['category'] ?? '',
        price: data['price'] ?? '',
        stock: data['stock'] ?? '',
        lowStock: data['lowStock'] ?? 5,
    );
  }

  //Convierte en Map para guardar en Firestore
  Map<String, dynamic> toMap(){
    return{
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stock': stock,
      'lowStock': lowStock,
    };
  }
  //Copia el objeto cambiando algunos campos
  ProductModel copyWith({
    String? name,
    String? description,
    String? category,
    double? price,
    int? stock,

  }){
    return ProductModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      lowStock: lowStock,
    );
  }



}