// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'dart:convert';
import 'package:carwaan_customerapp/main.dart';
import 'package:carwaan_customerapp/mybookings.dart';
import 'package:carwaan_customerapp/searchAllCar.dart';
import 'package:carwaan_customerapp/searchShowoom.dart';
import 'package:carwaan_customerapp/showroomdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final storage = const FlutterSecureStorage();
  var showrooms = [];
  var name = "Loading...";
  var loading = false;
  String url = 'https://carwaan.herokuapp.com/car/';


  getShowrooms() async {
    var response = await http.get(Uri.parse(url + 'getallshowrooms'));

    Map resMap = json.decode(response.body);

    if(resMap.containsKey("success")){
      setState(() {
        showrooms = resMap["success"];
      });

    }

  }

  Widget getTiles(showroom,index){
    return  Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () async{
          await storage.write(key: "selectedShowroom", value: showroom["email"]);
          await storage.write(key: "selectedShowroomName", value: showroom["name"]);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ShowroomDetails()),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
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
                        image: NetworkImage(showroom["img"])
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(showroom["name"] + " Showroom",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child:  Text(
                            "Ratings: " + showroom["ratings"].toString() + "/5",
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
  @override
  initState(){
    super.initState();
    getShowrooms();
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
          leading:  
          Builder(
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
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.topCenter,
              child: const Text(
                "Browse Showrooms",
                style: TextStyle(fontSize: 22),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: ListView.builder(
                  itemCount: showrooms.length,
                  itemBuilder: (context, index) {
                    return getTiles(showrooms[index], index);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
Widget menuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.grey.shade500;
  const color2 = Colors.black;
  return ListTile(
    leading: Icon(icon, color: color, ),
    title: Text(text, style: const TextStyle(color: color2, fontSize: 16),),
    onTap: onClicked,
  );
}
void selectedItem(BuildContext context, int index){
  switch (index){
    case 0:
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomePage()
        ),
      );
      break;

      case 1:
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyBookings()
        ),
      );
      break;

    case 2:
      openWhatsApp();
      break;
  }
}

void openWhatsApp() async{
  var url = "https://wa.me/+923212467099?text=Your msg here";
 // var encoded = Uri.encodeFull(url);
    await launch(url);

}

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({Key? key}) : super(key: key);
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'lib/assets/carwaan-logo.png',
                    fit: BoxFit.cover,
                    height: 75,
                    width: 75,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text("Menu", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          menuItem(
              text: "Home Page",
              icon: Icons.home,
              onClicked: ()=> selectedItem(context, 0)
          ),
          menuItem(
              text: "My Bookings",
              icon: Icons.margin,
              onClicked: ()=> selectedItem(context, 1)
          ),
          menuItem(
              text: "Help Center",
              icon: Icons.help_center,
              onClicked: ()=> selectedItem(context, 2)
          ),

          Container(
            padding: const EdgeInsets.all(95),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 20,
                    right: 20),
              ),
              onPressed: () async {
                await storage.delete(key: "token");
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                        (route) => false);
              },
              child: const Text(
                "Logout",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
