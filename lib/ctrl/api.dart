import 'dart:convert';
import 'package:http/http.dart' as http;
class API{
  String mainApi = 'https://api.playmb.org/';
  //String mail = '';

  //OTP({required this.otp, required this.mail});

  Future<http.Response> getWeather(String lat, String lon) {
    return http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat='+lat+'&lon='+lon+'&appid='+openweathermapApiKey),
    ).timeout(Duration(seconds: 60));
  }
}

class OTP{
  String otp = '';
  String mail = '';

  OTP({required this.otp, required this.mail});
}
