import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, states) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return cubit.catModel != null
            ? SingleChildScrollView(
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
                    padding: const EdgeInsets.only(top: 15, bottom: 15,),
                    child: GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 17,
                      childAspectRatio: 1.0 / 1.3,
                      children: List.generate(
                        cubit.catModel!.data!.categories!.length,
                            (index) =>
                            catItemBuilder(
                              cubit.catModel!,
                              index,
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
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget catItemBuilder(CategoriesModel? model, index) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 10,
        left: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: NetworkImage(
                  '${model!.data!.categories![index].image}',
                ),
                width: double.infinity,
                height: 150,
                //fit: BoxFit.cover,
              ),
              SizedBox(
                height: 1,
              ),
              Text(
                '${model.data!.categories![index].name}',
                maxLines: 1,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
