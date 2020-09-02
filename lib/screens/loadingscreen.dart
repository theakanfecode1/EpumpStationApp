import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoadingWidget extends StatelessWidget {

  final message;
  LoadingWidget(this.message);

  static PageRouteBuilder showLoadingScreen(String message) {
    return PageRouteBuilder(
      opaque: false,
        pageBuilder: (BuildContext context, animation, secondaryAnimation) =>
            LoadingWidget(message),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween),child: child,);
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.84),
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation(CustomColors.REMIS_PURPLE),
                  backgroundColor: CustomColors.REMIS_LIGHT_PURPLE,
                ),
              ),
              SvgPicture.asset(
                Constants.getAssetGeneralName("gas_station", "svg",),
                color: CustomColors.REMIS_PURPLE,
                width: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top:150.0),
                child: Text(message+"...",style: TextStyle(
                  color: CustomColors.REMIS_PURPLE,
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),),
              )

            ],
          ),
        ),
      ),
    );
  }
}
