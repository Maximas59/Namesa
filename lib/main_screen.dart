import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:namesa/controllers/reserve_provider.dart';
import 'package:namesa/controllers/service_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/views/home_screen.dart';
import 'package:namesa/views/profile_screen.dart';
import 'package:namesa/views/reservations_screen.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _navIndex = 0;
  List<Widget> userScreens = [
    const HomeScreen(),
    ChangeNotifierProvider(
      create: (BuildContext context) => ServiceProvider(ApiService(Dio())),
      child: ChangeNotifierProvider(
          create: (BuildContext context) => ReserveProvider(ApiService(Dio())),
          child: const ReservationsScreen()),
    ),
    const ProfileScreen(),
  ];
  List<Widget> staffScreens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyCache.getString(key: "role") != "Staff"
          ? BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_border), label: "Reservations"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined), label: "Profile"),
              ],
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: _navIndex,
              selectedItemColor: const Color(0xffBE7C01),
              unselectedItemColor: Colors.white,
              onTap: (int n) {
                setState(() {
                  _navIndex = n;
                });
              },
            )
          : BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined), label: "Profile"),
              ],
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
              currentIndex: _navIndex,
              selectedItemColor: const Color(0xffBE7C01),
              unselectedItemColor: Colors.white,
              onTap: (int n) {
                setState(() {
                  _navIndex = n;
                });
              },
            ),
      body: MyCache.getString(key: "role") == "Staff"
          ? staffScreens[_navIndex]
          : userScreens[_navIndex],
    );
  }
}
