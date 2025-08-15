import 'package:flutter/material.dart';
import 'package:preet/ui/pages/cart_page.dart';
import 'package:preet/ui/pages/home_page.dart';
import 'package:preet/ui/pages/login_page.dart';
import 'package:preet/ui/pages/product_detail_page.dart';
import 'package:preet/ui/pages/profile_page.dart';
import 'package:preet/ui/pages/splash_page.dart';


class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const productDetail = '/productDetail';
  static const cart = '/cart';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> get map => {
    splash: (_) => const SplashPage(),
    login: (_) => const LoginPage(),
    home: (_) => const HomePage(),
    productDetail: (_) => const ProductDetailPage(),
    cart: (_) => const CartPage(),
    profile: (_) => const ProfilePage(),
  };
}
