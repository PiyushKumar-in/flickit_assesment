import 'package:flickit_assesment/screens/Menu_Screen/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData lightTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
    );
    lightTheme = lightTheme.copyWith(
      textTheme: GoogleFonts.icebergTextTheme(lightTheme.textTheme),
    );

    ThemeData darkTheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.lightBlue,
        brightness: Brightness.dark,
      ),
    );
    darkTheme = darkTheme.copyWith(
      textTheme: GoogleFonts.icebergTextTheme(darkTheme.textTheme),
    );

    return MaterialApp(
      title: "Flickit Demo App",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: MenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
