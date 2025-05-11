import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/views/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              Icons.settings,
              size: 24.sp,
              color: Colors.white,
            ),
            title: Text(
              "Settings",
              style: TextStyle(fontSize: 24.sp, color: Colors.white),
            ),
          ),
          InkWell(
            onTap: () async {
              await MyCache.clear();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginRegisterScreen()));
            },
            child: ListTile(
              leading: Icon(
                Icons.person,
                size: 24.sp,
                color: Colors.red,
              ),
              title: Text(
                "Log Out",
                style: TextStyle(fontSize: 24.sp, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
