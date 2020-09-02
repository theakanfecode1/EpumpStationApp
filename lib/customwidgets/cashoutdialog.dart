import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CashOutDialog extends StatefulWidget {
  final amount;
  final accountNumber;
  final bankName;
  final accountName;
  final Function callbackFunction;


  CashOutDialog({this.amount, this.accountNumber, this.bankName,this.accountName,
    this.callbackFunction});

  @override
  _CashOutDialogState createState() => _CashOutDialogState();
}

class _CashOutDialogState extends State<CashOutDialog> {

  TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,

      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(height: 0,),
          Text("CASH OUT FROM",
          style: TextStyle(
            fontSize: 15
          ),),
          SvgPicture.asset(
            Constants.getAssetGeneralName("money", "svg"),
            color: Colors.black,
            width: 50,
          ),
          Column(
            children: <Widget>[
              Text("Current Balance"),
              Text(widget.amount, style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Text("Pay To:", style: TextStyle(
              ),
              ),
              Text("${widget.accountName} - ${widget.accountNumber}", style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              ),
              Text(widget.bankName, style: TextStyle(

              ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0,right: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: TextField(
                controller: _amountController,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: "Amount to cash out",
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
                ),
                keyboardType: TextInputType.number,
                onSubmitted: (text) {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
          Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomRight:Radius.circular(8),bottomLeft:Radius.circular(10),
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
                        borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10)),
                        color: Colors.white,

                      ),
                      height: 70,
                      child: Text("CANCEL",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: CustomColors.REMIS_PURPLE
                      ),),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      widget.callbackFunction(_amountController.text.isEmpty?"0.00":_amountController.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight:Radius.circular(7)),
                        color: CustomColors.REMIS_PURPLE,

                      ),
                      child: Text("CASH OUT",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.white
                      ),),
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
