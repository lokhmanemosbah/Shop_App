import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/shop_layout_screen.dart';
import 'package:shop/modules/login_screen/login_cubit/cubit.dart';
import 'package:shop/modules/register_screen/register_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'login_cubit/states.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.userModel.status == true) {
              CacheHelper.saveData(
                      key: 'token', value: state.userModel.data!.token)
                  .then(
                (value) {
                  if (value) {
                    navigateAndFinish(
                      context,
                      ShopLayoutScreen(),
                    );
                  }
                },
              );
            } else {
              showToast(
                msg: state.userModel.message,
                state: ToastState.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);

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
                      Image(
                        image: AssetImage(
                          'assets/images/undraw_Login_re_4vu2.png',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextField(
                        onSubmit: (value) {
                          print(value);
                        },
                        textForUnValid: 'Enter your username',
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        text: 'Username',
                        prefix: Icons.alternate_email,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextField(
                        onSubmit: (value) {
                          if (formKey.currentState!.validate() == true) {
                            cubit.userLogin(
                                email: emailController.text,
                                password: passwordController.text);
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
                      state is! LoginLoadingState
                          ? defaultButton(
                              function: () {
                                print('button taped');
                                if (formKey.currentState!.validate() == true) {

                                  cubit.userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                } else {
                                  print('else button');
                                }
                              },
                              text: 'Login',
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
                            'Don\'t have an account',
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
                                RegisterScreen(),
                              );
                            },
                            child: Text(
                              'Register now',
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
