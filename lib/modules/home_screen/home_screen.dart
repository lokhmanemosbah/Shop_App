import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/models/home_model.dart';
import 'package:shop/modules/product_screen/product_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
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
        return cubit.homeModel != null && cubit.catModel !=null
            ? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                color: isDark ? HexColor('333739') : Colors.indigo,
                child: CarouselSlider(
                  items: cubit.homeModel!.data!.banners.map((e) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            '${e.image}',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150,
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    initialPage: 0,
                    reverse: false,
                    autoPlayInterval: Duration(seconds: 5),
                    viewportFraction: 1,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? HexColor('333739') : Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '   Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.withOpacity(0.7),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0,
                        right: 0,
                      ),
                      child: Container(
                        height: 110,
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => Container(
                            child: Stack(
                              alignment:
                              AlignmentDirectional.bottomCenter,
                              children: [
                                Image(
                                  image: NetworkImage(
                                    '${cubit.catModel!.data!.categories![index].image}',
                                  ),
                                  height: 110,
                                  width: 110,
                                ),
                                Container(
                                  width: 110,
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.white.withOpacity(0.82),
                                  ),
                                  child: Text(
                                    '${cubit.catModel!.data!.categories![index].name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          separatorBuilder: (context, index) =>
                              SizedBox(
                                width: 3,
                              ),
                          itemCount:
                          cubit.catModel!.data!.categories!.length,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? HexColor('333739') : Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '   Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: isDark ? HexColor('333739') : Colors.white,
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 1.0 / 1.5,
                        children: List.generate(
                          cubit.homeModel!.data!.products.length,
                              (index) => itemBuilder(
                            cubit.homeModel,
                            index,
                            context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 90,
              ),
            ],
          ),
        )
            : Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }
}

Widget itemBuilder(HomeModel? model, index, context) {
  return InkWell(
    onLongPress: () {
      ShopCubit.get(context).changeCarts(id: model!.data!.products[index].id);
    },
    onTap: () {
      navigateTo(
        context,
        ProductScreen(
          model: model!.data!.products[index],
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage(
                  '${model!.data!.products[index].image}',
                ),
                width: double.infinity,
                height: 150,
                //fit: BoxFit.cover,
              ),
              model.data!.products[index].discount > 0
                  ? Center(
                      child: Container(
                        width: 70,
                        color: Colors.redAccent.withOpacity(0.8),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                            right: 0,
                          ),
                          child: Center(
                            child: Text(
                              isArabic ? 'تخفيض':'DISCOUNT',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              ShopCubit.get(context).carts[model.data!.products[index].id] ==
                      true
                  ? Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        height: 150,
                        width: 150,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 0,
                          ),
                          child: Center(
                            child: Text(
                              'IN CART',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 1,
          ),
          Text(
            '${model.data!.products[index].name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model.data!.products[index].price.toString()} \$',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  model.data!.products[index].discount > 0
                      ? Text(
                          '${model.data!.products[index].oldPrice.toString()} \$',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        )
                      : Container(),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  ShopCubit.get(context)
                      .changeFavourites(id: model.data!.products[index].id);
                },
                icon: ShopCubit.get(context)
                            .favourites[model.data!.products[index].id] ==
                        true
                    ? CircleAvatar(
                        backgroundColor: Colors.pinkAccent.withOpacity(0.7),
                        radius: 13,
                        child: Icon(
                          Icons.favorite_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.8),
                        radius: 13,
                        child: Icon(
                          Icons.favorite_outline,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
