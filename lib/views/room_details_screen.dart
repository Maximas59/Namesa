import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/reserve_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:provider/provider.dart';

import '../controllers/room_details_provider.dart';

class RoomDetailsScreen extends StatefulWidget {
  final int roomId;

  const RoomDetailsScreen(this.roomId, {super.key});

  @override
  State<RoomDetailsScreen> createState() => _RoomDetailsScreenState();
}

class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController checkInController = TextEditingController();
  TextEditingController checkOutController = TextEditingController();
  String? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RoomDetailsProvider>(context, listen: false)
            .viewRoomDetails(widget.roomId));
  }

  void _showReservationDialog(BuildContext context, ReserveProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reserve Room",
              style: TextStyle(color: Color(0xffBE7C01))),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Room ID: ${widget.roomId}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xffBE7C01))),

                // Check-in Date
                TextFormField(
                  controller: checkInController,
                  decoration: const InputDecoration(
                    labelText: "Check-in Date",
                    labelStyle: TextStyle(color: Color(0xffBE7C01)),
                    hintText: "YYYY-MM-DD",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkInController),
                  validator: (value) =>
                      value!.isEmpty ? "Please select check-in date" : null,
                ),

                // Check-out Date
                TextFormField(
                  controller: checkOutController,
                  decoration: const InputDecoration(
                    labelText: "Check-out Date",
                    labelStyle: TextStyle(color: Color(0xffBE7C01)),
                    hintText: "YYYY-MM-DD",
                    hintStyle: TextStyle(color: Color(0xffBE7C01)),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context, checkOutController),
                  validator: (value) =>
                      value!.isEmpty ? "Please select check-out date" : null,
                ),

                // Payment Method Dropdown
                DropdownButtonFormField<String>(
                  value: selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: "Payment Method",
                    labelStyle: TextStyle(color: Color(0xffBE7C01)),
                  ),
                  items: ["Cash", "Credit Card"]
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPaymentMethod = value;
                      if (selectedPaymentMethod == "Credit Card") {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("Credit Card"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.credit_card),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Card Holder Name",
                                            hintStyle: TextStyle(
                                                color: Color(0xffBE7C01)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffBE7C01)))),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "16 digits",
                                            hintStyle: TextStyle(
                                                color: Color(0xffBE7C01)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffBE7C01)))),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "Expiry Date",
                                            hintStyle: TextStyle(
                                                color: Color(0xffBE7C01)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffBE7C01)))),
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                            hintText: "CVC",
                                            hintStyle: TextStyle(
                                                color: Color(0xffBE7C01)),
                                            enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffBE7C01)))),
                                      )
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancel",
                                          style: TextStyle(
                                              color: Color(0xffBE7C01))),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done",
                                          style: TextStyle(
                                              color: Color(0xffBE7C01))),
                                    ),
                                  ],
                                ));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (_) => const CreditCardScreen()));
                      }
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a payment method" : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xffBE7C01))),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  int roomId = widget.roomId;
                  String checkInDate = checkInController.text;
                  String checkOutDate = checkOutController.text;
                  int paymentMethod = selectedPaymentMethod == "Cash" ? 1 : 2;

                  await provider.reserveRoom(
                      roomId, checkInDate, checkOutDate, paymentMethod);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(provider.result.message!),
                      behavior: SnackBarBehavior.fixed,
                      dismissDirection: DismissDirection.startToEnd,
                    ),
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
              child: const Text("Reserve",
                  style: TextStyle(color: Color(0xffBE7C01))),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ReserveProvider(ApiService(Dio())),
      child: Consumer<ReserveProvider>(
        builder: (context, value, child) => Consumer<RoomDetailsProvider>(
          builder: (context, roomDetails, child) {
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: roomDetails.result.data!.isAvaliable!
                    ? ElevatedButton(
                        onPressed: () => _showReservationDialog(context, value),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffBE7C01)),
                        child: Text(
                          "Reserve",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          "Reserved",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                backgroundColor: Colors.black,
                body: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Image.asset('assets/images/suite.png'),
                      SizedBox(height: 10.h),
                      Text(
                        "Room Type: ${roomDetails.result.data!.roomType!}",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Number of beds: ${roomDetails.result.data!.numberOfBeds!}",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Price: ${roomDetails.result.data!.price!} EGP",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "On Sea: ${roomDetails.result.data!.isSea! ? "Yes" : "No"}",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Text(
                            "Rate: ${roomDetails.result.data!.rate!}",
                            style:
                                TextStyle(fontSize: 24.sp, color: Colors.white),
                          ),
                          Icon(Icons.star,
                              size: 30.sp, color: const Color(0xffBE7C01)),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Number of reviewers: ${roomDetails.result.data!.numberOfReviewers!}",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Available: ${roomDetails.result.data!.isAvaliable! ? "Yes" : "No"}",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ));
          },
        ),
      ),
    );
  }
}
