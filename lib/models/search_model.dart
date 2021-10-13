class SearchModel {
  bool? status;
  String? message;
  Data? data;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<Product>? data;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data!.add(new Product.fromJson(v));
      });
    }else{
      data = null;
    }
  }
}

class Product {
  int? id;
  dynamic price;
  String? image;
  String? name;
  String? description;

  Product({this.id, this.price, this.image, this.name, this.description,});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
