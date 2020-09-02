import 'package:epump/values/colors.dart';
import 'package:flutter/material.dart';

class GradientContainer extends StatefulWidget {
  final Widget body;

  GradientContainer({this.body});

  @override
  _GradientContainerState createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3,1.0],
            colors: [
              CustomColors.REMIS_PURPLE,CustomColors.REMIS_DARK_PURPLE
            ]),
      ),
      child: widget.body,
    );
  }
}
