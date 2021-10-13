import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/shop_layout_screen.dart';
import 'package:shop/modules/login_screen/login_screen.dart';
import 'package:shop/modules/register_screen/register_cubit/cubit.dart';
import 'package:shop/modules/register_screen/register_cubit/states.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameControl = TextEditingController();
  var phoneControl = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.userModel.status == true) {
              CacheHelper.saveData(
                      key: 'token', value: state.userModel.data!.token)
                  .then((value) {
                if (value) {
                  navigateAndFinish(
                    context,
                    ShopLayoutScreen(),
                  );
                }
              });
            } else {
              showToast(
                msg: state.userModel.message,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
                statusBarColor: Colors.white,
              ),
              backgroundColor: Colors.white,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Text(
                        'Register',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Register now to order',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      defaultTextField(
                        textForUnValid: 'Enter your name',
                        controller: nameControl,
                        type: TextInputType.emailAddress,
                        text: 'Name',
                        prefix: Icons.person,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextField(
                        textForUnValid: 'Enter your email',
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        text: 'email',
                        prefix: Icons.email_outlined,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextField(
                        textForUnValid: 'Enter your phone',
                        controller: phoneControl,
                        type: TextInputType.phone,
                        text: 'Phone',
                        prefix: Icons.phone,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextField(
                        onSubmit: (value) {
                          if (formKey.currentState!.validate() == true) {
                            cubit.userRegister(
                              phone: phoneControl.text,
                              name: nameControl.text,
                              email: emailController.text,
                              password: passwordController.text,
                            );
                          }
                        },
                        textForUnValid: 'Enter you password',
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        text: 'Password',
                        prefix: Icons.lock,
                        isPassword: cubit.isPassword,
                        suffix: cubit.isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        suffixFunction: () {
                          cubit.changePasswordShow();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      state is! RegisterLoadingState
                          ? defaultButton(
                              function: () {
                                print('button taped');
                                if (formKey.currentState!.validate()) {
                                  cubit.userRegister(
                                    phone: phoneControl.text,
                                    name: nameControl.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                } else {
                                  print('else button');
                                }
                              },
                              text: 'SIGN UP',
                              color: Colors.indigo,
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                color: Colors.indigo,
                              ),
                            ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don you have an account',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(
                                context,
                                LoginScreen(),
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
