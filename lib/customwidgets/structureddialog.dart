import 'package:flutter/material.dart';

class StructuredDialog extends StatelessWidget {
  final Widget child;
  final bool giveRadius;

  StructuredDialog({this.child,this.giveRadius});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: giveRadius ? BorderRadius.all(Radius.circular(10)):BorderRadius.all(Radius.circular(0)),
      ),
      child: child,
    );
  }
}
