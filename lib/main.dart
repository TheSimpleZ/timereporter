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
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyHomePage(title: 'Report time'),
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
