import 'package:Timereporter/reportTimePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useSecureStorage.dart';

import 'constants.dart';
import 'settingsForm.dart';
import 'notifications.dart';
import 'loginPage.dart';

part 'loginGuard.g.dart';

const List<Widget> widgetOptions = <Widget>[
  ReportTimePage(),
  SettingsForm(),
];

@hwidget
Widget loginGuard(BuildContext context) {
  final isLoggedIn =
      useSecureStorage(StorageKeys.isLoggedIn, initialValue: false);
  final selectedIndex = useState(0);

  final selectedPage = !isLoggedIn.value
      ? LoginPage()
      : IndexedStack(
          index: selectedIndex.value,
          children: widgetOptions,
        );

  useEffect(() {
    initNotificationPlugin();
    return null;
  }, []);

  return Scaffold(
    appBar: AppBar(
      title: Text('Timereporter'),
    ),
    body: selectedPage,
    bottomNavigationBar: isLoggedIn.value
        ? BottomNavigationBar(
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
          )
        : null,
  );
}
