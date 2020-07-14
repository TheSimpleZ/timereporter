import 'package:flutter/material.dart';

import 'loginGuard.dart';

void main() {
  runApp(MaterialApp(
    title: 'Timereporter',
    theme: ThemeData(
      primarySwatch: const MaterialColor(
        0xff7473BD,
        <int, Color>{
          50: Color(0x197473BD),
          100: Color(0x327473BD),
          200: Color(0x487473BD),
          300: Color(0x647473BD),
          400: Color(0x7D7473BD),
          500: Color(0x967473BD),
          600: Color(0xAF7473BD),
          700: Color(0xC87473BD),
          800: Color(0xE17473BD),
          900: Color(0xff7473BD),
        },
      ),
      accentColor: const Color(0xffA6A2DC),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: LoginGuard(),
  ));
}
