import 'package:flutter/material.dart';

// 1. Import the Firebase core package
import 'package:firebase_core/firebase_core.dart';
// 2. Import the auto-generated Firebase options file
import 'firebase_options.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:sustainableclothing_app/screens/auth_wrapper.dart';

import 'package:sustainableclothing_app/providers/cart_provider.dart'; // 1. ADD THIS
import 'package:provider/provider.dart';


void main() async {

  // 1. Preserve the splash screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. Initialize Firebase (from Module 1)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),

      child: const MyApp(),
    ),
  );



  // 4. Remove the splash screen after app is ready
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {
  // ... (const MyApp)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sustainable Clothing App Store',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // 1. Change this line
      home: const AuthWrapper(), // 2. Set LoginScreen as the home
    );
  }
}

