class CategoriesModel {
  bool? status;
  DataCategoriesModel? data;
  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = DataCategoriesModel.fromJson(json['data']);
  }
}

class DataCategoriesModel {
  List<DataModel>? categories = [];

  DataCategoriesModel.fromJson(Map<String, dynamic> json)
  {
    json['data'].forEach((element) {
      categories!.add(DataModel.fromJson(element));
    });
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
