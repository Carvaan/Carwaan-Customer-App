// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'package:carwaan_customerapp/bookingform.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'home.dart';

class CarBooking extends StatefulWidget {
  const CarBooking({Key? key}) : super(key: key);

  @override
  _CarBookingState createState() => _CarBookingState();
}

class _CarBookingState extends State<CarBooking> {
  final storage = const FlutterSecureStorage();
  var car;
  var showroomNo="";

  void openWhatsApp() async{
    var url = "https://wa.me/"+showroomNo+"?text=I have an inquiry about your car";
    // var encoded = Uri.encodeFull(url);
    await launch(url);

  }
  getCar() async {
    var data = await storage.read(key: "selectedCar");

    String url = 'https://carwaan.herokuapp.com/car/';

    var car1 = json.decode(data!);

    var res = await http.post(Uri.parse(url + 'getshowroomno'), body:{"showRoomEmail":car1["addedBy"]});

    setState(() {
      car = car1;
      showroomNo = res.body.toString();
    });


  }

  @override
  initState(){
    super.initState();
    getCar();
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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 55, left: 16),
                    child: Text(
                      car!= null ? car["name"] : "loading...",
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.only(top: 10),
                    child: Image.network(
                      car!= null ? car["img"] : 'https://jmperezperez.com/amp-dist/sample/sample-placeholder.png',
                      fit: BoxFit.cover,
                      height: 420,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 15),
                    child: const Text(
                      "Specifications",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 6, left: 6, right: 6, bottom: 10),
                    child: Card(
                      shape: const BeveledRectangleBorder(
                          side: BorderSide(color: Colors.black)),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            child:  Text(car!= null ? car["specs"] : "loading...",
                                style: const TextStyle(fontSize: 18)),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child:  Text(car!= null ? "PKR " + car["rent"].toString() + "/day" : "loading...",
                                style: const TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 20, right: 20)),
                        onPressed: () async {
                          await storage.write(key: "carId", value: car["_id"]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BookingForm()),
                          );
                        },
                        child: const Text(
                          "Book Now",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.only(
                                top: 12, bottom: 12, left: 20, right: 20)),
                        onPressed: () {
                          openWhatsApp();
                        },
                        child: const Text(
                          "Contact Seller",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded),
              padding: const EdgeInsets.only(left: 6),
            ),
          ],
        ),
      ),
    );
  }
}
