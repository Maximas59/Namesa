// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/main_screen.dart';
import 'package:namesa/views/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // print(MyCache.getString(key: "token").toString().trim().isEmpty);
    Future.delayed(
        const Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => (MyCache.getString(key: "token") == null ||
                    MyCache.getString(key: "token").toString().trim().isEmpty)
                ? const LoginRegisterScreen()
                : const MainScreen())));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 2700),
                builder: (context, val, child) => Opacity(
                    opacity: val <= 0.5 ? val : 1 - val,
                    child: Image.asset("assets/images/NamesaLogo.png")))));
  }
}
