import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:firebase_storage/firebase_storage.dart';
class VisitorDetails extends StatefulWidget{
    VisitorDetails({Key key,this.title,this.firestore}) : super(key: key);
    final String title;
    final Firestore firestore;
    @override
    VisitorDetailsState createState() => VisitorDetailsState(firestore);
}

class VisitorType {
    const VisitorType(this.label,this.type);

    final String label;
    final String type;
}

class VisitorLocation {
    const VisitorLocation(this.label,this.location);

    final String label;
    final String location;
}


class VisitorIDProofType {
    const VisitorIDProofType(this.label,this.idProofType);

    final String label;
    final String idProofType;
}

class VisitorDetailsState extends State<VisitorDetails>{
    List<String> imagePathArray = new List();
    final Firestore firestore;
    String deviceType;
    VisitorIDProofType selectedIdProofType;
    VisitorType selectedVisitorType;
    VisitorLocation selectedLocation;
    final _formKey = GlobalKey<FormState>();
    var fabVisible =true;
    var initTime;
    List<VisitorType> visitorType = <VisitorType>[const VisitorType("Select visitor type",'Select visitor type'),
        const VisitorType("Interview Candidate",'Interview Candidate'),const VisitorType("Client",'Client'),const VisitorType("Auditor",'Auditor')];
    List<VisitorLocation> visitorLocation = <VisitorLocation>[const VisitorLocation("Agate",'Agate'),
        const VisitorLocation("Burmite",'Burmite'),const VisitorLocation("Citrine",'Citrine')];
    List<VisitorIDProofType> visitorIdProofType = <VisitorIDProofType>[const VisitorIDProofType("Select visitor id type",'Select visitor id type'),const VisitorIDProofType("Voter Id",'Voter Id'),
        const VisitorIDProofType("Adhaar card",'Adhaar card'),const VisitorIDProofType("Driving License",'Driving License'),
        const VisitorIDProofType("Pan card",'Pan card')];
    TextEditingController visitorName = new TextEditingController();
    TextEditingController visitorMobileNumber = new TextEditingController();
    TextEditingController visitorEmail = new TextEditingController();
    TextEditingController purposeOfVisit = new TextEditingController();
    TextEditingController contactPerson = new TextEditingController();
    TextEditingController visitorIdNumber = new TextEditingController();

    TextEditingController deviceTypeCtrl = new TextEditingController();
    TextEditingController deviceModelCtrl = new TextEditingController();
    TextEditingController deviceSerialCtrl = new TextEditingController();
    ScrollController scrollController;
    CameraController controller;
    VisitorDetailsState(this.firestore);

    Future<bool> onWillPop() {
        return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit Visitor Entry'),
                actions: <Widget>[
                    new FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('No'),
                    ),
                    new FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: new Text('Yes'),
                    ),
                ],
            ),
        ) ?? false;
    }
    @override
    void initState() {
        fabVisible = true;
        initTime = new DateTime.now().millisecondsSinceEpoch.toString();
        scrollController = new ScrollController();
        selectedVisitorType=visitorType[0];



        scrollController.addListener(() async {
            if (scrollController.position.userScrollDirection ==
                ScrollDirection.forward) {
                setState(() {
                    fabVisible = true;
                });
            }
            if (scrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
                setState(() {
                    fabVisible = false;
                });
            }
        });
    }


    handleAddDevice(){
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("Device information"),
                    content: SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                        child:TextFormField(
                                            controller: deviceTypeCtrl,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                hintText: 'Device type',
                                                labelText: 'Device type',
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
                                            controller: deviceModelCtrl,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                hintText: 'Model number',
                                                labelText: 'Model number',
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
                                            controller: deviceSerialCtrl,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                hintText: 'Serial number',
                                                labelText: 'Serial number',
                                            ),
                                            validator: (value) {
                                                if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                }
                                            },
                                        ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                            child: Text("Submit"),
                                            onPressed: () {
                                                Map<String, dynamic> deviceEntry = new Map<String, dynamic>();
                                                deviceEntry['device_type']=deviceTypeCtrl.text;
                                                deviceEntry['device_model']=deviceModelCtrl.text;
                                                deviceEntry['device_serial_no']=deviceSerialCtrl.text;

                                                DocumentReference deviceRef = firestore
                                                    .collection('Visitor Entry').document(initTime)
                                                    .collection('Device Entry').document(new DateTime.now().millisecondsSinceEpoch.toString());
                                                firestore.runTransaction((transaction) async {
                                                    await transaction.set(deviceRef, deviceEntry);
                                                    print("instance created");
                                                }).then((res){
                                                    deviceTypeCtrl.clear();
                                                    deviceModelCtrl.clear();
                                                    deviceSerialCtrl.clear();
                                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                                });
                                            },
                                        ),
                                    )
                                ],
                            ),
                        ),
                    )
                );
            });
    }

    handleVisitorEntry(context){
        Map<String, dynamic> visitorEntryMap = new Map<String, dynamic>();
        visitorEntryMap['name']=visitorName.text;
        visitorEntryMap['mobile']=visitorMobileNumber.text;
        visitorEntryMap['email']=visitorEmail.text;
        visitorEntryMap['purpose_of_visit']=purposeOfVisit.text;
        visitorEntryMap['contact_person']=contactPerson.text;
        visitorEntryMap['temporary_id']=visitorIdNumber.text;
        visitorEntryMap['visitor_type']=selectedVisitorType.type;
        visitorEntryMap['visitor_id_proof_type']=selectedIdProofType.idProofType;
        visitorEntryMap['location']=selectedLocation.location;
        visitorEntryMap['entry_type']="Visitor";

        DocumentReference visitorEntry =
        firestore.collection('Visitor Entry').document(initTime);
        firestore.runTransaction((transaction) async {
            await transaction.set(visitorEntry, visitorEntryMap);
            print("instance created");
        }).then((res){
            this.setState(() {
                visitorName.clear();
                visitorMobileNumber.clear();
                visitorEmail.clear();
                purposeOfVisit.clear();
                contactPerson.clear();
                visitorIdNumber.clear();
                selectedVisitorType=visitorType[0];
                selectedLocation=visitorLocation[0];
                selectedIdProofType = visitorIdProofType[0];
            });
        });
    }

    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

    showInSnackBar(content){
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
            SnackBar(
                content: Text(content),
                action: SnackBarAction(
                    label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
            ),
        );
    }

    navigateAndDisplaySelection(BuildContext context) async {
        // Navigator.push returns a Future that will complete after we call
        // Navigator.pop on the Selection Screen!
        final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>CameraApp() ),
        );
        print("=============+++++++++++++++++++===========================");
        print(result);
        final String fileName = initTime.toString() +'.jpg';
        final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(fileName);

        final StorageUploadTask uploadTask = storageRef.putFile(
            File(result),
            StorageMetadata(
                contentType:"image/jpg",
            ),
        );
        final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());
        Map<String, dynamic> photoEntry = new Map<String, dynamic>();
        photoEntry['storage_url']=url;

        DocumentReference deviceRef = firestore
            .collection('Visitor Entry').document(initTime)
            .collection('Photo Entry').document(new DateTime.now().millisecondsSinceEpoch.toString());
        firestore.runTransaction((transaction) async {
            await transaction.set(deviceRef, photoEntry);
            print("instance created");
        }).then((res){
        });
        print('URL Is $url');
    }





    @override
    Widget build(BuildContext context) {

        return WillPopScope(
            onWillPop: onWillPop,
            child:Scaffold(
                appBar: AppBar(
                    title: Text(widget.title),
                ),
                floatingActionButton: Visibility(visible:  fabVisible,
                    child: SpeedDial(
                        animatedIcon: AnimatedIcons.menu_close,
                        animatedIconTheme: IconThemeData(size: 22),
                        backgroundColor: Colors.blueAccent,
                        visible: true,
                        curve: Curves.bounceIn,
                        children: [
                            // FAB 1
                            SpeedDialChild(
                                child: Icon(Icons.devices),
                                backgroundColor: Colors.blueAccent,
                                onTap: () =>handleAddDevice(),
                                label: 'Add Devices',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16.0),
                                labelBackgroundColor:Colors.blueAccent),
                            // FAB 2
                            SpeedDialChild(
                                child: Icon(Icons.camera_alt),
                                backgroundColor: Colors.blueAccent,
                                onTap: () => navigateAndDisplaySelection(context),
                                label: 'Attachment',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 16.0),
                                labelBackgroundColor: Colors.blueAccent)
                        ],
                    )
                ),
                body: Builder(
                    builder:(context)=> SingleChildScrollView(
                        controller: scrollController,
                        child: Center(
                            child: Column(
                                children: <Widget>[
                                    Row(
                                        children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                                                child:Icon(
                                                    Icons.location_on,
                                                    color:Colors.black54

                                                )),
                                            Flexible(
                                                child:Padding(
                                                    padding: EdgeInsets.only(left:0,top: 8,bottom:8,right:16),
                                                    child:DropdownButtonFormField<VisitorType>(

                                                        decoration: InputDecoration(

                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.greenAccent),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.black),
                                                            )
                                                        ),
                                                        value: selectedVisitorType,
                                                        hint: Text('Select visitor type'),
                                                        onChanged: (VisitorType newValue) {
                                                            setState(() {
                                                                selectedVisitorType = newValue;
                                                            });
                                                        },
                                                        items: visitorType.map((VisitorType visitorType){
                                                            return new DropdownMenuItem<VisitorType>(
                                                                value: visitorType,
                                                                child: Text(visitorType.type),
                                                            );
                                                        }).toList(),

                                                    ),

                                                ),
                                            )
                                        ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                        child:TextFormField(
                                            controller: visitorName,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.person),
                                                hintText: 'Visitor name',
                                                labelText: 'Visitor name',
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
                                            controller: visitorMobileNumber,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.phone),
                                                hintText: 'Visitor mobile number',
                                                labelText: 'Visitor mobile number',
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
                                            controller: visitorEmail,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.email),
                                                hintText: 'Visitor email',
                                                labelText: 'Visitor email',
                                            ),
                                            validator: (value) {
                                                if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                }
                                            },
                                        ),
                                    ),
                                    Row(
                                        children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                                                child:Icon(
                                                    Icons.location_on,
                                                    color:Colors.black54

                                                )),
                                            Flexible(
                                                child:Padding(
                                                    padding: EdgeInsets.only(left:0,top: 8,bottom:8,right:16),
                                                    child:DropdownButtonFormField<VisitorIDProofType>(

                                                        decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.greenAccent),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.black),
                                                            )
                                                        ),
                                                        hint: Text('Select visitor id proof type'),
                                                        value: selectedIdProofType,
                                                        onChanged: (VisitorIDProofType newValue) {
                                                            setState(() {
                                                                selectedIdProofType = newValue;
                                                            });
                                                        },
                                                        items: visitorIdProofType.map((VisitorIDProofType visitorIdProofType) {
                                                            return DropdownMenuItem<VisitorIDProofType>(
                                                                value: visitorIdProofType,
                                                                child: Text(visitorIdProofType.idProofType),
                                                            );
                                                        })
                                                            .toList(),

                                                    ),

                                                ),
                                            )]
                                    ),

                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                        child:TextFormField(
                                            controller: purposeOfVisit,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.fingerprint),
                                                hintText: 'Purpose of visit',
                                                labelText: 'Purpose of visit',
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
                                            controller: contactPerson,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.person),
                                                hintText: 'Contact Person',
                                                labelText: 'Contact Person',
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
                                            controller: visitorIdNumber,
                                            textAlign: TextAlign.start,
                                            decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(color: Colors.greenAccent, width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(style: BorderStyle.solid)
                                                ),
                                                icon: Icon(Icons.perm_identity),
                                                hintText: 'visitor id number',
                                                labelText: 'visitor id number',
                                            ),
                                            validator: (value) {
                                                if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                }
                                            },
                                        ),
                                    ),
                                    Row(
                                        children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
                                                child:Icon(
                                                    Icons.location_on,
                                                    color:Colors.black54

                                                )),
                                            Flexible(
                                                child:Padding(
                                                    padding: EdgeInsets.only(left:0,top: 8,bottom:8,right:16),
                                                    child:DropdownButtonFormField<VisitorLocation>(
                                                        decoration: InputDecoration(
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.greenAccent),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.black),
                                                            )
                                                        ),
                                                        value: selectedLocation,
                                                        hint: Text('Select visitor Location'),
                                                        onChanged: (VisitorLocation newValue) {
                                                            setState(() {
                                                                selectedLocation = newValue;
                                                            });
                                                        },
                                                        items: visitorLocation.map((VisitorLocation visitorLocation){
                                                            return new DropdownMenuItem<VisitorLocation>(
                                                                value: visitorLocation,
                                                                child: Text(visitorLocation.location),
                                                            );
                                                        }).toList(),

                                                    ),

                                                ),
                                            )]
                                    ),

                                    Padding(
                                        padding : EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                        child: ButtonTheme(
                                            minWidth: double.infinity,
                                            height: 48,
                                            textTheme: ButtonTextTheme.normal,
                                            child: RaisedButton(
                                                child:Text('Submit',style:TextStyle(color: Colors.white,fontSize: 20)),
                                                onPressed: ()=>handleVisitorEntry(context)
                                            )
                                        )
                                    )
                                ],

                            ),
                        ),
                    )),
            ),
        );
    }

}

List<CameraDescription> cameras;
class CameraApp extends StatefulWidget {
    @override
    _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
    CameraController controller;

    @override
    void initState() {
        super.initState();
        initCamera().then((data){
            print('=========================================================');
            print(cameras);
            print('=========================================================');
            controller = CameraController(cameras[0], ResolutionPreset.high);
            controller.initialize().then((_) {
                if (!mounted) {
                    return;
                }
                setState(() {});
            });
        });
    }

    @override
    void dispose() {
        controller?.dispose();
        super.dispose();
    }

    Future<void> initCamera() async {
        cameras = await availableCameras();
    }

    Future<String> takePicture() async {
        if (!controller.value.isInitialized) {
            showInSnackBar('Error: select a camera first.');
            return null;
        }
        PermissionStatus writ = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
        PermissionStatus read = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
        print(writ);print(read);
        final Directory extDir = await getExternalStorageDirectory();
        final String dirPath = '${extDir.path}/Pictures/flutter_test';
        await Directory(dirPath).create(recursive: true);
        final String filePath = '$dirPath/${timestamp()}.jpg';

        if (controller.value.isTakingPicture) {
            // A capture is already pending, do nothing.
            return null;
        }

        try {
            await controller.takePicture(filePath);
        } on CameraException catch (e) {
            showCameraException(e);
            return null;
        }
        return filePath;
    }

    void showCameraException(CameraException e) {
        showInSnackBar('Error: ${e.code}\n${e.description}');
    }

    void resolvePicture(){
        takePicture().then((res){
            controller.dispose().then((done){
                print("path========================================================");
                print(res);
                print("path========================================================");
                Navigator.pop(context,res);
            });

        });
    }

    String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

    showInSnackBar(content){
        final scaffold = Scaffold.of(context);
        scaffold.showSnackBar(
            SnackBar(
                content: Text(content),
                action: SnackBarAction(
                    label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
            ),
        );
    }


    @override
    Widget build(BuildContext context) {
        if (!controller.value.isInitialized) {
            return Container();
        }
        return AspectRatio(
            aspectRatio:controller.value.aspectRatio,
            child:Scaffold(
                body:  CameraPreview(controller),
                floatingActionButton: FloatingActionButton(
                    onPressed: ()=>resolvePicture(),
                    child: Icon(Icons.camera)

                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            )
        );
    }
}