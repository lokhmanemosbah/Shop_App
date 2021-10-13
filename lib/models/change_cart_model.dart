
import 'package:shop/models/home_model.dart';

class ChangeCartModel
{
  bool? status;
  String? message;
  CartDataModel? data;

  ChangeCartModel.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = CartDataModel.fromJson(json['data']);
  }
}

class CartDataModel
{
  int? id;
  int? quantity;
  ProductModel? product;

  CartDataModel.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    quantity = json['quantity'];
    product = ProductModel.fromJson(json['product']);
  }
}