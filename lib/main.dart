import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveDo/model/Contact.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'screens/Contact_page.dart';

void main() async {
  // important ////
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(ContactAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HiveDo Demo',

      /// Box opeining ////
      home: FutureBuilder(
        future: Hive.openBox('contacts',
            compactionStrategy: (int total, int deleted) {
          return deleted > 20;
        }),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else
              return ContactPage();
          } else
            return Scaffold();
        },
      ),
    );
  }

  @override
  void dispose() {
    // automatic compact
    Hive.box('contacts').compact();
    // will close all database
    Hive.close();
    super.dispose();
  }
}
