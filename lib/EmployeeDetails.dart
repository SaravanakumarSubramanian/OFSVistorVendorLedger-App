import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDetails extends StatefulWidget{
    EmployeeDetails({Key key,this.title,this.app,this.firestore}) : super(key: key);
    final String title;
    final FirebaseApp app;
    final Firestore firestore;
    @override
    EmployeeDetailsState createState() => EmployeeDetailsState(firestore);
    
}

class EmployeeDetailsState extends State<EmployeeDetails>{

    final Firestore firestore;
    String dropdownValue = 'Agate';
    TextEditingController employeeName = new TextEditingController();
    TextEditingController employeeId = new TextEditingController();
    TextEditingController employeeNumber = new TextEditingController();
    TextEditingController temporaryId = new TextEditingController();

  EmployeeDetailsState(this.firestore);
    void initState(){
        super.initState();

    }


    @override
    void dispose() {
        super.dispose();
    }
    
    handleEmployeeEntry(context){

        Map<String, dynamic> employeeEntryMap = new Map<String, dynamic>();
        employeeEntryMap['employee_name']=employeeName.text;
        employeeEntryMap['employee_id']=employeeId.text;
        employeeEntryMap['employee_mobile']=employeeNumber.text;
        employeeEntryMap['temporary_id']=temporaryId.text;
        employeeEntryMap['Location']=dropdownValue;

        DocumentReference employeeEntry =
        firestore.collection('Employee Entry').document(new DateTime.now().millisecondsSinceEpoch.toString());

       firestore.runTransaction((transaction) async {
            await transaction.set(employeeEntry, employeeEntryMap);
            print("instance created");
        }).then((res){
            this.setState(() {
                employeeName.clear();
                employeeId.clear();
                employeeNumber.clear();
                temporaryId.clear();
            });
        });
        
//        FirebaseDatabase.instance.reference().child(dropdownValue).child(new DateTime.now().millisecondsSinceEpoch.toString())
//            .set({
//            'employee_name': employeeName.text,
//            'employee_id': employeeId.text,
//            'employee_mobile':employeeNumber.text,
//            'temporary_id':temporaryId.text
//        }).then((res){
//            this.setState(() {
//                employeeName.clear();
//                employeeId.clear();
//                employeeNumber.clear();
//                temporaryId.clear();
//            });
//
//        }).catchError((error){
//            this.setState(() {
//                employeeName.clear();
//                employeeId.clear();
//                employeeNumber.clear();
//                temporaryId.clear();
//            });
//            final scaffold = Scaffold.of(context);
//            scaffold.showSnackBar(
//              SnackBar(
//                content: Text('An error occured Please try later'),
//                action: SnackBarAction(
//                    label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
//              ),
//            );
//        });
    }
    @override
    Widget build(BuildContext context) {
        
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Builder(
                builder:(context)=> SingleChildScrollView(
                    child: Center(
                        child: Column(
                            children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child:TextFormField(
                                        controller: employeeName,
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(style: BorderStyle.solid)
                                            ),
                                            icon: Icon(Icons.person),
                                            hintText: 'Employee name',
                                            labelText: 'Employee name',
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return 'Please enter some text';
                                            }
                                        },
                                    ),
                                ),
                                
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child:TextFormField(
                                        controller: employeeId,
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(style: BorderStyle.solid)
                                            ),
                                            icon: Icon(Icons.person),
                                            hintText: 'Employee id',
                                            labelText: 'Employee id',
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return 'Please enter some text';
                                            }
                                        },
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child:TextFormField(
                                        controller: employeeNumber,
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(style: BorderStyle.solid)
                                            ),
                                            icon: Icon(Icons.person),
                                            hintText: 'Employee number',
                                            labelText: 'Employee number',
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return 'Please enter some text';
                                            }
                                        },
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child:TextFormField(
                                        controller: temporaryId,
                                        textAlign: TextAlign.start,
                                        decoration: const InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(style: BorderStyle.solid)
                                            ),
                                            icon: Icon(Icons.person),
                                            hintText: 'Temporary Id',
                                            labelText: 'Temporary Id',
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return 'Please enter some text';
                                            }
                                        },
                                    ),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),

                                    child: ListTile(
                                        leading: Icon(
                                            Icons.map,

                                        ),
                                        title:DropdownButtonFormField(

                                            decoration: InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.black),
                                                )
                                            ),
                                            value: dropdownValue,
                                            onChanged: (String newValue) {
                                                setState(() {
                                                    dropdownValue = newValue;
                                                });
                                            },
                                            items: <String>['Agate', 'Burmite', 'Citrine']
                                                .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(value),
                                                );
                                            })
                                                .toList(),
                                        
                                        ),
                                    ),
                                ),
                                Padding(
                                    padding : EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child: ButtonTheme(
                                        minWidth: double.infinity,
                                        height: 48,
                                        textTheme: ButtonTextTheme.normal,
                                        child: RaisedButton(
                                            child:Text('Submit',style:TextStyle(color: Colors.white,fontSize: 20)),
                                            onPressed: ()=>handleEmployeeEntry(context)
                                        )
                                    )
                                )
                            ],
                        ),
                    ),
                )),
        );
    }
    
}