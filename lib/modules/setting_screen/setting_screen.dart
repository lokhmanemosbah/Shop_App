import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/shop_layout_screen.dart';
import 'package:shop/main.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          return Scaffold(
              backgroundColor: Colors.indigo,
              appBar: AppBar(
                centerTitle: true,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.indigo,
                  statusBarIconBrightness: Brightness.light,
                ),
                backwardsCompatibility: false,
                title: Text(
                 nameApp,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    navigateAndFinish(context, MyApp(ShopLayoutScreen()),);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                titleSpacing: 3,
              ),
              body: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigo[700],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                isArabic ? 'الوضع الليلي':'Dark mode',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Switch(
                                value: isDark == false ? false : true,
                                onChanged: (value) {
                                  cubit.changDarkLight();
                                },
                                activeColor: Colors.pink,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                isArabic ? 'اللغة' : 'Language',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Switch(
                                value: isArabic == false ? false : true,
                                onChanged: (value) {
                                  cubit.changeLang();
                                },
                                activeColor: Colors.pink,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),);
        },
      ),
    );
  }
}
