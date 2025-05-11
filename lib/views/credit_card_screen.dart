import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardScreen extends StatelessWidget {
  const CreditCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: const Text(
            "Credit Card",
            style: TextStyle(color: Color(0xffBE7C01)),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: const Color(0xffBE7C01),
                  size: 24.sp,
                ))
          ]),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.all(10.sp),
          padding: EdgeInsets.all(20.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "Card Holder Name",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffBE7C01)))),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "16 digits",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffBE7C01)))),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "Expiry Date",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffBE7C01)))),
              ),
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "CVC",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffBE7C01)))),
              ),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pop,
                  child: const Text("Confirm Credit"))
            ],
          ),
        ),
      ),
    );
  }
}
