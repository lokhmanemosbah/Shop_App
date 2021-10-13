import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/layout/shop_layout_screen.dart';
import 'package:shop/modules/login_screen/login_screen.dart';
import 'package:shop/shared/bloc_observer.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/network/remote/dio_helper.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';
import 'modules/on_boarding_screen/on_boarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  DioHelper.dioInit();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.importData(key: 'onBoarding');
  isDark = CacheHelper.importData(key: 'isDark') ?? false;
  isArabic = CacheHelper.importData(key: 'isArabic') ?? false;
  token = CacheHelper.importData(key: 'token') != null
      ? CacheHelper.importData(key: 'token')
      : null;

  late Widget startWidget = OnBoardingScreen();
  if (onBoarding != null) {
    if (token != null) {
      startWidget = ShopLayoutScreen();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    OnBoardingScreen();
  }

  runApp(MyApp(startWidget));
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  final Widget startWidget;

  MyApp(this.startWidget);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ShopCubit(),
    child: BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state){},
      builder: (context, state){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: HexColor('333739'),
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.white,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
            ),
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: defaultColor
            ),
            scaffoldBackgroundColor: HexColor('333739'),
            fontFamily: 'Nunito',
            textTheme: TextTheme(
              body1: TextStyle(
                color: Colors.white
              ),
            ),
            //primarySwatch: Colors.red,
          ),
          theme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.indigo,
              unselectedItemColor: Colors.black38,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
            ),
            textTheme: TextTheme(
              body1: TextStyle(
                  color: Colors.black
              ),
            ),
            appBarTheme: AppBarTheme(
                elevation: 0,
                color: defaultColor
            ),
            fontFamily: 'Nunito',
            primarySwatch: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: startWidget,
        );
      },
    ),
    );
  }
}
