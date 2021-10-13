import 'package:shop/models/home_model.dart';

class GetCartsModel
{
  bool? status;
  String? message;
  GetCartsData? data;

  GetCartsModel.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = GetCartsData.fromJson(json['data']);
  }
}

class GetCartsData
{
  List<CartItem?> cartItems= [];
  dynamic subTotal;
  dynamic total;

  GetCartsData.fromJson(Map<String,dynamic> json)
  {
    json['cart_items'].forEach((element){
      cartItems.add(CartItem.fromJson(element));
    });
    subTotal = json['sub_total'];
    total = json['total'];
  }
}

class CartItem
{
  int? id;
  int? quantity;
  ProductModel? product;
  CartItem.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductModel.fromJson(json['product']);
  }
}