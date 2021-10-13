import 'package:shop/models/search_model.dart';

abstract class SearchCubitStates{}

class SearchInitialState extends SearchCubitStates{}
class SearchLodingState extends SearchCubitStates{}
class SearchSeccessState extends SearchCubitStates{
  final SearchModel searchModel;
  SearchSeccessState(this.searchModel);
}
class SearchErrorState extends SearchCubitStates{
  String error;
  SearchErrorState(this.error);
}