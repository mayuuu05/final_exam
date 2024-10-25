
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/auth_service.dart';


class AuthController extends GetxController {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();

  Future<void> signUp(String email, String password) async {

    await AuthServices.authServices.createAccount(email, password);
  }
  Future<void> signIn(String email, String password) async {

    await AuthServices.authServices.signIn(email, password);
  }



  Future<void> logOut()
  async {
    await AuthServices.authServices.logOut();
  }
}