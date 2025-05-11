import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MyCache.initCache();
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
            theme: ThemeData(
              fontFamily: "Poppins",
            ),
            debugShowCheckedModeBanner: false,
            home: const SafeArea(child: SplashScreen()));
      },
    );
  }
}
