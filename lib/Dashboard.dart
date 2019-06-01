import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'EmployeeDetails.dart';
import 'VendorDetails.dart';
import 'VisitorDetails.dart';


class Dashboard extends StatefulWidget{
  Dashboard({Key key, this.title,this.firestore}) : super(key: key);
  final Firestore firestore;
  final String title;
  @override
  DashboardState createState()=>DashboardState(firestore);

}

class DashboardState extends State<Dashboard>{
    final Firestore firestore;

  DashboardState(this.firestore);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(

        builder: (context) =>Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                ButtonTheme(
                    minWidth: 200,
                    height: 64,
                    textTheme: ButtonTextTheme.normal,
                    child:RaisedButton(
                        child:Text('Employee',style: TextStyle(color: Colors.white,fontSize: 20),),
                        onPressed: ()=>handleNavigation(context,'Employee'),
                    )
                )
              ,
//              ButtonTheme(
//                minWidth: 200,
//                  height: 64,
//                  textTheme: ButtonTextTheme.normal,
//                  child:RaisedButton(
//                      child:Text('Vendor',style: TextStyle(color: Colors.white,fontSize: 20),),
//                      onPressed: ()=>handleNavigation(context,'Vendor'),
//                  )
//              ),
            ButtonTheme(
              minWidth: 200,
              height: 64,
              textTheme: ButtonTextTheme.normal,
              child:RaisedButton(
                  child:Text('Visitor',style: TextStyle(color: Colors.white,fontSize: 20),),
                  onPressed: ()=>handleNavigation(context,'Visitor'),
              )
            )
            ],
          )
        )
      ),
    );
  }

  void handleNavigation(BuildContext context,String message){
    switch(message){
      case 'Employee':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeDetails(title:'Employee Details',firestore: firestore)),
        );
      break;
      case 'Vendor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorDetails(title:'Vendor Details')),
        );
        break;
      case 'Visitor':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VisitorDetails(title:'Visitor Details',firestore: firestore)),
        );
        break;
    }
    final scaffold = Scaffold.of(context);
//    scaffold.showSnackBar(
//      SnackBar(
//        content: Text(message),
//        action: SnackBarAction(
//            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
//      ),
//    );
  }

}