// ignore_for_file: camel_case_types,
//prefer_const_constructors,
//avoid_unnecessary_containers

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:carwaan_customerapp/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final email_Controller = TextEditingController();
  final name_Controller = TextEditingController();
  final phone_Controller = TextEditingController();
  final password_Controller = TextEditingController();
  String msg = '';
  String url = 'https://carwaan.herokuapp.com/auth';

  signUp() async {
    setState(() {
      msg = 'Signing up...';
    });

    String email = email_Controller.value.text;
    String name = name_Controller.value.text;
    String phone = phone_Controller.value.text;
    String password = password_Controller.value.text;

    if (email == '' || password == '' || name == '' || phone == '') {
      setState(() {
        msg = '*Enter All Information';
      });
      return;
    }

    var response = await http.post(Uri.parse(url + '/register'), body: {
      'email': email,
      'password': password,
      'phone': phone,
      'name': name
    });

    Map resMap = json.decode(response.body);

    if (resMap.keys.contains('success')) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: const Text("Account created!"),
              content: const Text(
                "Confirm your account through Email to Login",
                style: TextStyle(fontSize: 18),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
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
      setState(() {
        msg = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      "Create Account",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: const Text(
                      "Sign Up to get Started!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.06,
                        right: 30,
                        left: 30),
                    child: Column(
                      children: [
                        Text(msg, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
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
                          height: 15,
                        ),
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
                          maxLength: 11,
                          showCursor: true,
                          decoration: InputDecoration(
                              counterText: "",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Phone",
                              hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          keyboardType: TextInputType.phone,
                          controller: phone_Controller,
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
                                  top: 12, bottom: 12, left: 20, right: 20)),
                          onPressed: () {
                            signUp();
                          },
                          child: const Text(
                            "Sign Up",
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
                                "Already have an account?",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Login",
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
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 30),
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
