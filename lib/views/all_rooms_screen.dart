import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/all_rooms_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:namesa/views/room_details_screen.dart';
import 'package:provider/provider.dart';

import '../controllers/room_details_provider.dart';

class AllRoomsScreen extends StatefulWidget {
  const AllRoomsScreen({super.key});

  @override
  State<AllRoomsScreen> createState() => _AllRoomsScreenState();
}

class _AllRoomsScreenState extends State<AllRoomsScreen> {
  int _pageIndex = 1;
  int _length = 1;
  int _curIndex = 1;

  @override
  void initState() {
    Future.microtask(() => Provider.of<AllRoomsProvider>(context, listen: false)
        .viewAllRooms(pageIndex: _pageIndex));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "All Rooms",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<AllRoomsProvider>(
              builder: (context, allRooms, child) {
                _length = allRooms.result["data"]["allRoomsDtos"].length;
                return allRooms.result["data"]["allRoomsDtos"].length != 0
                    ? GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 1.w,
                            crossAxisSpacing: 1.h,
                            childAspectRatio: 0.95),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: List.generate(
                            allRooms.result != null
                                ? allRooms.result["data"]["allRoomsDtos"].length
                                : 2,
                            (i) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeNotifierProvider(
                                                  create: (BuildContext
                                                          context) =>
                                                      RoomDetailsProvider(
                                                          ApiService(Dio())),
                                                  child: RoomDetailsScreen(
                                                      allRooms.result["data"]
                                                              ["allRoomsDtos"]
                                                          [i]['id']),
                                                )));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          padding: EdgeInsets.all(8.sp),
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Image.asset(
                                                  "assets/images/suite.png",
                                                  scale: 4.sp,
                                                ),
                                              ),
                                              Positioned(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  padding: EdgeInsets.all(8.sp),
                                                  child: Text(
                                                    "${allRooms.result["data"]["allRoomsDtos"][i]['price']} LE/Day",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                  // top: 20,
                                                  right: 2.sp,
                                                  child: IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.white,
                                                        size: 16.sp,
                                                      )))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.h, left: 8.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 12.sp,
                                                color: const Color(0xffBE7C01),
                                              ),
                                              Text(
                                                " ${allRooms.result["data"]["allRoomsDtos"][i]['rate']}",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xffBE7C01),
                                                ),
                                              ),
                                              Text(
                                                " (${allRooms.result["data"]["allRoomsDtos"][i]['numberOfReviewers']})",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xffBE7C01),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${allRooms.result["data"]["allRoomsDtos"][i]['roomType']}",
                                          style: TextStyle(
                                              color: const Color(0xffBE7C01),
                                              fontSize: 12.sp),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.bed,
                                              color: const Color(0xffBE7C01),
                                              size: 12.sp,
                                            ),
                                            Text(
                                              allRooms.result["data"]
                                                              ["allRoomsDtos"]
                                                          [i]['numberOfBeds'] >
                                                      1
                                                  ? " ${allRooms.result["data"]["allRoomsDtos"][i]['numberOfBeds']} Beds"
                                                  : " ${allRooms.result["data"]["allRoomsDtos"][i]['numberOfBeds']} Bed",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xffBE7C01)),
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Icon(Icons.wifi,
                                                size: 12.sp,
                                                color: const Color(0xffBE7C01)),
                                            Text(
                                              " Wifi",
                                              style: TextStyle(
                                                color: const Color(0xffBE7C01),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Icon(
                                              Icons.fitness_center,
                                              color: const Color(0xffBE7C01),
                                              size: 12.sp,
                                            ),
                                            Text(
                                              " Gym",
                                              style: TextStyle(
                                                color: const Color(0xffBE7C01),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    : Center(
                        child: Text(
                          "No More Rooms",
                          style:
                              TextStyle(color: Colors.white, fontSize: 24.sp),
                        ),
                      );
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      if (_curIndex > 1) {
                        setState(() {
                          _pageIndex -= 6;
                          _curIndex--;
                          Provider.of<AllRoomsProvider>(context, listen: false)
                              .viewAllRooms(pageIndex: _pageIndex);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xffBE7C01)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.sp, vertical: 5.sp),
                    child: Text(
                      "$_curIndex",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    )),
                IconButton(
                    onPressed: () {
                      if (_length != 0) {
                        setState(() {
                          _pageIndex += 6;
                          _curIndex++;
                          Provider.of<AllRoomsProvider>(context, listen: false)
                              .viewAllRooms(pageIndex: _pageIndex);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    )),
              ],
            )
          ],
        ));
  }
}
