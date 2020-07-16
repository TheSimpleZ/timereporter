import 'dart:convert';

import 'package:Timereporter/services/models/WeeklyData.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendTimeReport(
    String username, String password, Map<String, dynamic> plan,
    {String workOrder,
    String activity,
    String hoursPerDay,
    bool ready,
    List<String> includeDays}) async {
  var url = 'http://192.168.0.17:5000';

  final params = {
    'username': username,
    'password': password,
    'plan': plan,
    if (workOrder?.isNotEmpty == true) 'workOrder': workOrder,
    if (hoursPerDay?.isNotEmpty == true) 'hoursPerDay': hoursPerDay,
    if (includeDays?.isNotEmpty == true) 'includeDays': includeDays,
    if (ready == true) 'ready': ready
  };

  return http.post(url,
      body: jsonEncode(params), headers: {'Content-type': 'application/json'});
}

Future<WeeklyData> getWeeklyData(String username, String password) async {
  var uri = Uri.https("timereporter-api.herokuapp.com", '/',
      {'username': username, 'password': password, 'dryRun': "true"});

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WeeklyData.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    return null;
  }
}
