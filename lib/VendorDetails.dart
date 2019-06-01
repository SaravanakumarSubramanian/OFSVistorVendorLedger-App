import 'package:flutter/material.dart';

class VendorDetails extends StatefulWidget{
    VendorDetails({Key key,this.title}) : super(key: key);
    final String title;
    @override
    VendorDetailsState createState() => VendorDetailsState();
    
}

class VendorDetailsState extends State<VendorDetails>{
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
                        
                        ),
                    ),
                )),
        );
    }
    
}