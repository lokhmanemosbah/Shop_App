import 'dart:core';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shop/shared/shop_cubit/shop_cubit.dart';

const LOGIN = 'login';
const HOME = 'home';
const GET_CATEGORIES = 'categories';
const FAVOURITES = 'favorites';
const REGISTER = 'register';
const PROFILE = 'profile';
const UPDATE_PROFILE = 'update-profile';
const SEARCH = 'products/search';
const CARTS = 'carts';
bool isArabic = false;
String nameApp = isArabic ? 'المتجر' : 'The Store';
String language = isArabic ? 'ar' : 'en';
bool isDark = false;
const Color defaultColor = Colors.indigo;
String? token = '';

