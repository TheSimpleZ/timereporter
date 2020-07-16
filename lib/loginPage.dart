import 'hooks/useSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'hooks/useSharedPrefs.dart';
import 'services/timereport-api.dart';
import 'hooks/useSecureStorage.dart';
import 'hooks/usePersistentTextEditingController.dart';

import 'constants.dart';
import 'customTextFormField.dart';
import 'loginGuard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

part 'loginPage.g.dart';

@hwidget
Widget loginPage(BuildContext context) {
  final _formKey = useMemoized(() => GlobalKey<FormState>());
  final snackBar = useSnackBar(context);
  final loading = useState(false);

  final username =
      usePersistentTextEditingController(StorageKeys.username, useSharedPrefs);
  final password = usePersistentTextEditingController(
      StorageKeys.password, useSecureStorage);

  final hoursPerDay = useSharedPrefs(StorageKeys.hoursPerDay);
  final plans = useSharedPrefs(StorageKeys.plans);
  final workOrderList = useSharedPrefs(StorageKeys.workOrderList);

  logIn() async {
    if (_formKey.currentState.validate()) {
      loading.value = true;
      final data =
          await getWeeklyData(username.value.text, password.value.text);
      loading.value = false;

      final days = data.businessDays;
      hoursPerDay.value = data.hoursPerDay.toString();
      plans.value = {for (var d in days) d: TimeCodes.normalTime};
      workOrderList.value = data.workOrders;

      if (days?.isEmpty == false) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginGuard()));
      } else {
        snackBar.showText(
            "Error logging in! Username or password might be incorrect");
      }
    }
  }

  const spinkit = const SpinKitWave(
      color: const Color(0xffA6A2DC), type: SpinKitWaveType.start);

  return Form(
      key: _formKey,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            // Add TextFormFields and RaisedButton here.
            CustomTextFormField(
              textController: username,
              errorMessage: 'Please enter your email address',
              hintText: 'Your short netlight email',
              labelText: 'Netlight email',
              icon: Icons.email,
              keyBoardType: TextInputType.emailAddress,
            ),
            CustomTextFormField(
              textController: password,
              errorMessage: 'Please enter your password',
              hintText: 'Your netlight password',
              labelText: 'Netlight password',
              icon: Icons.lock,
              keyBoardType: TextInputType.emailAddress,
              obscureText: true,
            ),
            RaisedButton(
              onPressed: loading.value ? null : logIn,
              child: Text(loading.value ? 'Logging in...' : 'Log in'),
            ),
            if (loading.value)
              spinkit
          ])));
}
