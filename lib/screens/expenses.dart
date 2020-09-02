import 'package:epump/customwidgets/datefilter.dart';
import 'package:epump/screens/addexpenses.dart';
import 'package:epump/screens/dashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/branchstores/expensestore.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  String startDate;
  String endDate;

  @override
  void initState() {
    startDate = DateFormat.yMMMd().format(DateTime.now());
    endDate = DateFormat.yMMMd().format(DateTime.now());
    super.initState();
  }

  filteredData(String start,String end){
    setState(() {
      startDate = start;
      endDate = end;
    });
  }

  @override
  Widget build(BuildContext context) {

    final expenseStore = Provider.of<ExpenseStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Expenses"));
      await expenseStore.getExpenses(startDate, endDate);
      Navigator.of(context).pop();

    });
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Expenses",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: DateFilter(function: filteredData,),
                      );
                    });
              })
        ],
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddExpenses())),backgroundColor:CustomColors.REMIS_PURPLE,child: Icon(Icons.add,size: 20,),),
      body: Observer(
        builder:(_) => ListView.builder(
          itemCount: expenseStore.expenses.length,
          itemBuilder: (context,index){
          return CustomListCard(
            amount:Constants.formatThisInput( expenseStore.expenses[index].amount),
            date:expenseStore.expenses[index].date.toString(),
            accountNumber: expenseStore.expenses[index].account,
            description: expenseStore.expenses[index].description,
            paymentMode: expenseStore.expenses[index].paymentMode,
          );
        },),
      ),
    );
  }
}
class CustomListCard extends StatelessWidget {

  final amount;
  final date;
  final accountNumber;
  final description;
  final paymentMode;


  CustomListCard({this.amount, this.date,this.accountNumber, this.description, this.paymentMode});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: CustomColors.REMIS_LIGHT_GREY),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 6,
            ),
            SvgPicture.asset(
              Constants.getAssetGeneralName("expenses", "svg"),
              width: 40,
              color: CustomColors.REMIS_PURPLE,
            ),
            SizedBox(
              width: 25,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        Constants.getAssetGeneralName("naira", "svg"),
                        color: Colors.black,
                        width: 18,
                      ),
                      SizedBox(width: 4,),
                      Text(
                        amount,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                      ),
                    ],
                  ),
                  SizedBox(height: 8,),

                  Text(
                    date,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ),


                  SizedBox(height: 8,),
                  Text(
                    accountNumber,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                  SizedBox(height: 8,),

                  Text(
                    description,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0,top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    paymentMode,
                    style: TextStyle(
                        color: CustomColors.REMIS_PURPLE,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
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

