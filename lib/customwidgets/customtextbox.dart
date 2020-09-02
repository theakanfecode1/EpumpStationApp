import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextBox extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String assetName;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool obsecureText;
  final Function onSubmitted;


  CustomTextBox({this.controller, this.hint, this.assetName,
      this.textInputAction, this.textInputType,this.obsecureText,this.onSubmitted});

  @override
  _CustomTextBoxState createState() => _CustomTextBoxState();
}

class _CustomTextBoxState extends State<CustomTextBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:10.0,right: 10.0),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18
        ),
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.w400,),
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(13.0),
            child: SvgPicture.asset(widget.assetName,color: Colors.white,width: 20,),
          ),
          contentPadding: EdgeInsets.all(24),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.white,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(
                color: Colors.white,
              )),
//        enabledBorder: OutlineInputBorder(
//            borderRadius: BorderRadius.all(Radius.circular(10.0)),
//            borderSide: BorderSide(color: Colors.white,)
//        ),
        ),
        keyboardType: widget.textInputType,
        obscureText: widget.obsecureText,
        onSubmitted: (text){
          widget.onSubmitted(text);
        },
      ),
    );
  }
}
