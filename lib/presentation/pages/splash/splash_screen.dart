import 'dart:async';

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      context.goNamed(RouterName.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(AppImage.splash2)),
      backgroundColor: Colors.black,
    );
  }
}
