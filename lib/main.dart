// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'dart:convert';
import 'package:carwaan_customerapp/signup.dart';
import 'package:carwaan_customerapp/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Carwaan_CustomerApp(),
    );
  }
}

class Carwaan_CustomerApp extends StatefulWidget {
  const Carwaan_CustomerApp({Key? key}) : super(key: key);

  @override
  _Carwaan_CustomerAppState createState() => _Carwaan_CustomerAppState();
}

class _Carwaan_CustomerAppState extends State<Carwaan_CustomerApp> {
  final email_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  String msg = '';
  String url = 'https://carwaan.herokuapp.com/auth';
  final storage = const FlutterSecureStorage();

  checkLogin() async {
    var value = await storage.read(key: 'token');
    if (value != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }
  }

  login() async {
    setState(() {
      msg = 'Signing in...';
    });

    String email = email_Controller.value.text;
    String password = password_Controller.value.text;

    if (email == '' || password == '') {
      setState(() {
        msg = '*Enter Both Email and Password';
      });
      return;
    }

    var response = await http.post(Uri.parse(url + '/login'),
        body: {'email': email, 'password': password});

    Map resMap = json.decode(response.body);

    if (resMap.keys.contains('token')) {
      String token = resMap["token"];

      await storage.write(key: 'token', value: token);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else if (resMap.keys.contains('error')) {
      String err = resMap["error"];
      setState(() {
        msg = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkLogin(),
        builder: (context, snap) {
          return Scaffold(
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
                        padding: const EdgeInsets.only(top: 150, left: 16),
                        child: const Text(
                          "Login to your Account",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        child: const Text(
                          "and start renting!",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.14,
                            right: 30,
                            left: 30),
                        child: Column(
                          children: [
                            Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                            TextFormField(
                              showCursor: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Email",
                                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              controller: email_Controller,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: true,
                              showCursor: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "Password",
                                  hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              controller: password_Controller,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                      top: 12,
                                      bottom: 12,
                                      left: 20,
                                      right: 20),
                              ),
                              onPressed: () {
                                login();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const SignUp()),
                                      );
                                    },
                                    child: const Text(
                                      "Signup",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 115),
                        alignment: Alignment.bottomCenter,
                        child: const Text(
                          "CARWAAN",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        );
  }
}
