import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/all_rooms_provider.dart';
import 'package:namesa/controllers/room_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:namesa/views/all_rooms_screen.dart';
import 'package:namesa/views/notifications_screen.dart';
import 'package:namesa/views/room_details_screen.dart';
import 'package:provider/provider.dart';

import '../controllers/room_details_provider.dart';
import '../controllers/service_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showCreateRoomDialog(BuildContext context, RoomProvider create) {
    final TextEditingController priceController = TextEditingController();
    final TextEditingController capacityController = TextEditingController();
    bool isAvailable = true;
    String? roomType;
    String? error;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Room",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(4),
                      // dropdownColor: Color(0xffBE7C01),
                      style: TextStyle(
                          color: const Color(0xffBE7C01), fontSize: 14.sp),
                      focusColor: const Color(0xffBE7C01),
                      items: const [
                        DropdownMenuItem<String>(
                          value: "Single",
                          child: Text("Single"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Double",
                          child: Text("Double"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Triple",
                          child: Text("Triple"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Suite",
                          child: Text("Suite"),
                        ),
                        DropdownMenuItem<String>(
                          value: "Royal Suite",
                          child: Text("Royal Suite"),
                        ),
                        DropdownMenuItem<String>(
                          value: "King",
                          child: Text("King"),
                        ),
                      ],
                      hint: const Text(
                        "Room Type",
                        style: TextStyle(color: Color(0xffBE7C01)),
                      ),
                      iconEnabledColor: const Color(0xffBE7C01),
                      value: roomType,
                      onChanged: (val) {
                        setState(() {
                          roomType = val!;
                        });
                      },
                    ),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Price",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: capacityController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Number of Beds",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("On Sea",
                          style: TextStyle(color: Color(0xffBE7C01))),
                      Switch(
                        activeColor: const Color(0xffBE7C01),
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          return Colors.white;
                        }),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black,
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                  error != null
                      ? Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      priceController.text.runtimeType.toString() != "double"
                          ? error = "Check inputs"
                          : null;
                      capacityController.text.runtimeType.toString() != "int"
                          ? error = "Check inputs"
                          : null;
                    });
                    await create.createRoom(
                      roomType!,
                      double.parse(priceController.text),
                      int.parse(capacityController.text),
                      isAvailable,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(create.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Create",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showUpdateRoomDialog(BuildContext context, RoomProvider update) {
    final TextEditingController roomIdController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController capacityController = TextEditingController();
    bool isAvailable = true;
    String error = "";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Room",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: roomIdController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Room Id",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                  ),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Room Type",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Price",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: capacityController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Number of Beds",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("On Sea",
                          style: TextStyle(color: Color(0xffBE7C01))),
                      Switch(
                        activeColor: const Color(0xffBE7C01),
                        thumbColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          return Colors.white;
                        }),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black,
                        value: isAvailable,
                        onChanged: (value) {
                          setState(() {
                            isAvailable = value;
                          });
                        },
                      ),
                    ],
                  ),
                  error.isNotEmpty
                      ? Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      priceController.text.runtimeType.toString() != "double"
                          ? error = "Check inputs"
                          : null;
                      capacityController.text.runtimeType.toString() != "int"
                          ? error = "Check inputs"
                          : null;
                      roomIdController.text.runtimeType.toString() != "int"
                          ? error = "Check inputs"
                          : null;
                    });
                    await update.updateRoom(
                      int.parse(roomIdController.text),
                      typeController.text,
                      double.parse(priceController.text),
                      int.parse(capacityController.text),
                      isAvailable,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(update.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Update",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteRoomDialog(BuildContext context, RoomProvider delete) {
    final TextEditingController roomIdController = TextEditingController();
    String error = "";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Room",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: roomIdController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Room Id",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                  ),
                  error.isNotEmpty
                      ? Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      roomIdController.text.runtimeType.toString() != "int"
                          ? error = "Check inputs"
                          : null;
                    });
                    await delete
                        .deleteRoom(int.tryParse(roomIdController.text)!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(delete.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Delete",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showCreateServiceDialog(BuildContext context, ServiceProvider create) {
    // final TextEditingController serviceTypeController = TextEditingController();
    final TextEditingController serviceFeesController = TextEditingController();
    int serviceType = 1;
    // double? serviceFees;
    String? error;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create Service",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(4),
                      // dropdownColor: Color(0xffBE7C01),
                      style: TextStyle(
                          color: const Color(0xffBE7C01), fontSize: 14.sp),
                      focusColor: const Color(0xffBE7C01),
                      items: const [
                        //HouseKeeping = 1,
                        // RestrauntReserve,
                        // RequestMealOnRoom,
                        // other
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("House Keeping"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Restaurant Reserve"),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text("Request Meal On Room"),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text("Other"),
                        ),
                      ],
                      hint: const Text(
                        "Service Type",
                        style: TextStyle(color: Color(0xffBE7C01)),
                      ),
                      iconEnabledColor: const Color(0xffBE7C01),
                      value: serviceType,
                      onChanged: (val) {
                        setState(() {
                          serviceType = val!;
                        });
                      },
                    ),
                  ),
                  TextField(
                    controller: serviceFeesController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Service Fees",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  error != null
                      ? Text(
                          error!,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container(),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      double.parse(serviceFeesController.text) < 0
                          ? error = "Check Fees"
                          : null;
                      serviceType <= 0 || serviceType >= 4
                          ? error = "Check Type"
                          : null;
                    });
                    await create.createService(
                        serviceType,
                        double.tryParse(serviceFeesController.text) ??
                            int.parse(serviceFeesController.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(create.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                    create.getAllService();
                  },
                  child: const Text("Create",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showUpdateServiceDialog(BuildContext context, ServiceProvider update) {
    // final TextEditingController serviceIdController = TextEditingController();
    final TextEditingController serviceTypeController = TextEditingController();
    final TextEditingController serviceFeesController = TextEditingController();
    // bool isAvailable = true;
    String error = "";
    int serviceId = 0;
    int serviceType = 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Update Service",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // TextField(
                  //   controller: serviceIdController,
                  //   decoration: const InputDecoration(
                  //       enabledBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Color(0xffBE7C01))),
                  //       focusedBorder: UnderlineInputBorder(
                  //           borderSide: BorderSide(color: Color(0xffBE7C01))),
                  //       labelText: "Service Id",
                  //       labelStyle: TextStyle(color: Color(0xffBE7C01))),
                  // ),
                  DropdownButtonHideUnderline(
                      child: DropdownButton(
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(4),
                    // dropdownColor: Color(0xffBE7C01),
                    style: TextStyle(
                        color: const Color(0xffBE7C01), fontSize: 14.sp),
                    focusColor: const Color(0xffBE7C01),
                    items: List.generate(update.result.data!.length, (i) {
                      serviceId = update.result.data![i].id!;
                      return DropdownMenuItem<int>(
                        value: update.result.data![i].id,
                        child:
                            Text("Service Id : ${update.result.data![i].id}"),
                      );
                    }),
                    hint: const Text(
                      "Service Id",
                      style: TextStyle(color: Color(0xffBE7C01)),
                    ),
                    iconEnabledColor: const Color(0xffBE7C01),
                    value: serviceId,
                    onChanged: (val) {
                      setState(() {
                        serviceId = val!;
                      });
                    },
                  )),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(4),
                      // dropdownColor: Color(0xffBE7C01),
                      style: TextStyle(
                          color: const Color(0xffBE7C01), fontSize: 14.sp),
                      focusColor: const Color(0xffBE7C01),
                      items: const [
                        //HouseKeeping = 1,
                        // RestrauntReserve,
                        // RequestMealOnRoom,
                        // other
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("House Keeping"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Restaurant Reserve"),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text("Request Meal On Room"),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text("Other"),
                        ),
                      ],
                      hint: const Text(
                        "Service Type",
                        style: TextStyle(color: Color(0xffBE7C01)),
                      ),
                      iconEnabledColor: const Color(0xffBE7C01),
                      value: serviceType,
                      onChanged: (val) {
                        setState(() {
                          serviceType = val!;
                        });
                      },
                    ),
                  ),

                  TextField(
                    controller: serviceFeesController,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffBE7C01))),
                        labelText: "Fees",
                        labelStyle: TextStyle(color: Color(0xffBE7C01))),
                    keyboardType: TextInputType.number,
                  ),
                  error.isNotEmpty
                      ? Text(
                          error,
                          style: const TextStyle(color: Colors.red),
                        )
                      : Container()
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      double.parse(serviceFeesController.text) < 0
                          ? error = "Check Fees"
                          : null;
                    });
                    await update.updateService(
                      serviceId,
                      serviceType,
                      double.parse(serviceFeesController.text),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(update.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                    update.getAllService();
                  },
                  child: const Text("Update",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteServiceDialog(BuildContext context, ServiceProvider delete) {
    // final TextEditingController roomIdController = TextEditingController();
    int serviceId = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Delete Service",
                  style: TextStyle(color: Color(0xffBE7C01))),
              content: DropdownButtonHideUnderline(
                  child: DropdownButton(
                isExpanded: true,
                borderRadius: BorderRadius.circular(4),
                // dropdownColor: Color(0xffBE7C01),
                style:
                    TextStyle(color: const Color(0xffBE7C01), fontSize: 14.sp),
                focusColor: const Color(0xffBE7C01),
                items: List.generate(delete.result.data!.length, (i) {
                  serviceId = delete.result.data![i].id!;
                  return DropdownMenuItem<int>(
                    value: delete.result.data![i].id,
                    child: Text("Service Id : ${delete.result.data![i].id}"),
                  );
                }),
                hint: const Text(
                  "Service Id",
                  style: TextStyle(color: Color(0xffBE7C01)),
                ),
                iconEnabledColor: const Color(0xffBE7C01),
                value: serviceId,
                onChanged: (val) {
                  setState(() {
                    serviceId = val!;
                    // print(serviceId);
                  });
                },
              )),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
                TextButton(
                  onPressed: () async {
                    await delete.deleteService(serviceId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(delete.message!),
                        behavior: SnackBarBehavior.fixed,
                        dismissDirection: DismissDirection.startToEnd,
                      ),
                    );
                    Navigator.pop(context);
                    delete.getAllService();
                  },
                  child: const Text("Delete",
                      style: TextStyle(color: Color(0xffBE7C01))),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<AllRoomsProvider>(context, listen: false).viewAllRooms());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(MyCache.getString(key: 'token'));
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: MyCache.getString(key: "role") == "Staff"
          ? AppBar(
              title: const Text(
                "Staff Management",
                style: TextStyle(color: Color(0xffBE7C01)),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const NotificationsScreen()));
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: const Color(0xffBE7C01),
                        size: 24.sp,
                      ))
                ])
          : AppBar(
              title: Text(
                "Hello, ${MyCache.getString(key: "name")}",
                // textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()));
                    },
                    icon: Icon(
                      Icons.notifications,
                      color: const Color(0xffBE7C01),
                      size: 24.sp,
                    ))
              ],
            ),
      body: MyCache.getString(key: "role") == "Staff"
          ? ChangeNotifierProvider(
              create: (context) {
                var provider = ServiceProvider(ApiService(Dio()));
                provider.getAllService();
                return provider;
              },
              child: ChangeNotifierProvider(
                create: (context) => RoomProvider(ApiService(Dio())),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Consumer<RoomProvider>(
                        builder: (context, create, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showCreateRoomDialog(context, create),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Create Room",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: const Color(0xffBE7C01),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Consumer<RoomProvider>(
                        builder: (context, update, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showUpdateRoomDialog(context, update),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Update Room",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xffBE7C01)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Consumer<RoomProvider>(
                        builder: (context, delete, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showDeleteRoomDialog(context, delete),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Delete Room",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xffBE7C01)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Consumer<ServiceProvider>(
                        builder: (context, create, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showCreateServiceDialog(context, create),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Create Service",
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: const Color(0xffBE7C01),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Consumer<ServiceProvider>(
                        builder: (context, update, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: ElevatedButton(
                            onPressed: () =>
                                _showUpdateServiceDialog(context, update),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: Text(
                              "Update Service",
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: const Color(0xffBE7C01)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Consumer<ServiceProvider>(
                        builder: (context, delete, child) => SizedBox(
                          width: MediaQuery.of(context).size.width - 50.w,
                          child: delete.result.data!.isEmpty
                              ? null
                              : ElevatedButton(
                                  onPressed: () =>
                                      _showDeleteServiceDialog(context, delete),
                                  style: ElevatedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Text(
                                    "Delete Service",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        color: const Color(0xffBE7C01)),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
          : Padding(
              padding: const EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Rooms",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      AllRoomsProvider(ApiService(Dio())),
                                  child: const AllRoomsScreen())));
                        },
                        child: Text(
                          "See All",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ChangeNotifierProvider(
                      create: (context) => AllRoomsProvider(ApiService(Dio())),
                      child: Consumer<AllRoomsProvider>(
                        builder: (context, allRooms, child) =>
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: allRooms.isLoading
                                    ? const CircularProgressIndicator()
                                    : Row(
                                        children: List.generate(
                                            allRooms.result.isEmpty
                                                ? allRooms
                                                    .result["data"]
                                                        ["allRoomsDtos"]
                                                    .length
                                                : 1,
                                            (i) => InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ChangeNotifierProvider(
                                                                  create: (BuildContext
                                                                          context) =>
                                                                      RoomDetailsProvider(
                                                                          ApiService(
                                                                              Dio())),
                                                                  child: RoomDetailsScreen(
                                                                      allRooms.result["data"]
                                                                              [
                                                                              "allRoomsDtos"][i]
                                                                          [
                                                                          'id']),
                                                                )));
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.sp),
                                                          child: Stack(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    Image.asset(
                                                                  "assets/images/suite.png",
                                                                  scale: 4.5.sp,
                                                                ),
                                                              ),
                                                              Positioned(
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  child: Text(
                                                                    "${allRooms.result["data"]["allRoomsDtos"][i]['price']} LE/Day",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                  // top: 20,
                                                                  right: 10.sp,
                                                                  child: IconButton(
                                                                      onPressed: () {},
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Colors
                                                                            .white,
                                                                      )))
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5.h,
                                                                  left: 8.w),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            // mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(
                                                                Icons.star,
                                                                size: 16.sp,
                                                                color: const Color(
                                                                    0xffBE7C01),
                                                              ),
                                                              Text(
                                                                " ${allRooms.result["data"]["allRoomsDtos"][i]['rate']}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xffBE7C01),
                                                                ),
                                                              ),
                                                              Text(
                                                                " (${allRooms.result["data"]["allRoomsDtos"][i]['numberOfReviewers']})",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xffBE7C01),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.w),
                                                          child: Text(
                                                            "${allRooms.result["data"]["allRoomsDtos"][i]['roomType']}",
                                                            style: TextStyle(
                                                                color: const Color(
                                                                    0xffBE7C01),
                                                                fontSize:
                                                                    18.sp),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Icon(
                                                                Icons.bed,
                                                                color: Color(
                                                                    0xffBE7C01)),
                                                            Text(
                                                              allRooms.result["data"]["allRoomsDtos"]
                                                                              [
                                                                              i]
                                                                          [
                                                                          'numberOfBeds'] >
                                                                      1
                                                                  ? "${allRooms.result["data"]["allRoomsDtos"][i]['numberOfBeds']} Beds"
                                                                  : "${allRooms.result["data"]["allRoomsDtos"][i]['numberOfBeds']} Bed",
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xffBE7C01)),
                                                            ),
                                                            SizedBox(
                                                              width: 12.w,
                                                            ),
                                                            const Icon(
                                                                Icons.wifi,
                                                                color: Color(
                                                                    0xffBE7C01)),
                                                            const Text(
                                                              "Wifi",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xffBE7C01)),
                                                            ),
                                                            SizedBox(
                                                              width: 12.w,
                                                            ),
                                                            const Icon(
                                                                Icons
                                                                    .fitness_center,
                                                                color: Color(
                                                                    0xffBE7C01)),
                                                            const Text(
                                                              "Gym",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xffBE7C01)),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                      )),
                      )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Restaurants",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                      ),
                      InkWell(
                        child: Text(
                          "See All",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                        6,
                        (i) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      "assets/images/restaurant.png",
                                      scale: 4.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Green Palace",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Steak House",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  size: 16.sp,
                                                  color:
                                                      const Color(0xffBE7C01),
                                                ),
                                                const Text(
                                                  "4.4",
                                                  style: TextStyle(
                                                    color: Color(0xffBE7C01),
                                                  ),
                                                ),
                                                const Text(
                                                  "(480)",
                                                  style: TextStyle(
                                                    color: Color(0xffBE7C01),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  )
                ],
              ),
            ),
    );
  }
}
