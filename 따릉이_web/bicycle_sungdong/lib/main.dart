import 'package:bicycle_sungdong/firebase_options.dart';
import 'package:bicycle_sungdong/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firestore 테스트 코드 (데이터 읽어오기)
  final snapshot = await FirebaseFirestore.instance.collection('gesigle').get();
  for (final doc in snapshot.docs) {
    print(doc.data());
  }

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
    @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => ResponsiveBreakpoints.builder(child: child!, breakpoints: [
        Breakpoint(start: 0, end: 450,name: MOBILE),
        Breakpoint(start: 450, end: 800,name: TABLET),
        Breakpoint(start: 801, end: 1920,name: DESKTOP),
        Breakpoint(start: 1921, end: double.infinity,name: '4K'),

      ]),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SungdongBikeMap(),
    );
  }
}
