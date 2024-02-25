import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:skeletons/skeletons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import '../ctrl/getCTRL.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import '../ctrl/api.dart';

//final apiCall = API();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _App();
}

class _App extends State<HomeScreen> {
  bool verificationOn = false;
  bool spin = false;
  final ctrl = Get.put(ControllerApp());
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  String lieu = '';
  String descriptionTemperature = '';
  String degre = '';
  String heure = '';
  String wind = '';
  String humidity = '';

  String dateString = '';
  String hourString = '';

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('longitude :' + position.longitude.toString()); //Output: 80.24599079
    print('latitude :' + position.latitude.toString()); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      //print(position.longitude); //Output: 80.24599079
      //print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      if (!long.isEmpty && !lat.isEmpty){
        print('recalling');
        _refreshWeather(lat, long);
      }

      setState(() {
        //refresh UI on update
      });
    });


  }

  void _refreshWeather(String lat, String lon) async{
    setState((){
      spin = true;
    });


    try {
      http.Response response = await API().getWeather(lat, lon);

      if (response.statusCode == 200) {
        final reponse = jsonDecode(response.body);
        //print(reponse['weather']['description']);
        var weather =reponse['weather'];
        if (weather[0] != null){
          descriptionTemperature = weather[0]['description'];
        }

        lieu = reponse['name'] + ', '+ reponse['sys']['country'];

        humidity = reponse['main']['humidity'].toString();
        wind = reponse['wind']['speed'].toString();
        degre = (reponse['main']['temp']-273.15).round().toString();
        //log(jsonEncode(reponse));

        setState((){
          spin = false;
        });

        DateTime timestamp = DateTime.now();
        String dayS = timestamp.day.toString().length == 1 ? '0' + timestamp.day.toString() : timestamp.day.toString();
        String monthS = timestamp.month.toString().length == 1 ? '0' + timestamp.month.toString() : timestamp.month.toString();
        setState(() {
          dateString = dayS + '/'+ monthS + '/'+ timestamp.year.toString();
        });

        setState(() {
          hourString = timestamp.hour.toString() + ':' + timestamp.minute.toString();
        });
        //Alert(message: reponse['message']).show();
      }else{
        setState((){
          spin = false;
        });

        //Alert(message: 'ERREUR, Impossible de procéder').show();
      }
      //log(jsonEncode(response));

    } catch(e) {
      print(e);
      setState(() {
        spin = false;
      });
      //Alert(message: 'Impossible de procéder').show();
    }
  }


  @override
  void initState() {
    checkGps();
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {

    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(ctrl.blackedColor),
      body: Container(
          height: height,
          width: width,
          child: lieu != '' ? Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 50, top: 80, right: 50, bottom: 20),
                height: height * 70 / 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(30),
                ),
              ).animate().fadeIn(),
              Container(
                margin: EdgeInsets.only(left: 30, top: 60, right: 30, bottom: 20),
                height: height * 70 / 100,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(58,97,157, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
              ).animate().fadeIn(),
              Container(
                margin: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
                height: height * 70 / 100,
                width: width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: RefreshIndicator(
                  onRefresh: (){
                    if (!long.isEmpty && !lat.isEmpty){
                      _refreshWeather(lat, long);
                    }
                    return Future.delayed(
                        Duration(seconds: 2),
                            () {
                          //theRefresh();
                        }
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(dateString, style: TextStyle(color: Colors.white60, fontSize: 20, fontWeight: FontWeight.w900)),
                      Text(lieu, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      SizedBox(height: 50),
                      Text(descriptionTemperature, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w100)),
                      GestureDetector(
                        onDoubleTap: (){
                          if (!long.isEmpty && !lat.isEmpty){
                            _refreshWeather(lat, long);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(degre +'°', style: TextStyle(color: Colors.white70, fontSize: 70, fontWeight: FontWeight.w900)),
                            Text('C', style: TextStyle(color: Colors.white70, fontSize: 50, fontWeight: FontWeight.w900)),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(hourString, style: TextStyle(color: Colors.white60, fontSize: 20, fontWeight: FontWeight.w100)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ).animate().fadeIn(),
              if (spin)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    margin: EdgeInsets.all(20),
                    width: width,
                    child: Center(
                      child: Text('Refreshing ...'),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                width: width,
                child: Container(
                  margin: EdgeInsets.only(left: 20, top: 40, right: 20, bottom: 20),
                  height: height * 17 / 100,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Vent', style: TextStyle(color: Colors.white60)),
                                SizedBox(height: 5),
                                Icon(Icons.wind_power, color: Theme.of(context).colorScheme.secondary),
                                SizedBox(height: 5),
                                Text(wind+'m/s', style: TextStyle(color: Colors.white60)),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Humidité', style: TextStyle(color: Colors.white60)),
                                SizedBox(height: 5),
                                Icon(Icons.water_drop_outlined, color: Theme.of(context).colorScheme.secondary),
                                SizedBox(height: 5),
                                Text(humidity+'%', style: TextStyle(color: Colors.white60)),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('Temperature', style: TextStyle(color: Colors.white60)),
                                SizedBox(height: 5),
                                Icon(Icons.device_thermostat, color: Theme.of(context).colorScheme.secondary),
                                SizedBox(height: 5),
                                Text(degre+'°C', style: TextStyle(color: Colors.white60)),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ).animate().fadeIn(),
              ),
            ],
          ) : Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                      height: height * 70 / 100,
                      borderRadius: BorderRadius.circular(30)
                  ),
                ).animate().fadeIn(),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
                child: SkeletonLine(
                  style: SkeletonLineStyle(
                      height: height * 17 / 100,
                      borderRadius: BorderRadius.circular(30)
                  ),
                ).animate().fadeIn(),
              )
            ],
          )
      ),
    );
  }
}