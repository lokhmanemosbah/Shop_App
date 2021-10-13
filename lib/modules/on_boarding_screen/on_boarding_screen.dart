import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/on_boarding.dart';
import 'package:shop/modules/on_boarding_screen/on_boarding_cubit/on_boarding_cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'on_boarding_cubit/on_boarding_states.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => OnBoardingCubit(),
      child: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
          listener: (context, state) {},
          builder: (context, state) {
            OnBoardingCubit cubit = OnBoardingCubit.get(context);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.white,
                    statusBarIconBrightness: Brightness.dark,),
                actions: [
                  TextButton(
                    onPressed: () {
                      cubit.submit(context);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.indigo, fontWeight: FontWeight.w700,),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        onPageChanged: (index) {
                          if (index == cubit.onBoardingItems.length - 1) {
                            cubit.changeIsLastToBeTrue();
                          } else {
                            cubit.changeIsLastToBeFalse();
                          }
                        },
                        physics: BouncingScrollPhysics(),
                        controller: pageController,
                        itemBuilder: (context, index) =>
                            itemBuilder(cubit.onBoardingItems[index],),
                        itemCount: cubit.onBoardingItems.length,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          count: cubit.onBoardingItems.length,
                          effect: ExpandingDotsEffect(
                            activeDotColor: Colors.indigo,
                            dotHeight: 10,
                            dotWidth: 10,
                          ),
                        ),
                        Spacer(),
                        FloatingActionButton(
                          onPressed: () {
                            if (cubit.isLast == true) {
                              cubit.submit(context);
                            } else {
                              pageController.nextPage(
                                  duration: Duration(microseconds: 750),
                                  curve: Curves.bounceIn,);
                            }
                          },
                          child: Icon(Icons.arrow_forward,),
                          backgroundColor: Colors.indigo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget itemBuilder(OnBoardingItem item) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image(
              image: AssetImage(item.image,),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            item.body,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 15,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      );
}
