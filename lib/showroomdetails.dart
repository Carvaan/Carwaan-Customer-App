// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'dart:convert';
import 'package:carwaan_customerapp/carbooking.dart';
import 'package:carwaan_customerapp/home.dart';
import 'package:carwaan_customerapp/searchCar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class ShowroomDetails extends StatefulWidget {
  const ShowroomDetails({Key? key}) : super(key: key);

  @override
  _ShowroomDetailsState createState() => _ShowroomDetailsState();
}

class _ShowroomDetailsState extends State<ShowroomDetails> {
  final storage = const FlutterSecureStorage();
  var cars = [];
  var name = "Loading...";
  String url = 'https://carwaan.herokuapp.com/car/';


  Widget getCar(index){
    var car = cars[index];
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () async{
          await storage.write(key: "selectedCar", value: json.encode(car));
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CarBooking()),
          );
        },
        child: Card(
          shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.black)
          ),
          child: Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(15),
                    right: Radius.circular(0),
                  ),
                  child: Image(
                      height: 125,
                      width: 125,
                      fit: BoxFit.cover,
                      image: NetworkImage(car["img"])
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(car["name"],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child:  Text(
                          car["specs"] + "\n" + car["rent"].toString() + "/day",
                          style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  getShowroomCars() async {

    var showroomEmail = await storage.read(key: "selectedShowroom");
    var showroomName = await storage.read(key: "selectedShowroomName");
    setState(() {
      name = showroomName!;
    });
    var response = await http.post(Uri.parse(url + 'getshowroomcars'), body:{"showRoomEmail":showroomEmail});

    Map resMap = json.decode(response.body);

    if(resMap.containsKey("success")){
      setState(() {
        cars = resMap["success"];
      });

    }

  }

  @override
  initState(){
    super.initState();
    getShowroomCars();
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
          actions: [
            // Navigate to the Search Screen
            IconButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SearchCar())),
                icon: Icon(Icons.search,color: Colors.black,))
          ],
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
            Container(
              padding: const EdgeInsets.only(top: 50, left: 16),
              child:  Text(
                name + " Showroom",
                style: const TextStyle(fontSize: 22),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 110),
              child: ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    return getCar(index);
                  }
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
