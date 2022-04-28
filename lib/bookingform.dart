// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookingForm extends StatefulWidget {
  const BookingForm({Key? key}) : super(key: key);

  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final name_Controller = TextEditingController();
  final address_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final rating_Controller = TextEditingController();
  final date_Controller = TextEditingController();

  String msg = '';
  String url = 'https://carwaan.herokuapp.com/car/';
  final storage = const FlutterSecureStorage();
  var car;
  late DateTimeRange myDateTime;


  booking() async{
    setState(() {
      msg = 'Booking...';
    });
    print ("aaa");

    print ("aaa"+myDateTime.toString());

    String name = name_Controller.value.text;
    String address = address_Controller.value.text;
    String phone = phone_Controller.value.text;
    String rating = rating_Controller.value.text;

    if (name == '' || address == '' || phone == '' ) {
      setState(() {
        msg = '*Enter All Information';
      });
      return;
    }

    var carId = await storage.read(key: "carId");
    var token = await storage.read(key: "token");
    var response = await http.post(Uri.parse(url + 'bookacar'), body:{"carId": carId, "address": address, "token": token,
      "year": myDateTime.start.year.toString(), "month": myDateTime.start.month.toString(), "day": myDateTime.start.day.toString(), "difference": myDateTime.duration.inDays.toString() , "ends": myDateTime.end.toUtc().millisecondsSinceEpoch.toString() });

    Map resMap = json.decode(response.body);

    if(resMap.containsKey("success")){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Car Requested!"),
              content: const Text(
                "The car has been requested, please wait for acceptance from the dealer.",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false);
                  },
                  child: const Text(
                    "Okay",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          });
    } else if (resMap.keys.contains('error')) {
      String err = resMap["error"];
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Alert!"),
              content: Text(
                err,
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Okay",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            );
          });
      setState(() {
        msg = '';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
              );
            },
          ),
          title: const Text(
            "CARWAAN",
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        drawer: const DrawerWidget(),
        body: Stack(
          children: [
            Image.asset(
              'lib/assets/carwaan.jpeg',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              color: Colors.white.withOpacity(0.8),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
              padding: const EdgeInsets.only(left: 6),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 55, left: 16),
                    child: const Text(
                      "Booking Form",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: const Text(
                      "Fill to confirm your Booking!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04,
                        right: 30,
                        left: 30),
                    child: Column(
                      children: [
                        Text(msg),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Name",
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.name,
                          controller: name_Controller,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Address",
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.streetAddress,
                          controller: address_Controller,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Phone",
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.phone,
                          controller: phone_Controller,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async{
                            myDateTime = (await showDateRangePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            ))!;
                            date_Controller.text=myDateTime != null ? myDateTime.start.toString().split(" ")[0] + "  ---  " +myDateTime.end.toString().split(" ")[0] : "Pick Date";
                          },
                          child: Container(
                            
                            child: TextFormField(
                              controller: date_Controller,
                              enabled: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                hintText: "Pick Date",
                                hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              //keyboardType: TextInputType.number,
                              //controller: phone_Controller,
                            ),

                          ),
                        ),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       padding: const EdgeInsets.only(
                        //           top: 12, bottom: 12, left: 20, right: 20)),
                        //   onPressed: () async{
                        //     myDateTime = (await showDateRangePicker(
                        //         context: context,
                        //          firstDate: DateTime.now(),
                        //          lastDate: DateTime(2100),
                        //     ))!;
                        //   },
                        //   child: const Text(
                        //     "Pick Date",
                        //     style: TextStyle(
                        //         fontSize: 18, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.only(
                                  top: 12, bottom: 12, left: 20, right: 20)),
                          onPressed: () {
                            booking();
                          },
                          child: const Text(
                            "Confirm Booking",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 80),
                    child: const Text(
                      "CARWAAN",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
