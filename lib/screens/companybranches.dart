import 'package:epump/screens/companydashboard.dart';
import 'package:epump/screens/loadingscreen.dart';
import 'package:epump/stores/companystores/companysalesstore.dart';
import 'package:epump/utils/networkcalls/networkrequest.dart';
import 'package:epump/values/colors.dart';
import 'package:epump/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyBranches extends StatefulWidget {
  @override
  _CompanyBranchesState createState() => _CompanyBranchesState();
}

class _CompanyBranchesState extends State<CompanyBranches> {
  @override
  Widget build(BuildContext context) {
    final companyStore = Provider.of<CompanySalesStore>(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Navigator.of(context).push(LoadingWidget.showLoadingScreen("Fetching Branches"));
      await companyStore.getBranches();
      Navigator.of(context).pop();
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Branches"),
      ),
      drawer: CompanyDrawerOnly(),
      body: Observer(
        builder:(_) => ListView.builder(
          itemCount: companyStore.branches.length,
            itemBuilder: (context,index){
          return GestureDetector(
            onTap: () async{
              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString("LOCATION", companyStore.branches[index].name);
              NetworkRequest.BRANCHID = companyStore.branches[index].branchId;
              Navigator.of(context).pushNamed("/dashboard",arguments: {
                "location" : companyStore.branches[index].name,
                "isCompany":true
              });
            },
            child: CustomListCard(
              name: companyStore.branches[index].name,
              pmsVolume: Constants.formatThisInput(companyStore.branches[index].pmsTotalVolume),
              agoVolume: Constants.formatThisInput(companyStore.branches[index].agoTotalVolume),
              dpkVolume: Constants.formatThisInput(companyStore.branches[index].dpkTotalVolume),
              location: "${companyStore.branches[index].city} ${companyStore.branches[index].state}",
            ),
          );
        }),
      )
    );
  }
}

class CustomListCard extends StatelessWidget {
  final name;
  final pmsVolume;
  final location;
  final agoVolume;
  final dpkVolume;

  CustomListCard(
      {this.name, this.pmsVolume, this.location, this.agoVolume,this.dpkVolume});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:5.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: CustomColors.REMIS_LIGHT_GREY),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:17.0,vertical:15.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.business,size: 50,color: CustomColors.REMIS_DARK_PURPLE,),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$name",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        location,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "PMS Volume: $pmsVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "AGO Volume: $agoVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "DPK Volume: $dpkVolume ltr(s)",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

