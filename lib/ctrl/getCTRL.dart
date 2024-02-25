import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ControllerApp extends GetxController {
  var primaryColor = 0xFF40679E;
  var secondaryColor = 0xFF387ADF;
  var blackedColor = 0xFF1B3C73;
  RxString userSession  = ''.obs;
  var domaine = 'https://api.playmb.org/';

  void setUserSession(String session){
    userSession.value = session;
  }
}

