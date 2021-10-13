import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/modules/search_screen/cubit/seaechcubitstates.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit<SearchCubitStates>{
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);

  SearchModel? searchModel;

  void search({
  required String? text,
}){
    emit(SearchLodingState());
    DioHelper.postData(
        url: SEARCH,
        token: token,
        data: {
          'text': text,
        },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      print('status from searchcubit ${searchModel!.status}');
      print('messag from searchcubit ${searchModel!.data!.data![0].name}');
      emit(SearchSeccessState(searchModel!));
    }).catchError((error){
      print('error from search cubit : ${error.toString()}');
      emit(SearchErrorState(error.toString()));
    });
}

}