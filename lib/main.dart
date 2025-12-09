// lib/main.dart

import 'package:flutter/material.dart';
import 'theme/AppTheme.dart';
import 'app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jawara Apps',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}



