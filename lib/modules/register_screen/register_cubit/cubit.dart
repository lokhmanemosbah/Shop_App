import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/register_screen/register_cubit/states.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  bool isPassword = true;

  void changePasswordShow() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  late UserModel user;

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoadingState());
    await DioHelper.postData(
      url: REGISTER,
      lang: 'en',
      data: {
        'name': '$name',
        'email': '$email',
        'password': '$password',
        'phone': '$phone',
      },
    ).then((value) {
      user = UserModel.fromJson(value.data);
      emit(RegisterSuccessState(user));
    }).catchError((error) {
      print('Error');
      emit(RegisterErrorState());
      print(error.toString());
    });
  }
}
