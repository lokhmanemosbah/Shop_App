import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/shop_layout_screen.dart';
import 'package:shop/shared/components/components.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/cache_helper.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';
import 'package:shop/shared/shop_cubit/shop_states.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameControl = TextEditingController();
  var phoneControl = TextEditingController();

  var formKey = GlobalKey<FormState>();

  late File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
      if (_image != null)
      isEdit = true;
    });
  }
  bool? isEdit = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getProfile(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is EditProfileSuccessState) {
            if (state.userModel.status == true) {
              CacheHelper.saveData(
                      key: 'token', value: state.userModel.data!.token)
                  .then((value) {
                if (value == true) {
                  navigateAndFinish(context, ShopLayoutScreen());
                }
              });
            } else {
              showToast(msg: state.userModel.message, state: ToastState.ERROR);
            }
          }
        },
        builder: (context, state) {
          ShopCubit cubit = ShopCubit.get(context);
          if (cubit.userProfile != null) {
            nameControl.text = cubit.userProfile!.data!.name!;
            phoneControl.text = cubit.userProfile!.data!.phone!;
            emailController.text = cubit.userProfile!.data!.email!;
          }

          return Scaffold(
              body: cubit.userProfile != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text(
                                'Edit profile',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'You can\'t edit again until 60 days',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.indigo,),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Container(
                                      height: 110,
                                      width: 110,
                                    ),
                                    if(isEdit == false)
                                      CircleAvatar(
                                      radius: 40,
                                      child: ShopCubit.get(context)
                                                  .userProfile!
                                                  .data!
                                                  .image !=
                                              null
                                          ? Image.file(File('${ShopCubit.get(context).userProfile!.data!.image!}',),)
                                          : Image(image: NetworkImage(
                                          'https://cdn.icon-icons.com/icons2/2643/PNG/512/male_man_people_person_avatar_white_tone_icon_159363.png',),),
                                    ),
                                    if(isEdit == true)
                                      CircleAvatar(
                                        radius: 40,
                                        child: ClipOval(child: Image.file(_image!,fit:BoxFit.cover,height: 100,width: 100,),clipBehavior: Clip.hardEdge,),
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 50,
                                        top: 50,
                                      ),
                                      child: IconButton(
                                        onPressed: () {

                                            setState(() {
                                              getImage();

                                            });

                                        },
                                        icon: CircleAvatar(
                                          backgroundColor:
                                              Colors.pink.withOpacity(0.7,),
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],),
                              SizedBox(
                                height: 20,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your name',
                                  controller: nameControl,
                                  type: TextInputType.emailAddress,
                                  text: 'Name',
                                  prefix: Icons.person,),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your email',
                                  controller: emailController,
                                  type: TextInputType.emailAddress,
                                  text: 'email',
                                  prefix: Icons.email_outlined),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    print(value);
                                  },
                                  onTap: () {},
                                  textForUnValid: 'Enter your phone',
                                  controller: phoneControl,
                                  type: TextInputType.phone,
                                  text: 'Phone',
                                  prefix: Icons.phone),
                              SizedBox(
                                height: 10,
                              ),
                              defaultTextField(
                                  onSubmit: (value) {
                                    if (formKey.currentState!.validate() ==
                                        true) {
                                      setState(() {
                                        isEdit = false;
                                      });
                                      cubit.userEditProfile(
                                          phone: phoneControl.text,
                                          name: nameControl.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                      image: isEdit == true ? _image!.path : cubit.userProfile!.data!.image!,);
                                      print(_image!.path);
                                    }
                                  },
                                  onTap: () {},
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
                                  }),
                              SizedBox(
                                height: 20,
                              ),
                              state is! EditProfileLoadingState
                                  ? defaultButton(
                                      function: () {
                                        print('button taped');
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            isEdit = false;
                                          });
                                          cubit.userEditProfile(
                                              phone: phoneControl.text,
                                              name: nameControl.text,
                                              email: emailController.text,
                                              password:
                                                  passwordController.text,
                                          image: isEdit == true ? _image!.path : cubit.userProfile!.data!.image!,);
                                          print(_image!.path);
                                        } else {
                                          print('else button');
                                        }
                                      },
                                      text: 'SAVE',
                                      color: Colors.indigo,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.indigo,
                                      ),
                                    ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Forget password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.indigo,),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: Colors.indigo,
                    ),),);
        },
      ),
    );
  }
}
