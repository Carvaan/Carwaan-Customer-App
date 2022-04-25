import 'dart:convert';
import 'package:carwaan_customerapp/main.dart';
import 'package:carwaan_customerapp/mybookings.dart';
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

class SearchShowroom extends StatefulWidget {
  const SearchShowroom({Key? key}) : super(key: key);

  @override
  State<SearchShowroom> createState() => _SearchShowroomState();
}

class _SearchShowroomState extends State<SearchShowroom> {

  final search_controller = TextEditingController();

  final storage = const FlutterSecureStorage();
  var showrooms = [];
  var searchShowrooms = [];

  var name = "Loading...";
  var loading = false;
  String url = 'https://carwaan.herokuapp.com/car/';

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
                      fit: BoxFit.fill,
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

  getShowrooms() async {
    var response = await http.get(Uri.parse(url + 'getallshowrooms'));

    Map resMap = json.decode(response.body);

    if(resMap.containsKey("success")){
      setState(() {
        showrooms = resMap["success"];
      });

    }

  }

  searchShowroom(text) async {
      searchShowrooms = [];

      if(text==""){
        setState(() {
          searchShowrooms = searchShowrooms;
        });
        return;
      }

      showrooms.forEach((element) {
        if(element["name"].toString().trim().toLowerCase().contains(text.toString().trim().toLowerCase())){
          searchShowrooms.add(element);
        }
      });

      setState(() {
        searchShowrooms = searchShowrooms;
      });
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
        body:  Container(
          child: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.only(top:50,left: 10,right: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "Search",
                      hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    keyboardType: TextInputType.name,
                    controller: search_controller,
                    onChanged: (Text){
                      searchShowroom(Text);
                    },
                  )
              ),
              Padding(
                padding: searchShowrooms.length==0 ? const EdgeInsets.only(top: 8) : const EdgeInsets.all(0),
                child: Text(searchShowrooms.length==0 ? "Search Showroom..." : "",style: TextStyle(fontSize: 15),),
              ),
              Container(
                height: MediaQuery.of(context).size.height -125,
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 10),

                    itemCount: searchShowrooms.length,
                    itemBuilder: (context, index) {
                      return getTiles(searchShowrooms[index], index);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
