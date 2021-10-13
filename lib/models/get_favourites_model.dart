class GetFavModel
{
  bool? status;
  String? message;
  GetFavDataModel? data;

  GetFavModel.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = GetFavDataModel.fromJson(json['data']);
  }
}

class GetFavDataModel
{
  List<DataFavModel?> favourites =[];
  GetFavDataModel.fromJson(Map<String,dynamic> json)
  {
    json['data'].forEach((element){
      favourites.add(DataFavModel.fromJson(element));
    });
  }
}

class DataFavModel
{
  int? id;
  ProductModel? product;

  DataFavModel.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    product = ProductModel.fromJson(json['product']);
  }
}

class ProductModel
{
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;

  ProductModel.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}