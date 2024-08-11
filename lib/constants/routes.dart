import 'package:cafe_front/provider/login/after_login_store.dart';
import 'package:cafe_front/views/login/after_login.dart';
import 'package:cafe_front/views/login/login_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final routes = <String, WidgetBuilder>{
  '/login': (BuildContext context) => const LoginMain(),
  '/login/after': (BuildContext context) => ChangeNotifierProvider(
      create: (context) => AfterLoginStore(),
      child: const AfterLogin(),
  ),
};