import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pedometer/pedometer.dart';
import 'package:decimal/decimal.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String muestrePasos = "";
  String _km = "Unknown";
  String _calories = "Unknown";

  String _stepCountValue = 'Unknown';
  StreamSubscription<int> _subscription;

  double _numerox; //numero pasos
  double _convert;
  double _kmx;
  double burnedx;
  double _porciento;
  // double percent=0.1;

  @override
  void initState() {
    super.initState();
    //initPlatformState();
    setUpPedometer();
  }

  //inicia codigo pedometer
  void setUpPedometer() {
    Pedometer pedometer = new Pedometer();
    _subscription = pedometer.stepCountStream.listen(_onData,
        onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  void _onData(int stepCountValue) async {
    // print(stepCountValue); //impresion numero pasos por consola
    setState(() {
      _stepCountValue = "$stepCountValue";
      // print(_stepCountValue);
    });

    var dist = stepCountValue; //pasamos el entero a una variable llamada dist
    double y = (dist + .0); //lo convertimos a double una forma de varias

    setState(() {
      _numerox =
          y; //lo pasamos a un estado para ser capturado ya convertido a double
    });

    var long3 = (_numerox);
    long3 = num.parse(y.toStringAsFixed(2));
    var long4 = (long3/10000);

    int decimals = 1;
    int fac = pow(10, decimals);
    double d = long4;
    d = (d * fac).round() / fac;
    print("d: $d");

    getDistanceRun(_numerox);

    setState(() {
      _convert = d;
      print(_convert);
    });
  }

  void reset() {
    setState(() {
      int stepCountValue = 0;
      stepCountValue = 0;
      _stepCountValue = "$stepCountValue";
    });
  }

  void _onDone() {}

  void _onError(error) {
    print("Flutter Pedometer Error: $error");
  }

  //function to determine the distance run in kilometers using number of steps
  void getDistanceRun(double _numerox) {
    var distance = ((_numerox * 78) / 100000);
    distance = num.parse(distance.toStringAsFixed(2)); //dos decimales
    var distancekmx = distance * 34;
    distancekmx = num.parse(distancekmx.toStringAsFixed(2));
    //print(distance.runtimeType);
    setState(() {
      _km = "$distance";
      //print(_km);
    });
    setState(() {
      _kmx = num.parse(distancekmx.toStringAsFixed(2));
    });
  }

  //function to determine the calories burned in kilometers using number of steps
  void getBurnedRun() {
    setState(() {
      var calories = _kmx; //dos decimales
      _calories = "$calories";
      //print(_calories);
    });
  }

  //fin codigo pedometer

  @override
  Widget build(BuildContext context) {
    //print(_stepCountValue);
    getBurnedRun();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Step Counter app'),
          backgroundColor: Colors.black54,
        ),
        body: new Container(          
          color: Colors.white24,
          child: ListView(
            padding: EdgeInsets.all(5.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10.0),
                width: 150, //ancho
                height: 150, //largo tambien por numero height: 300
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment
                          .bottomCenter, //cambia la iluminacion del degradado
                      end: Alignment.topCenter,
                      colors: [Color(0xFFA9F5F2), Color(0xFF01DFD7)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(27.0),
                      bottomRight: Radius.circular(27.0),
                      topLeft: Radius.circular(27.0),
                      topRight: Radius.circular(27.0),
                    )),
                child: new CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 13.0,
                  animation: true,
                  center: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Icon(
                          FontAwesomeIcons.walking,
                          size: 30.0,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        //color: Colors.orange,
                        child: Text(
                          '$_stepCountValue',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.purpleAccent),
                        ),
                        // height: 50.0,
                        // width: 50.0,
                      ),
                    ],
                  ),
                  percent: 0.217,
                  //percent: _convert,
                  footer: new Text(
                    "Pasos:  $_stepCountValue",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.purple),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.purpleAccent,
                ),
              ),
              Divider(
                height: 10,
              ),
              Container(
                width: 80,
                height: 100,
                padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/distance.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Text(
                            "$_km Km",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14.0),
                          ),
                        ),
                        color: Colors.white54,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/burned.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/step.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
              ),
              //info data km, kcal, steps
              Container(
                padding: EdgeInsets.only(top: 2.0),
                width: 150, //ancho
                height: 30, //largo tambien por numero height: 300
                color: Colors.transparent,
                child: Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 40.0),
                      child: new Card(
                        child: Container(
                          child: Text(
                            "$_km Km",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.white),
                          ),
                        ),
                        color: Colors.purple,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Card(
                        child: Container(
                          child: Text(
                            "$_calories kCal",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.white),
                          ),
                        ),
                        color: Colors.red,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      padding: EdgeInsets.only(left: 10.0),
                      child: new Card(
                        child: Container(
                          child: Text(
                            "$_stepCountValue Steps",
                            textAlign: TextAlign.right,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: Colors.white),
                          ),
                        ),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
                color: Colors.black12,
                child: Row(
                  children: <Widget>[
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/barras.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        color: Colors.white54,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/water.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    VerticalDivider(
                      width: 20.0,
                    ),
                    new Container(
                      child: new Card(
                        child: Container(
                          height: 80.0,
                          width: 80.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/heart.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(top: 2.0),
                width: 200, //ancho
                height: 100, //l
                      decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/codigoalpha.png"),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.topCenter,
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
