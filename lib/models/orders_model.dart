class OrdersModel {
  final int orderId, userId, storeId;
  final double quantity;
  final String productId,
      productTitle,
      price,
      currencyType,
      imageUrl,
      address,
      name,
      unit,
      storeName,
      number;

  OrdersModel({
    required this.orderId,
    required this.userId,
    required this.storeId,
    required this.productId,
    required this.productTitle,
    required this.price,
    required this.quantity,
    required this.currencyType,
    required this.imageUrl,
    required this.address,
    required this.name,
    required this.unit,
    required this.storeName,
    required this.number,
  });

  factory OrdersModel.fromjson(Map<String, dynamic> json) {
    return OrdersModel(
      orderId: json['id'],
      userId: json['user_id'],
      storeId: json['storeId'],
      productId: json['productId'],
      productTitle: json['productTitle'],
      price: json['price'],
      quantity: double.parse(json['quantity'].toString()),
      currencyType: json['currencyType'],
      imageUrl: json['imageUrl'],
      address: json['address'],
      name: json['name'],
      unit: json['unit'],
      storeName: json['storeName'],
      number: json['number'],
    );
  }
}
