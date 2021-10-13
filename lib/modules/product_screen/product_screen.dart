import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class ProductScreen extends StatelessWidget {
  final dynamic model;

  const ProductScreen({
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getHomeData(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ChangeFavSuccessState) {
            if (state.model.status == false) {
              showToast(
                state: ToastState.ERROR,
                msg: state.model.message,
              );
            }
          }

          if (state is ChangeFavErrorState) {
            showToast(
              state: ToastState.ERROR,
              msg: "No Internet Connection",
            );
          }
        },
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
              elevation: 0,
              backgroundColor: Colors.indigo,
              backwardsCompatibility: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              title: Text(
                nameApp,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              titleSpacing: 3,
            ),
            body: cubit.homeModel != null
                ? Container(
                    decoration: BoxDecoration(
                      color: isDark ? HexColor('333739') : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Stack(
                                children: [
                                  Image(
                                    image: NetworkImage(
                                      '${model.image}',
                                    ),
                                    width: double.infinity,
                                    height: 200,
                                    //fit: BoxFit.cover,
                                  ), (model.discount > 0)
                                          ? Container(
                                              color: Colors.redAccent
                                                  .withOpacity(0.8),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                ),
                                                child: Text(
                                                  isArabic ? 'تخقيض':'DISCOUNT',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()

                                ],
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                '${model.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${model.price.toString()} \$',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1,
                                      ), (model.discount > 0)
                                              ? Text(
                                                  '${model.oldPrice.toString()} \$',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                )
                                              : Container()
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                '${model.description}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
