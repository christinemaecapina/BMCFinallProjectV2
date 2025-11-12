import 'package:flutter/material.dart';

// 1. Import the Firebase core package
import 'package:firebase_core/firebase_core.dart';
// 2. Import the auto-generated Firebase options file
import 'firebase_options.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:sustainableclothing_app/screens/auth_wrapper.dart';

import 'package:sustainableclothing_app/providers/cart_provider.dart'; // 1. ADD THIS
import 'package:provider/provider.dart'; // 2. Need this
import 'package:firebase_auth/firebase_auth.dart'; // Import for Persistence
import 'package:google_fonts/google_fonts.dart'; // 1. ADD THIS IMPORT

// 2. --- (UPDATED) NEW "MAX PINK" APP COLOR PALETTE ---
const Color kRichBlack = Color(0xFF1C1C1C); // A very dark, rich black for high-contrast text
const Color kHighContrastPink = Color(0xFFFF4081); // A saturated, bright accent pink
const Color kSoftPinkBackground = Color(0xFFFFECEF); // A very light, subtle pink for the main background
const Color kPureWhite = Color(0xFFFFFFFF); // Clean white for card surfaces
// --- END OF COLOR PALETTE ---


void main() async {

  // 1. Preserve the splash screen (Unchanged)
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // 2. Initialize Firebase (Unchanged)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Set web persistence (Unchanged)
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  // 4. --- THIS IS THE FIX ---
  // We manually create the CartProvider instance *before* runApp
  final cartProvider = CartProvider();

  // 5. We call our new initialize method *before* runApp
  cartProvider.initializeAuthListener();

  // 6. This is the old, buggy code we are replacing:
  /*
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // <-- This was the problem

      child: const MyApp(),
    ),
  );
  */

  // 7. This is the NEW code for runApp
  runApp(
    // 8. We use ChangeNotifierProvider.value
    ChangeNotifierProvider.value(
      value: cartProvider, // 9. We provide the instance we already created
      child: const MyApp(),
    ),
  );

  // 10. Remove the splash screen after app is ready (Unchanged)
  FlutterNativeSplash.remove();
}


class MyApp extends StatelessWidget {
  // ... (const MyApp)
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sustain', // Updated app title

      // 1. --- (UPDATED) THIS IS THE NEW, COMPLETE THEME ---
      theme: ThemeData(
        // 2. Set the main color scheme
        colorScheme: ColorScheme.fromSeed(
          seedColor: kHighContrastPink, // Our new primary pink
          brightness: Brightness.light,
          primary: kHighContrastPink,
          onPrimary: Colors.white, // Text on top of the pink (e.g., in buttons)
          secondary: kHighContrastPink.withOpacity(0.8), // Keep secondary strong
          background: kSoftPinkBackground, // Our new soft pink background
          surface: kPureWhite, // Card and other surface elements
          onSurface: kRichBlack, // Text on surfaces
        ),
        useMaterial3: true,

        // 3. Set the background color for all screens
        scaffoldBackgroundColor: kSoftPinkBackground, // Set the pink background

        // 4. --- (FIX) APPLY THE GOOGLE FONT ---
        // This applies "Lato" to all text in the app
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: kRichBlack,
          displayColor: kRichBlack,
        ),

        // 5. --- (FIX) GLOBAL BUTTON STYLE ---
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kHighContrastPink, // Use the vibrant pink
            foregroundColor: Colors.white, // Text color
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // 6. --- (FIX) GLOBAL TEXT FIELD STYLE ---
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: kPureWhite, // Use clean white fill for readability on the pink background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kHighContrastPink.withOpacity(0.3)), // Pink border
          ),
          labelStyle: TextStyle(color: kRichBlack.withOpacity(0.7)),
          hintStyle: TextStyle(color: kRichBlack.withOpacity(0.5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kHighContrastPink, width: 2.0), // Strong pink border when focused
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: kHighContrastPink.withOpacity(0.3)),
          ),
        ),

        // 7. --- (FIX) GLOBAL CARD STYLE ---
        cardTheme: CardThemeData(
          elevation: 1.5, // Subtle shadow
          color: kPureWhite, // Use pure white for cards to contrast with pink background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          // 8. This ensures the images inside the card are rounded
          clipBehavior: Clip.antiAlias,
        ),

        // 9. --- (NEW) GLOBAL APPBAR STYLE ---
        appBarTheme: AppBarTheme(
          backgroundColor: kSoftPinkBackground, // Pink background for the app bar
          foregroundColor: kRichBlack, // Black icons and text
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.lato(
            color: kRichBlack,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Floating Action Button Theme
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kHighContrastPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),

        // Badge Theme (for unread messages, cart count)
        badgeTheme: BadgeThemeData(
          backgroundColor: kHighContrastPink,
          textColor: Colors.white,
          textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        ),
      ),
      // --- END OF NEW THEME ---

      // 1. Change this line
      home: const AuthWrapper(), // 2. Set LoginScreen as the home
    );
  }
}