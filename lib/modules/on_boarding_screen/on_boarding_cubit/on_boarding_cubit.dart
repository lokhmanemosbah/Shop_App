import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/on_boarding.dart';
import 'package:shop/modules/login_screen/login_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'on_boarding_states.dart';

class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit() : super(OnBoardingInitialStates());

  static OnBoardingCubit get(context) => BlocProvider.of(context);

  bool isLast = false;

  void changeIsLastToBeTrue() {
    isLast = true;
    emit(OnBoardingLastPageStates());
  }

  void changeIsLastToBeFalse() {
    isLast = false;
    emit(OnBoardingNotLastPageStates());
  }

  void submit(context) {
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        emit(OnBoardingSubmittedState());
        navigateTo(context, LoginScreen());
      }
    });
  }

  List<OnBoardingItem> onBoardingItems = [
    OnBoardingItem(
      'assets/images/undraw_window_shopping_b96y.png',
      'You don\'t have to go shopping',
      'In past you had to go shopping but it waste your time',
    ),
    OnBoardingItem(
        'assets/images/undraw_add_to_cart_vkjp.png',
        'Now the life is easy',
        'You can buy anything without going out your home anymore'),
    OnBoardingItem(
      'assets/images/undraw_Online_shopping_re_k1sv.png',
      'Stay home, stay safe',
      'During covid19 , you shoudn\'t risk you life and going out',
    ),
    OnBoardingItem(
      'assets/images/undraw_Successful_purchase_re_mpig.png',
      'Your order will come to your home',
      'It\'s easy now, you will receive your order faster by using drones delivery',
    ),
  ];
}
