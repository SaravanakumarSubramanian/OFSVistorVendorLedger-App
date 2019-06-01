import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';

Future<void> main()async {
    final FirebaseApp app = await FirebaseApp.configure(
        name: 'db2',
        options: Platform.isIOS
            ? const FirebaseOptions(
            googleAppID: '1:626947286714:android:ca30d49a9bf12d70',
            gcmSenderID: '626947286714',
            databaseURL: 'https://visitorledger.firebaseio.com',
            projectID: 'visitorledger',
        )
            : const FirebaseOptions(
            googleAppID: '1:626947286714:android:ca30d49a9bf12d70',
            apiKey: 'AIzaSyBM7pRkADWRP21hx7Lyzr4pZvR08XKlUiY',
            databaseURL: 'https://visitorledger.firebaseio.com',
            projectID: 'visitorledger',
        ),
    );
    final Firestore firestore = Firestore(app: app);
    await firestore.settings(timestampsInSnapshotsEnabled: true);
    runApp(VisitorLedgerApp(firestore: firestore));
}

class VisitorLedgerApp extends StatelessWidget {
    // This widget is the root of your application.
    VisitorLedgerApp({this.firestore});
    final Firestore firestore;

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'VisitorLedger',
            theme: ThemeData(
                primarySwatch: Colors.blue,
            ),
            home: Dashboard(title: 'Dashboard',firestore: firestore),
        );
    }
}

