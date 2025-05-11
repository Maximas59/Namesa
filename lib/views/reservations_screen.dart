import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:namesa/controllers/reserve_provider.dart';
import 'package:namesa/controllers/service_provider.dart';
import 'package:namesa/core/api_services.dart';
import 'package:provider/provider.dart';

class ReservationsScreen extends StatefulWidget {
  const ReservationsScreen({super.key});

  @override
  State<ReservationsScreen> createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  void _showReservationDialog(
      BuildContext context, ReserveProvider provider, int reservationId) {
    showDialog(
      context: context,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        TextEditingController checkInController =
            TextEditingController(text: "${provider.result.data!.from}");
        TextEditingController checkOutController =
            TextEditingController(text: "${provider.result.data!.to}");
        String? selectedPaymentMethod;
        selectedPaymentMethod =
            provider.result.data!.paymentMethod == 1 ? "Cash" : "Credit Card";
        return AlertDialog(
          title: const Text("Update Reservation",
              style: TextStyle(color: Color(0xffBE7C01))),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Reservation ID: $reservationId",
                    style: const TextStyle(color: Color(0xffBE7C01))),

                // Check-in Date
                TextFormField(
                  controller: checkInController,
                  decoration: const InputDecoration(
                    // hintText: "${provider.result.data!.from}",
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
                    // hintText: "${provider.result.data!.to}",
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
                  value: provider.result.data!.paymentMethod == 1
                      ? "Cash"
                      : "Credit Card",
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
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  String checkInDate = checkInController.text;
                  String checkOutDate = checkOutController.text;
                  int paymentMethod = selectedPaymentMethod == "Cash" ? 1 : 2;

                  await provider.updateReservation(
                      reservationId, checkInDate, checkOutDate, paymentMethod);
                  await provider.getAllReservations();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(provider.message),
                      behavior: SnackBarBehavior.fixed,
                      dismissDirection: DismissDirection.startToEnd,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("Update",
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
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ReserveProvider>(context, listen: false)
        .getAllReservations());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) {
      final provider = ReserveProvider(ApiService(Dio()));
      provider.getAllReservations();
      return provider;
    }, child: Consumer<ReserveProvider>(builder: (context, value, child) {
      var pendingReservations =
          value.reservations.where((v) => v['reservationStatus'] == 1).toList();
      // print(pendingReservations);
      var currentRoom =
          value.reservations.where((v) => v['reservationStatus'] == 2).toList();
      // print(currentRoom);
      // print(currentRoom[0]['reservationId']);
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Reservations",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: value.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(10.sp),
                child: value.reservations.isEmpty
                    ? Center(
                        child: Text(
                          "No reservations yet!",
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        children: [
                          currentRoom.isNotEmpty
                              ? Text("Current Room",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20.sp))
                              : Container(),
                          SizedBox(
                            height: 10.h,
                          ),
                          currentRoom.isNotEmpty
                              ? ChangeNotifierProvider(
                                  create: (BuildContext context) =>
                                      ServiceProvider(ApiService(Dio())),
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
                                                  scale: 4.1.sp,
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
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    "${currentRoom[0]['totalPrice']} LE/Day",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.h, left: 8.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${currentRoom[0]['from']} --> ",
                                                style: const TextStyle(
                                                  color: Color(0xffBE7C01),
                                                ),
                                              ),
                                              Text(
                                                " ${currentRoom[0]['to']}",
                                                style: const TextStyle(
                                                  color: Color(0xffBE7C01),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Consumer<ServiceProvider>(
                                          builder: (BuildContext context,
                                              ServiceProvider value,
                                              Widget? child) {
                                            return ElevatedButton(
                                                onPressed: () async {
                                                  value
                                                      .getAllAvailableService();
                                                  var availableService =
                                                      value.available.data;
                                                  // print(
                                                  //     availableService!.length);
                                                  int serviceId =
                                                      availableService![0].id!;
                                                  await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "Requesting a service"),
                                                            content:
                                                                DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton(
                                                                isExpanded:
                                                                    true,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                // dropdownColor: Color(0xffBE7C01),
                                                                style: TextStyle(
                                                                    color: const Color(
                                                                        0xffBE7C01),
                                                                    fontSize:
                                                                        14.sp),
                                                                focusColor:
                                                                    const Color(
                                                                        0xffBE7C01),
                                                                items: List
                                                                    .generate(
                                                                        availableService
                                                                            .length,
                                                                        (i) =>
                                                                            DropdownMenuItem<int>(
                                                                              value: availableService[i].id,
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  availableService[i].serviceType == 1
                                                                                      ? const Text("House Keeping")
                                                                                      : availableService[i].serviceType == 2
                                                                                          ? const Text("Restaurant Reserve")
                                                                                          : availableService[i].serviceType == 3
                                                                                              ? const Text("Request A Meal On Room")
                                                                                              : const Text("Other"),
                                                                                  Text("Price: ${availableService[i].serviceFees!.toString()}"),
                                                                                ],
                                                                              ),
                                                                            )),
                                                                hint:
                                                                    const Text(
                                                                  "Service Type",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xffBE7C01)),
                                                                ),
                                                                iconEnabledColor:
                                                                    const Color(
                                                                        0xffBE7C01),
                                                                value:
                                                                    serviceId,
                                                                onChanged:
                                                                    (val) {
                                                                  setState(() {
                                                                    serviceId =
                                                                        val!;
                                                                  });
                                                                  print(
                                                                      serviceId);
                                                                },
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                                child: const Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xffBE7C01))),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  await value
                                                                      .requestAService(
                                                                          serviceId);
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content: Text(
                                                                          value
                                                                              .message!),
                                                                      behavior:
                                                                          SnackBarBehavior
                                                                              .fixed,
                                                                      dismissDirection:
                                                                          DismissDirection
                                                                              .startToEnd,
                                                                    ),
                                                                  );
                                                                  Navigator.pop(
                                                                      context);
                                                                  // create
                                                                  //     .getAllService();
                                                                },
                                                                child: const Text(
                                                                    "Request",
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xffBE7C01))),
                                                              ),
                                                            ]);
                                                      });
                                                },
                                                child: const Text(
                                                    "Request a service"));
                                          },
                                        ),
                                        ElevatedButton(
                                            onPressed: () async {
                                              // print(
                                              //     "currentRoom[0]['reservationId']");
                                              // print(currentRoom[0]
                                              //     ['reservationId']);
                                              try {
                                                value.checkout(currentRoom[0]
                                                    ['reservationId']);
                                                // await MyCache.clear();
                                                // Navigator.of(context)
                                                //     .pushReplacement(
                                                //         MaterialPageRoute(
                                                //             builder: (context) =>
                                                //                 const LoginRegisterScreen()));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content:
                                                        Text(value.message),
                                                    behavior:
                                                        SnackBarBehavior.fixed,
                                                    dismissDirection:
                                                        DismissDirection
                                                            .startToEnd,
                                                  ),
                                                );
                                              } catch (e) {
                                                print(e.toString());
                                              }
                                            },
                                            child: const Text("Checkout"))
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text("Pending Reservations",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20.sp)),
                          SizedBox(
                            height: 10.h,
                          ),
                          ...List.generate(
                              pendingReservations.length,
                              (i) => InkWell(
                                    onTap: () async {
                                      await value.getReservationDetails(value
                                          .reservations[i]['reservationId']);
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text("Details"),
                                                content: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                        "Owner: ${value.result.data!.guestName!}"),
                                                    Text(
                                                        "Price: ${value.result.data!.totalPrice!}"),
                                                    Text(
                                                        "From: ${value.result.data!.from!}"),
                                                    Text(
                                                        "To: ${value.result.data!.to!}"),
                                                    Text(
                                                        "Total Days: ${value.result.data!.totalNumberOfDays!}"),
                                                    Text(
                                                        "Payment Method: ${value.result.data!.paymentMethod == 1 ? "Cash" : "Credit Card"}"),
                                                    value.result.data!
                                                                .reservationStatus ==
                                                            1
                                                        ? const Text(
                                                            "Status: Pending")
                                                        : value.result.data!
                                                                    .reservationStatus ==
                                                                2
                                                            ? const Text(
                                                                "Status: Approved")
                                                            : const Text(
                                                                "Status: Rejected")
                                                  ],
                                                ),
                                              ));
                                    },
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5.h),
                                      child: ListTile(
                                        tileColor: Colors.white,
                                        title: Text(
                                          "Room: ${pendingReservations[i]['reservationId']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                            "Price: ${pendingReservations[i]['totalPrice']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            pendingReservations[i]
                                                        ["reservationStatus"] ==
                                                    1
                                                ? IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.money_off))
                                                : pendingReservations[i][
                                                            "reservationStatus"] ==
                                                        2
                                                    ? IconButton(
                                                        onPressed: () {},
                                                        style: IconButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .green),
                                                        icon: const Icon(
                                                          Icons.monetization_on,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        icon: const Icon(
                                                            Icons.cancel),
                                                        onPressed: () {},
                                                      ),
                                            IconButton(
                                              onPressed: () async {
                                                await value.cancelReservation(
                                                    pendingReservations[i]
                                                        ['reservationId']);

                                                await value
                                                    .getAllReservations();
                                                if (value
                                                    .reservations.isEmpty) {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 100),
                                                      () {
                                                    setState(
                                                        () {}); // Ensure the UI rebuilds
                                                  });
                                                }

                                                if (value.message.isNotEmpty) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          value.message,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      dismissDirection:
                                                          DismissDirection
                                                              .startToEnd,
                                                    ),
                                                  );
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.black,
                                              ),
                                              style: IconButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await value
                                                      .getReservationDetails(
                                                          pendingReservations[i]
                                                              [
                                                              'reservationId']);
                                                  _showReservationDialog(
                                                      context,
                                                      value,
                                                      pendingReservations[i]
                                                          ['reservationId']);
                                                },
                                                icon: const Icon(Icons.edit)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                        ],
                      ),
              ),
      );
    }));
  }
}
