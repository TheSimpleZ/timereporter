import 'package:Timereporter/reportTimePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useSecureStorage.dart';
import 'hooks/useSharedPrefs.dart';

import 'constants.dart';
import 'defaultSettingsForm.dart';
import 'notifications.dart';
import 'loginPage.dart';

part 'loginGuard.g.dart';

const List<Widget> widgetOptions = <Widget>[
  ReportTimePage(),
  DefaultSettingsForm(),
];

@hwidget
Widget loginGuard(BuildContext context) {
  final username = useSharedPrefs(usernameKey, initialValue: "");
  final password = useSecureStorage(passwordKey, initialValue: "");
  final selectedIndex = useState(0);

  final selectedPage = username.value.isEmpty || password.value.isEmpty
      ? LoginPage()
      : widgetOptions.elementAt(selectedIndex.value);

  useEffect(() {
    initNotificationPlugin();
    return null;
  }, []);

  return Scaffold(
    appBar: AppBar(
      title: Text('Timereporter'),
    ),
    body: SingleChildScrollView(
      child: selectedPage,
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Report time'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
      currentIndex: selectedIndex.value,
      selectedItemColor: Colors.amber[800],
      onTap: (index) => selectedIndex.value = index,
    ),
  );
}
