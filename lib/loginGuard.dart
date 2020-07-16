import 'package:Timereporter/reportTimePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useSecureStorage.dart';
import 'hooks/useSharedPrefs.dart';

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
  final username = useSharedPrefs(StorageKeys.username, initialValue: "");
  final password = useSecureStorage(StorageKeys.password, initialValue: "");
  final selectedIndex = useState(0);
  final bucket = useMemoized(() => PageStorageBucket());

  final isLoggedIn = username.value.isNotEmpty && password.value.isNotEmpty;

  final selectedPage =
      !isLoggedIn ? LoginPage() : widgetOptions.elementAt(selectedIndex.value);

  useEffect(() {
    initNotificationPlugin();
    return null;
  }, []);

  return Scaffold(
    appBar: AppBar(
      title: Text('Timereporter'),
    ),
    body: PageStorage(
      child: selectedPage,
      bucket: bucket,
    ),
    bottomNavigationBar: isLoggedIn
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
