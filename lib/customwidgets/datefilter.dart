import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilter extends StatefulWidget {

  final Function function;


  DateFilter({this.function});

  @override
  _DateFilterState createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
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
            "DATE FILTER",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 18),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(3000)).then((value){
                      if(value != null){
                        setState(() {
                          _startDateController.text = DateFormat.yMMMd().format(value);

                        });
                      }
                    });
                  },
                  child: TextField(
                    controller: _startDateController,
                    enabled: false,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    decoration:
                        Constants.getInputDecoration("Start Date", false),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: (){
                    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(3000)).then((value){
                      if(value != null){
                        setState(() {
                          _endDateController.text = DateFormat.yMMMd().format(value);

                        });
                      }
                    });
                  },
                  child: TextField(
                    controller: _endDateController,
                    enabled: false,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                    decoration: Constants.getInputDecoration("End Date", false),
                  ),
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
                      widget.function(_startDateController.text,_endDateController.text);
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
