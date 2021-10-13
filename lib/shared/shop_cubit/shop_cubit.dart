import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/models/change_cart_model.dart';
import 'package:shop/models/change_favourites_model.dart';
import 'package:shop/models/get_cart_model.dart';
import 'package:shop/models/get_favourites_model.dart';

import 'package:shop/models/home_model.dart';
import 'package:shop/models/login_model.dart';
import 'package:shop/modules/categories_screen/categories_screen.dart';
import 'package:shop/modules/fav_screen/fav_screen.dart';
import 'package:shop/modules/home_screen/home_screen.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int bottomNavBarCurrentIndex = 0;

  List<Widget> bottomNavBarScreens = [
    HomeScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
  ];

  Widget chooseBotNavBarScreen(int index) {
    return bottomNavBarScreens[index];
  }

  void changeBottomNavBarCurrentIndex(int index) {
    bottomNavBarCurrentIndex = index;
    emit(ChangeBotNavBarState(bottomNavBarCurrentIndex));
  }

  HomeModel? homeModel;
  Map<int?, bool?> favourites = {};
  int isFavouritesCounter = 0;

  void getHomeData() async {
    emit(HomeLoadingState());
    print(token);
    await DioHelper.getData(
      url: HOME,
      token: token,
      lang: language,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel!.data!.products.forEach((element) {
        favourites.addAll({element.id: element.inFav});
        carts.addAll({element.id: element.inCart});
      });
      favourites.forEach((key, value) {
        if (value == true) {
          isFavouritesCounter++;
        }
      });

      carts.forEach((key, value) {
        if (value == true) {
          isCartCounter++;
        }
      });
      emit(HomeSuccessState());
    }).catchError((error) {
      emit(HomeErrorState());
      print(error.toString());
    });
  }

  CategoriesModel? catModel;

  void getCategories() async {
    emit(GetCatLoadingState());
    await DioHelper.getData(
      url: GET_CATEGORIES,
      lang: language,
    ).then((value) {
      catModel = CategoriesModel.fromJson(value.data);
      print(catModel!.data!.categories![0].image);
      emit(GetCatSuccessState());
    }).catchError((error) {
      emit(GetCatErrorState());
      print(error.toString());
    });
  }

  ChangeFavouritesModel? changeFavModel;

  void changeFavourites({
    required int? id,
  }) async {
    if (favourites[id] == false) {
      favourites[id] = true;
    } else if (favourites[id] == true) {
      favourites[id] = false;
    }
    emit(ChangeFavIconState());
    await DioHelper.postData(
      url: FAVOURITES,
      data: {
        'product_id': id,
      },
      token: token,
      lang: language,
    ).then((value) {
      changeFavModel = ChangeFavouritesModel.fromJson(value.data);
      if (changeFavModel!.status == false) {
        if (favourites[id] == false) {
          favourites[id] = true;
        } else if (favourites[id] == true) {
          favourites[id] = false;
        }
      } else {
        getFavourites();
      }
      int i = 0;
      favourites.forEach((key, value) {
        if (value == true) {
          i++;
        }
        isFavouritesCounter = i;
      });
      emit(ChangeFavSuccessState(changeFavModel!));
    }).catchError((error) {
      if (favourites[id] == false) {
        favourites[id] = true;
      } else if (favourites[id] == true) {
        favourites[id] = false;
      }
      emit(ChangeFavErrorState(changeFavModel!));
      print(error.toString());
    });
  }

  GetFavModel? getFavModel;

  void getFavourites() async {
    emit(GetFavLoadingState());
    await DioHelper.getData(
      url: FAVOURITES,
      token: token,
      lang: language,
    ).then((value) {
      getFavModel = GetFavModel.fromJson(value.data);
      print(getFavModel!.data!.favourites[0]!.product!.image);
      emit(GetFavSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetFavErrorState());
    });
  }

  UserModel? userProfile;

  void getProfile() async {
    emit(GetProfileLoadingState());
    await DioHelper.getData(
      url: PROFILE,
      token: token,
      lang: language,
    ).then((value) {
      userProfile = UserModel.fromJson(value.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetProfileErrorState());
    });
  }

  bool isPassword = true;

  void changePasswordShow() {
    isPassword = !isPassword;
    emit(ChangePasswordState());
  }

  UserModel? user;

  void userEditProfile({
    required String name,
    required String email,
    required String password,
    required String phone,
    required dynamic image,
  }) async {
    emit(EditProfileLoadingState());
    await DioHelper.updateData(
        url: UPDATE_PROFILE,
        lang: language,
        token: token,
        data: {
          'name': '$name',
          'email': '$email',
          'password': '$password',
          'phone': '$phone',
          'image': image,
        }).then((value) {
      user = UserModel.fromJson(value.data);
      userProfile = UserModel.fromJson(value.data);
      emit(EditProfileSuccessState(user!));
    }).catchError((error) {
      print('Error');
      emit(EditProfileErrorState());
      print(error.toString());
    });
  }

  IconData fabIcon = Icons.shopping_cart_sharp;
  bool isBottomSheetShown = false;

  void changeFabIcon(IconData fabIcon) {
    this.fabIcon = fabIcon;
    emit(ChangeFloatingButtonState());
  }

  void changeBottomSheetShown(bool isShown) {
    isBottomSheetShown = isShown;
    emit(ChangeBottomSheetState());
  }

  Map<int?, bool?> carts = {};
  int isCartCounter = 0;
  ChangeCartModel? changeCartModel;

  void changeCarts({required int? id,}) async {
    if (carts[id] == false) {
      carts[id] = true;
    } else if (carts[id] == true) {
      carts[id] = false;
    }
    emit(ChangeCartColorState());
    await DioHelper.postData(
      url: CARTS,
      data: {'product_id': id},
      token: token,
      lang: language,
    ).then((value) {
      changeCartModel = ChangeCartModel.fromJson(value.data);
      emit(ChangeCartSuccessState(changeCartModel!));
      if (changeCartModel!.status == false) {
        if (carts[id] == false) {
          carts[id] = true;
        } else if (carts[id] == true) {
          carts[id] = false;
        }
      } else {
        getCarts();
      }
      isCartCounter = 0;
      carts.forEach((key, value) {
        if (value == true) {
          isCartCounter++;
        }
      });
      emit(ChangeCartSuccessState(changeCartModel!));
    }).catchError((error) {
      if (carts[id] == false) {
        carts[id] = true;
      } else if (carts[id] == true) {
        carts[id] = false;
      }
      emit(ChangeCartErrorState(changeCartModel!));
      print(error.toString());
    });
  }

  GetCartsModel? getCartModel;

  void getCarts() async {
    emit(GetCartLoadingState());
    await DioHelper.getData(
      url: CARTS,
      token: token,
      lang: language,
    ).then((value) {
      getCartModel = GetCartsModel.fromJson(value.data);
      emit(GetCartSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetCartErrorState());
    });
  }

  void changDarkLight() {
    isDark = !isDark;
    CacheHelper.saveData(
      key: 'isDark',
      value: isDark,
    ).then((value) {
      if (value) {
        emit(ChangeDarkLight());
      }
    });
  }

  void changeLang() {
    isArabic = !isArabic;

    CacheHelper.saveData(
      key: 'isArabic',
      value: isArabic,
    ).then((value) {
      if(value){
        language = isArabic ? 'ar' : 'en';
        nameApp = isArabic ? 'المتجر' : 'The Store';
        emit(ChangeLang());
      }
    });
  }
}
