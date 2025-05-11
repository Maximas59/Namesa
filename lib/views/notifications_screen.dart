import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/service_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/core/cached_data.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        var provider = ServiceProvider(ApiService(Dio()));
        provider.getAllUserServices();
        provider.getAllMyRequestedServices();
        provider.getAllUserReservations();
        return provider;
      },
      child: Consumer<ServiceProvider>(
        builder: (BuildContext context, ServiceProvider value, Widget? child) {
          // print("value.userServices");
          // print(value.userReservations.length);
          // print(value.userServices.length);
          // print(MyCache.getString(key: 'role'));
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
                title: const Text(
                  "Notifications",
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
            body: MyCache.getString(key: "role") == 'Staff'
                ? value.userServices.length == 0 &&
                        value.userReservations.length == 0
                    ? Center(
                        child: Text(
                        "No Notifications for now",
                        style: TextStyle(color: Colors.white, fontSize: 24.sp),
                      ))
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text("Services Requested",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20.sp)),
                            ...List.generate(
                                value.userServices.length,
                                (i) => ListTile(
                                      contentPadding: const EdgeInsets.all(8),
                                      tileColor: Colors.white,
                                      title: Text(
                                          "${value.userServices[i]['guestName']} requested ${value.userServices[i]['serviceType'] == 1 ? "House Keeping" : value.userServices[i]['serviceType'] == 2 ? "Restaurant Reserve" : value.userServices[i]['serviceType'] == 3 ? "Requested a Meal On Room" : "Other"}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                              onPressed: () async {
                                                await value.approveUserService(
                                                    value.userServices[i]
                                                        ['serviceId'],
                                                    value.userServices[i]
                                                        ['guestId']);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(value.message!),
                                                    behavior:
                                                        SnackBarBehavior.fixed,
                                                    dismissDirection:
                                                        DismissDirection
                                                            .startToEnd,
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.check_circle,
                                                size: 24.sp,
                                                color: Colors.green,
                                              )),
                                          IconButton(
                                              onPressed: () async {
                                                await value.rejectUserService(
                                                    value.userServices[i]
                                                        ['serviceId'],
                                                    value.userServices[i]
                                                        ['guestId']);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(value.message!),
                                                    behavior:
                                                        SnackBarBehavior.fixed,
                                                    dismissDirection:
                                                        DismissDirection
                                                            .startToEnd,
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.cancel,
                                                  size: 24.sp,
                                                  color: Colors.red)),
                                        ],
                                      ),
                                    )),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Reservations Requested",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20.sp),
                            ),
                            ...List.generate(
                                value.userReservations.length,
                                (i) => Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.sp),
                                      child: ListTile(
                                        contentPadding: const EdgeInsets.all(8),
                                        tileColor: Colors.white,
                                        title: Text(
                                            "${value.userReservations[i]['guestName']} requested a room"),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  await value
                                                      .approveUserReservations(
                                                          value.userReservations[
                                                              i]['id']);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(value.message!),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      dismissDirection:
                                                          DismissDirection
                                                              .startToEnd,
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.check_circle,
                                                  size: 24.sp,
                                                  color: Colors.green,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  await value
                                                      .rejectUserReservations(
                                                          value.userReservations[
                                                              i]['id']);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content:
                                                          Text(value.message!),
                                                      behavior: SnackBarBehavior
                                                          .fixed,
                                                      dismissDirection:
                                                          DismissDirection
                                                              .startToEnd,
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.cancel,
                                                    size: 24.sp,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    )),
                          ],
                        ),
                      )
                : value.requestedServices.length == 0
                    ? Center(
                        child: Text(
                        "No Notifications for now",
                        style: TextStyle(color: Colors.white, fontSize: 24.sp),
                      ))
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.sp),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Requested Services",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp),
                            ),
                          ],
                        ),
                      ),
          );
        },
      ),
    );
  }
}
