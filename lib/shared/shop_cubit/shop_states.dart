import 'package:shop/models/change_cart_model.dart';
import 'package:shop/models/change_favourites_model.dart';
import 'package:shop/models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ChangeBotNavBarState extends ShopStates {
  final int index;

  ChangeBotNavBarState(this.index);
}

class ChangeScreensState extends ShopStates {
  final int index;

  ChangeScreensState(this.index);
}

class HomeLoadingState extends ShopStates {}
class HomeSuccessState extends ShopStates {}
class HomeErrorState extends ShopStates {}

class GetCatLoadingState extends ShopStates {}
class GetCatSuccessState extends ShopStates {}
class GetCatErrorState extends ShopStates {}

class ChangeFavIconState extends ShopStates {
}
class ChangeFavSuccessState extends ShopStates {
  final ChangeFavouritesModel model;

  ChangeFavSuccessState(this.model);
}
class ChangeFavErrorState extends ShopStates {
  final ChangeFavouritesModel model;

  ChangeFavErrorState(this.model);
}

class GetFavLoadingState extends ShopStates {}
class GetFavSuccessState extends ShopStates {}
class GetFavErrorState extends ShopStates {}

class GetProfileLoadingState extends ShopStates {}
class GetProfileSuccessState extends ShopStates {}
class GetProfileErrorState extends ShopStates {}


class ChangePasswordState extends ShopStates {}
class EditProfileLoadingState extends ShopStates {}
class EditProfileSuccessState extends ShopStates {
  final UserModel userModel;

  EditProfileSuccessState(this.userModel);
}
class EditProfileErrorState extends ShopStates {}

class ChangeFloatingButtonState extends ShopStates {}
class ChangeBottomSheetState extends ShopStates {}


class ChangeCartColorState extends ShopStates {
}
class ChangeCartSuccessState extends ShopStates {
  final ChangeCartModel model;

  ChangeCartSuccessState(this.model);
}
class ChangeCartErrorState extends ShopStates {
  final ChangeCartModel model;

  ChangeCartErrorState(this.model);
}

class GetCartLoadingState extends ShopStates {}
class GetCartSuccessState extends ShopStates {}
class GetCartErrorState extends ShopStates {}

class ChangeTotalCart extends ShopStates {}
class ChangeDarkLight extends ShopStates {}
class ChangeLang extends ShopStates {}
