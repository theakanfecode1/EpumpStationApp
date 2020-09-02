import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';

class SingleTextFieldDialog extends StatefulWidget {

  final String title;
  final String hint;
  final Function function;
  final bool notShowText;
  final TextInputType inputType;

  SingleTextFieldDialog({this.title,this.function,this.hint, this.notShowText, this.inputType});

  @override
  _SingleTextFieldDialogState createState() => _SingleTextFieldDialogState();
}

class _SingleTextFieldDialogState extends State<SingleTextFieldDialog> {

  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }


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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                TextField(
                  controller: _textEditingController,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                  decoration:
                  Constants.getInputDecoration(widget.hint, true),
                  keyboardType: widget.inputType,
                  obscureText: widget.notShowText,
                ),),


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
                        "CANCEL",
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
                      widget.function(_textEditingController.text);
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
                        "OK",
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
