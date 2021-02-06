import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedbackWidget extends StatelessWidget {

  final title;
  final status;
  final message;


  FeedbackWidget({this.title, this.status, this.message});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 0,),
          Text(title.toString().toUpperCase(),style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),),
          if(!status)
            SvgPicture.asset(Constants.getAssetGeneralName("error", "svg"),color: Colors.red,width: 100,),
          if(status)
            SvgPicture.asset(Constants.getAssetGeneralName("checked", "svg"),color: Colors.green,width: 100,),

          Text(message.toString(),textAlign:TextAlign.center,style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),),

          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              alignment: Alignment.center,
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.only(bottomRight: Radius.circular(7),bottomLeft:Radius.circular(7) ),
                color: CustomColors.REMIS_PURPLE,
              ),
              child: Text(
                "OK",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
          ),



        ],
      ),
    );
  }
}
