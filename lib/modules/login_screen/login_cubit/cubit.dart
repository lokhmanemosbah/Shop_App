import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/login_screen/login_cubit/states.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;
  void changePasswordShow() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }
  UserModel? user;

  void userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());
    await DioHelper.postData(
        url: LOGIN,
        lang: 'en',
        data: {
          'email': '$email',
          'password': '$password',
        }).then((value) {
      user = UserModel.fromJson(value.data);
      print(user!.status);
      print(user!.message);
      emit(LoginSuccessState(user!));
    }).catchError((error) {
      print(error.toString());
      emit(LoginErrorState());
    });
  }
}
