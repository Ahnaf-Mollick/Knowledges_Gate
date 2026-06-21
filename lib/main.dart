import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knowledges_gate/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Knowledges Gate',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: user != null ? Routes.QUESTIONROUTE : Routes.LOGINROUTE,
      getPages: Routes.routes,
    );
  }
}
