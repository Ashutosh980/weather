import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loca;
class MyLocation extends StatelessWidget {
  const MyLocation({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Your Current Location'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  double ?longitude;
  double ?latitude;
  var placemarks;
  var value;
  Future <void>_getCurrentUserLocation() async{
    final locdata=await loca.Location().getLocation();
    placemarks=await placemarkFromCoordinates(locdata.latitude!, locdata.longitude!);
    Placemark place=placemarks[0];
    setState(() {
      longitude=locdata.longitude!;
      latitude=locdata.latitude!;
      value='Address:${place.locality},${place.country}';
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: _getCurrentUserLocation, child: Text("current Location:")),
            latitude==null?Container():Text('$latitude'),
            longitude==null?Container():Text("$longitude"),
            value==null?Container():Text('$value'),
          ],
        ),
      ),
    );
  }
}
