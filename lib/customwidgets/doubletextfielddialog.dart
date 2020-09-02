import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';

class DoubleTextFieldDialog extends StatefulWidget {

  final Function function;
  final title;
  final labelOne;
  final labelTwo;
  final TextInputType inputTypeOne;
  final TextInputType inputTypeTwo;
  DoubleTextFieldDialog({this.function,this.title,this.labelOne,this.labelTwo,this.inputTypeOne,this.inputTypeTwo});

  @override
  _DoubleTextFieldDialogState createState() => _DoubleTextFieldDialogState();
}

class _DoubleTextFieldDialogState extends State<DoubleTextFieldDialog> {

  TextEditingController _firstController = TextEditingController();
  TextEditingController _secondController = TextEditingController();

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Container(
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
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _firstController,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    decoration:
                    Constants.getInputDecoration(widget.labelOne, true),
                    textInputAction: TextInputAction.next,
                    onSubmitted: (text)=>FocusScope.of(context).nextFocus(),
                    keyboardType: widget.inputTypeOne,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _secondController,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    decoration: Constants.getInputDecoration(widget.labelTwo, true),
                    onSubmitted: (text)=>FocusScope.of(context).unfocus(),
                    keyboardType: widget.inputTypeTwo,

                  ),
                ],
              ),
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
                        widget.function(_firstController.text,_secondController.text);
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
      ),
    );
  }
}
