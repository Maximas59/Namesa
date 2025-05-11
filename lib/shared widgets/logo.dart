import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends StatelessWidget {
  final String _text;
  const Logo(this._text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.sp),
    );
  }
}
