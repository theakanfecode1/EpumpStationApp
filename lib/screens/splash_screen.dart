import 'dart:async';
import 'package:flutter/material.dart';
import 'package:epump/values/gradientcontainer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:epump/values/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  switchScreens() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, navigateToNext);
  }

  void navigateToNext() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool loggedIn =sharedPreferences.getBool("LOGGED_IN")??false;
    if(loggedIn){
      String loggedInAs = sharedPreferences.getString("LOGGED_IN_AS")??"";
      if(loggedInAs.toUpperCase() == "COMPANYADMIN"){

      }else{

      }
    }
    Navigator.of(context).pushReplacementNamed("/onboarding");
  }

  @override
  void initState() {
    switchScreens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return (
        Scaffold(
          body:
          GradientContainer(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        Constants.getAssetGeneralName("molecule", "svg"),
                        color: Colors.black26, width: 80,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oiloil", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oil_price", "svg"),
                            color: Colors.black26,),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("barrel", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(Constants.getAssetGeneralName(
                              "fuel_station", "svg"), color: Colors.black26,),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oil", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(Constants.getAssetGeneralName(
                              "gas_station", "svg"), color: Colors.black26,),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 230,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: SizedBox(width: 300,
                            height: 2,
                            child: HorizontalProgressIndicator()),
                      ),
                      Image.asset(Constants.getAssetGeneralName(
                          "epumplogo", "png",
                      ),
                        width: 300,
                        height: 100,),

                    ],
                  ),
                ),
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        Constants.getAssetGeneralName("molecule", "svg"),
                        color: Colors.black26, width: 80,),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oiloil", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oil_price", "svg"),
                            color: Colors.black26,),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("barrel", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(Constants.getAssetGeneralName(
                              "fuel_station", "svg"), color: Colors.black26,),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(
                            Constants.getAssetGeneralName("oil", "svg"),
                            color: Colors.black26,),
                          SvgPicture.asset(Constants.getAssetGeneralName(
                              "gas_station", "svg"), color: Colors.black26,),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class HorizontalProgressIndicator extends StatefulWidget {
  @override
  HorizontalProgressIndicatorState createState() =>
      new HorizontalProgressIndicatorState();
}

class HorizontalProgressIndicatorState
    extends State<HorizontalProgressIndicator>
    with SingleTickerProviderStateMixin {

  AnimationController controller;

  Animation<double> animation;

  double beginAnim = 0.0;

  double endAnim = 1.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(seconds: 5), vsync: this);
    animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
      ..addListener(() {
        setState(() {

        });
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: SizedBox(
        height: 3.0,
        child: LinearProgressIndicator(
//        value: animation.value,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          backgroundColor: Colors.grey[400],

        ),
      ),
    );
  }
}
