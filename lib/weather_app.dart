import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather/city_screen.dart';
import 'location.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String cityName='Mumbai';
  String? weather;
  String? city;
  Map? data;
  double? windSpeed;
  int? date;
  var day;
  var temprature;
  var k;

  Future fetchData(dynamic cityName) async {
    http.Response response = await http.get(Uri.parse(
       // 'https://api.openweathermap.org/data/2.5/find?q=$cityName&appid=b146795d8807d63f4bf60f07c1f9ecaa&units=metric'
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=b146795d8807d63f4bf60f07c1f9ecaa&units=metric'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        // city = data!['list'][0]['name'];
        city = data!['name'];
        windSpeed = data!['wind']['speed'];
        day = DateFormat('  EEEE-d,\nMMMM  y ');
        //hh:mm a
        date = data!['dt'];
        k = day.format(DateTime.fromMillisecondsSinceEpoch(date! * 1000));
        temprature = data!['main']['temp'];
        weather = data!['weather'][0]['main'];
      });
    }
  }

  @override
  void initState() {
    fetchData(cityName);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.search,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () async{
            var nac=await Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return CityScreen();
              },
            ));
            if(nac!=null){
        await fetchData(nac);
            }
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
                onTap: () {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MyLocation();
                },));},
                child: SvgPicture.asset(
                  'assets/menu.svg',
                  height: 30,
                  width: 30,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: data == null
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
              child: Stack(
              children: [
                Image.asset(
                  'assets/night.jpg',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(color: Colors.black38),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 150,
                                      ),
                                      Text(
                                        city!,
                                        style: GoogleFonts.lato(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        k.toString(),
                                        style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '$temprature\u2103',
                                        style: GoogleFonts.lato(
                                            fontSize: 85,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white),
                                      ),
                                      Row(children: [
                                        SvgPicture.asset(
                                          'assets/moon.svg',
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          weather!,
                                          style: GoogleFonts.lato(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ]),
                                    ]),
                              ]),
                        ),
                        Column(children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 40),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30)),
                          ),
                          Row(
                            children: [
                              Text(
                                'WindSpeed:',
                                style: GoogleFonts.lato(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                windSpeed.toString(),
                                style: GoogleFonts.lato(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ]),
                      ]),
                )
              ],
            )),
    );
  }
}
