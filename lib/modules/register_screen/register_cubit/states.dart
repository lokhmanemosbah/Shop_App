import 'package:dio/dio.dart';
import 'package:shop/models/login_model.dart';

abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}
class ChangePasswordState extends RegisterStates {}
class RegisterLoadingState extends RegisterStates {}
class RegisterSuccessState extends RegisterStates {
  final UserModel userModel;

  RegisterSuccessState(this.userModel);
}
class RegisterErrorState extends RegisterStates {}

