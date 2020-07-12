import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'notifications.dart';
import 'normalTimeForm.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'main.g.dart';

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
    home: MyHomePage(title: 'Report normal time'),
  ));
}

@hwidget
Widget myHomePage(BuildContext context, {title}) {
  useEffect(() {
    initPlugin();
    return null;
  }, []);

  return Scaffold(
    appBar: AppBar(
      title: Text(title),
    ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[NormalTimeForm()],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ), // This trailing comma makes auto-formatting nicer for build methods.
  );
}
