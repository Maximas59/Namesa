import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/login_provider.dart';
import 'package:namesa/controllers/register_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({super.key});

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  String? _isUser;
  String? _employeeRole;
  String? _gender;
  bool _done = true;
  bool _show = false;

  final TextEditingController _registerusernameCntr = TextEditingController();
  final TextEditingController _registeremailCntr = TextEditingController();
  final TextEditingController _registeraddressCntr = TextEditingController();
  final TextEditingController _registerpasswordCntr = TextEditingController();

  final TextEditingController _emailCntr = TextEditingController();

  final TextEditingController _passwordCntr = TextEditingController();

  int _curIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/NamesaLogo.png", scale: 16 / 9),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  padding: EdgeInsets.all(20.sp),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ToggleSwitch(
                        minWidth: 150,
                        minHeight: 40.0,
                        fontSize: 16.0,
                        initialLabelIndex: _curIndex,
                        activeBgColor: const [Colors.black],
                        activeFgColor: const Color(0xffBE7C01),
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: const Color(0xffBE7C01),
                        totalSwitches: 2,
                        labels: const ["Login", 'Register'],
                        borderColor: const [Color(0xffBE7C01)],
                        borderWidth: 2,
                        dividerColor: const Color(0xffBE7C01),
                        cornerRadius: 20,
                        onToggle: (index) {
                          setState(() {
                            _curIndex = index!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      _curIndex == 0
                          ? ChangeNotifierProvider(
                              create: (context) =>
                                  LoginProvider(ApiService(Dio())),
                              child: Consumer<LoginProvider>(
                                builder: (context, login, child) => Column(
                                  children: [
                                    TextFormField(
                                        controller: _emailCntr,
                                        cursorColor: Colors.black,
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          labelStyle: TextStyle(
                                              color: Color(0xffBE7C01)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                        )),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    TextFormField(
                                        obscureText: !_show,
                                        controller: _passwordCntr,
                                        cursorColor: Colors.black,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _show = !_show;
                                                });
                                              },
                                              icon: !_show
                                                  ? const Icon(
                                                      Icons.remove_red_eye)
                                                  : const Icon(Icons.close)),
                                          labelText: "Password",
                                          labelStyle: const TextStyle(
                                              color: Color(0xffBE7C01)),
                                          enabledBorder:
                                              const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2)),
                                        )),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await login.login(_emailCntr.text,
                                              _passwordCntr.text);
                                          login.errorMessage == null
                                              ? Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const MainScreen()))
                                              : null;
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            backgroundColor: Colors.black,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50.w,
                                                vertical: 5.h)),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                              color: const Color(0xffBE7C01),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    login.errorMessage != null
                                        ? Text(
                                            login.errorMessage!,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            )
                          : ChangeNotifierProvider(
                              create: (context) =>
                                  RegisterProvider(ApiService(Dio())),
                              child: Consumer<RegisterProvider>(
                                builder: (context, register, child) => register
                                        .isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                              controller: _registerusernameCntr,
                                              cursorColor: Colors.black,
                                              onChanged: (s) {
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                helperText:
                                                    "Username must be more than 5 and unique",
                                                helperStyle: TextStyle(
                                                    color: _registerusernameCntr
                                                                .text.isEmpty ||
                                                            _registerusernameCntr
                                                                    .text
                                                                    .length <
                                                                4
                                                        ? const Color(
                                                            0xffD10000)
                                                        : const Color(
                                                            0xff007C04),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelText: "Username",
                                                labelStyle: const TextStyle(
                                                    color: Color(0xffBE7C01)),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2)),
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                              controller: _registeremailCntr,
                                              cursorColor: Colors.black,
                                              onChanged: (s) {
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                helperText:
                                                    "Email must be valid and unique",
                                                helperStyle: TextStyle(
                                                    color: RegExp(
                                                      r"^[a-zA-Z0-9._%+-]{1,20}@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                                    ).hasMatch(
                                                            _registeremailCntr
                                                                .text)
                                                        ? const Color(
                                                            0xff007C04)
                                                        : const Color(
                                                            0xffD10000),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelText: "Email",
                                                labelStyle: const TextStyle(
                                                    color: Color(0xffBE7C01)),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2)),
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                              controller: _registeraddressCntr,
                                              cursorColor: Colors.black,
                                              onChanged: (s) {
                                                setState(() {});
                                              },
                                              decoration: InputDecoration(
                                                helperText:
                                                    "Address must be valid",
                                                helperStyle: TextStyle(
                                                    color: _registeraddressCntr
                                                                .text.isEmpty ||
                                                            _registeraddressCntr
                                                                    .text
                                                                    .length <
                                                                3
                                                        ? const Color(
                                                            0xffD10000)
                                                        : const Color(
                                                            0xff007C04),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                labelText: "Address",
                                                labelStyle: const TextStyle(
                                                    color: Color(0xffBE7C01)),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2)),
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          TextFormField(
                                              obscureText: true,
                                              controller: _registerpasswordCntr,
                                              cursorColor: Colors.black,
                                              onChanged: (s) {
                                                setState(() {});
                                              },
                                              decoration: const InputDecoration(
                                                labelText: "Password",
                                                labelStyle: TextStyle(
                                                    color: Color(0xffBE7C01)),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 2)),
                                              )),
                                          SizedBox(
                                            height: 5.h,
                                          ),
                                          Text(
                                              "Password must contain at least capital letter, non-numeric characters and numbers and more than 5 characters in total",
                                              style: TextStyle(
                                                color: RegExp(
                                                          r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^a-zA-Z\d]).{5,}$",
                                                        ).hasMatch(
                                                            _registerpasswordCntr
                                                                .text) &&
                                                        _registerpasswordCntr
                                                                .text.length >
                                                            5
                                                    ? const Color(0xff007C04)
                                                    : const Color(0xffD10000),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 2)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                items: const [
                                                  DropdownMenuItem<String>(
                                                    value: "User",
                                                    child: Text("User"),
                                                  ),
                                                  DropdownMenuItem<String>(
                                                    value: "Staff",
                                                    child: Text("Staff"),
                                                  ),
                                                ],
                                                hint: const Text(
                                                  "User Type",
                                                  style: TextStyle(
                                                      color: Color(0xffBE7C01)),
                                                ),
                                                iconEnabledColor: Colors.black,
                                                value: _isUser,
                                                onChanged: (val) {
                                                  setState(() {
                                                    _isUser = val!;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                          Text("Type must be chosen",
                                              style: TextStyle(
                                                color: _isUser != null
                                                    ? const Color(0xff007C04)
                                                    : const Color(0xffD10000),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          _isUser == "Staff"
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 2)),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                          isExpanded: true,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          items: const [
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: "Manager",
                                                              child: Text(
                                                                  "Manager"),
                                                            ),
                                                            DropdownMenuItem<
                                                                String>(
                                                              value:
                                                                  "Marketing",
                                                              child: Text(
                                                                  "Marketing"),
                                                            ),
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: "Employee",
                                                              child: Text(
                                                                  "Employee"),
                                                            ),
                                                          ],
                                                          hint: const Text(
                                                            "Employment Type",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffBE7C01)),
                                                          ),
                                                          iconEnabledColor:
                                                              Colors.black,
                                                          value: _employeeRole,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              _employeeRole =
                                                                  val!;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Text("Type must be chosen",
                                                        style: TextStyle(
                                                          color: _employeeRole !=
                                                                  null
                                                              ? const Color(
                                                                  0xff007C04)
                                                              : const Color(
                                                                  0xffD10000),
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                  ],
                                                )
                                              : Container(),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Radio(
                                                    focusColor: Colors.black,
                                                    activeColor: Colors.black,
                                                    value: "Male",
                                                    groupValue: _gender,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _gender = "Male";
                                                      });
                                                    }),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "Male",
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffBE7C01),
                                                        fontSize: 15.sp),
                                                  )),
                                              Expanded(
                                                flex: 1,
                                                child: Radio(
                                                    value: "Female",
                                                    focusColor: Colors.black,
                                                    activeColor: Colors.black,
                                                    groupValue: _gender,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _gender = "Female";
                                                      });
                                                    }),
                                              ),
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "Female",
                                                    style: TextStyle(
                                                        color: const Color(
                                                            0xffBE7C01),
                                                        fontSize: 15.sp),
                                                  )),
                                            ],
                                          ),
                                          Text("Gender must be chosen",
                                              style: TextStyle(
                                                color: _gender != null
                                                    ? const Color(0xff007C04)
                                                    : const Color(0xffD10000),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                if ((_registerusernameCntr
                                                            .text.isNotEmpty &&
                                                        _registerusernameCntr
                                                                .text.length >=
                                                            4) &&
                                                    (RegExp(
                                                      r"^[a-zA-Z0-9._%+-]{1,20}@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                                                    ).hasMatch(
                                                        _registeremailCntr
                                                            .text)) &&
                                                    (_registeraddressCntr
                                                            .text.isNotEmpty &&
                                                        _registeraddressCntr
                                                                .text.length >=
                                                            3) &&
                                                    (RegExp(
                                                          r"^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[^a-zA-Z\d]).{5,}$",
                                                        ).hasMatch(
                                                            _registerpasswordCntr
                                                                .text) &&
                                                        _registerpasswordCntr
                                                                .text.length >=
                                                            5) &&
                                                    (_isUser != null) &&
                                                    (_employeeRole != null ||
                                                        _isUser == "User") &&
                                                    (_gender != null)) {
                                                  setState(() {
                                                    _done = true;
                                                  });
                                                  await register.register(
                                                      _registerusernameCntr
                                                          .text,
                                                      _registeremailCntr.text,
                                                      _registeraddressCntr.text,
                                                      _registerpasswordCntr
                                                          .text,
                                                      _isUser!,
                                                      _employeeRole ?? "",
                                                      _gender!);
                                                  setState(() {
                                                    _curIndex = 0;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _done = false;
                                                  });
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  backgroundColor: Colors.black,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 50.w,
                                                      vertical: 5.h)),
                                              child: Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xffBE7C01),
                                                    fontSize: 16.sp),
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          !_done
                                              ? Text(
                                                  "Make Sure every input is correct",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16.sp),
                                                )
                                              : Container(),
                                        ],
                                      ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
