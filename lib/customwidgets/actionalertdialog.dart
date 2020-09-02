import 'package:epump/values/colors.dart';
import 'package:flutter/material.dart';

class ActionAlertDialog extends StatefulWidget {

  final String title;
  final String message;
  final Function function;

  ActionAlertDialog({this.title,this.function,this.message});

  @override
  _ActionAlertDialogState createState() => _ActionAlertDialogState();
}

class _ActionAlertDialogState extends State<ActionAlertDialog> {



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 0,
          ),
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
          ),


          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
          ),



          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      height: 70,
                      child: Text(
                        "NO",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: CustomColors.REMIS_PURPLE),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      widget.function();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(7)),
                        color: CustomColors.REMIS_PURPLE,
                      ),
                      child: Text(
                        "YES",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
