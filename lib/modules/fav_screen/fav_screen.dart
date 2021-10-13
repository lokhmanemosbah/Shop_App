import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/models/get_favourites_model.dart';
import 'package:shop/modules/product_screen/product_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.getFavModel != null
            ? cubit.isFavouritesCounter != 0 ?
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? HexColor('333739') : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      childAspectRatio: 1 / 1.6,
                      children: List.generate(
                        cubit.getFavModel!.data!.favourites.length,
                            (index) => itemBuilder(
                          cubit.getFavModel,
                          index,
                          context,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
              ],
            ),
          ),
        )
            : Center(
          child: Text(
            isArabic ? 'قائمة المفضلة فارغة' : 'No Favourites',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
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

  Widget itemBuilder(GetFavModel? model, index, context) {
    return InkWell(
      onLongPress: () {
        ShopCubit.get(context).changeCarts(
          id: model!.data!.favourites[index]!.product!.id,
        );
      },
      onTap: () {
        navigateTo(
          context,
          ProductScreen(
            model: model!.data!.favourites[index]!.product!,
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
            Stack(alignment: AlignmentDirectional.bottomStart, children: [
              Image(
                image: NetworkImage(
                  '${model!.data!.favourites[index]!.product!.image}',
                ),
                width: double.infinity,
                height: 150,
                //fit: BoxFit.cover,
              ),
              model.data!.favourites[index]!.product!.discount > 0
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
                              isArabic ? 'تخفيض' : 'DISCOUNT',
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
              ShopCubit.get(context)
                          .carts[model.data!.favourites[index]!.product!.id] ==
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
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Center(
                            child: Text(
                              'IN CART',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ]),
            SizedBox(
              height: 1,
            ),
            Text(
              '${model.data!.favourites[index]!.product!.name}',
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
                      '${model.data!.favourites[index]!.product!.price.toString()} \$',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    model.data!.favourites[index]!.product!.discount > 0
                        ? Text(
                            '${model.data!.favourites[index]!.product!.oldPrice.toString()} \$',
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
                    ShopCubit.get(context).changeFavourites(
                        id: model.data!.favourites[index]!.product!.id);
                  },
                  icon: ShopCubit.get(context).favourites[
                              model.data!.favourites[index]!.product!.id] ==
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
}
