import 'dart:async';

import 'package:final_exam_flutter/view/screens/sign%20in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 5),
          () => Get.to(SignIn()),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://i.pinimg.com/474x/59/a2/7f/59a27ff804863f64634360cd3c769e40.jpg'))),
            )
          ],
        ),
      ),
    );
  }
}