import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/modules/login_screen/login_screen.dart';
import 'package:shop/shared/network/local/cache_helper.dart';

import 'constants.dart';

Widget defaultButton({
  double width = double.infinity,
  Color color = Colors.blue,
  required Function function,
  required String text,
}) =>
    Container(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: MaterialButton(
          color: color,
          onPressed: () {
            function();
          },
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

Widget defaultTextField({
  required TextEditingController controller,
  bool isPassword = false,
  required TextInputType type,
  Function? onSubmit,
  Function? onChanged,
  Function? onTap,
  required String text,
  required IconData prefix,
  IconData? suffix,
  Function? suffixFunction,
  String textForUnValid = 'this element is required',
  //required Function validate,
}) =>
    Container(
      child: TextFormField(
        cursorColor: isDark ? Colors.white : Colors.black87,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
        ),
        autocorrect: true,
        controller: controller,
        onTap: () {
          onTap!();
        },
        validator: (value) {
          if (value!.isEmpty) {
            return textForUnValid;
          }
          return null;
        },
        onChanged: (value) {
          onChanged!(value);
        },
        onFieldSubmitted: (value) {
          onSubmit!(value);
        },
        obscureText: isPassword ? true : false,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
          prefixIcon: Icon(
            prefix,
            color: isDark ? Colors.white : Colors.black87,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              suffixFunction!();
            },
            icon: Icon(
              suffix,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(
              color: isDark ? Colors.white : Colors.black87,
            ),
            gapPadding: 4,
          ),
        ),
      ),
    );

void navigateTo(context, widget) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => widget),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

void showToast({
  required String? msg,
  required ToastState state,
}) {
  Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.white,
      textColor: chooseToastColor(state),
      fontSize: 14.0);
}

enum ToastState {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.SUCCESS:
      color = Colors.greenAccent;
      break;

    case ToastState.ERROR:
      color = Colors.redAccent;
      break;

    case ToastState.WARNING:
      color = Colors.orangeAccent;
      break;
  }
  return color;
}

void logOut(context) {
  CacheHelper.removeData(key: 'token');
  navigateAndFinish(context, LoginScreen());
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

Widget buildListProduct(
  model,
  context,
) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 120.0,
        child: Row(
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.image),
                  width: 120.0,
                  height: 120.0,
                ),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Spacer(),
                      /*IconButton(
                        onPressed: () {
                          ShopCubit.get(context).changeFavorites(model.id);
                        },
                        icon: CircleAvatar(
                          radius: 15.0,
                          backgroundColor:
                          ShopCubit.get(context).favorites[model.id]
                              ? defaultColor
                              : Colors.grey,
                          child: Icon(
                            Icons.favorite_border,
                            size: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    );
