import 'package:epump/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constants{
  static String getAssetGeneralName(String nameOfAsset,String fileExt){
    return "assets/$nameOfAsset.$fileExt";
  }

  static String formatThisInput(dynamic digits){
    final digitsFormat = NumberFormat("#,###","en_US");
    var withDecimalPoint = digits.toStringAsFixed(2);
    var splitted = withDecimalPoint.split(".");
    var formattedInt = digitsFormat.format(int.parse(splitted[0]));

    return formattedInt+"."+splitted[1];
  }

  static InputDecoration getInputDecoration(String label, bool enabled){
    return InputDecoration(
      labelText: label,
      enabled: enabled,
      labelStyle: TextStyle(
        fontSize: 18,
        color: CustomColors.REMIS_PURPLE,
        fontWeight: FontWeight.w400,),
      isDense: true,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: CustomColors.REMIS_PURPLE,
          )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: CustomColors.REMIS_PURPLE,
          )),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: CustomColors.REMIS_PURPLE,)
        ),
    );
  }
  static AppBar showCustomAppBar(String title){
    return AppBar(
      elevation: 1.5,
      title: Text(title,style: TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w600
      ),),
    );
  }
}