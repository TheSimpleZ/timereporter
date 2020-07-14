import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> sendNormalTimeReport(String username, String password,
    String workOrder, String activity, String hoursPerDay, bool ready) async {
  var url = 'https://timereporter-api.herokuapp.com';
  return http.post(url, body: {
    'username': username,
    'password': password,
    'workOrder': workOrder,
    'activity': activity,
    'timeCode': 'Normal time',
    'hoursPerDay': hoursPerDay,
    'ready': ready.toString(),
    'dryRun': "true"
  });
}

Future<List<String>> getWeeklyData(String username, String password) async {
  var uri = Uri.https("timereporter-api.herokuapp.com", '/',
      {'username': username, 'password': password, 'dryRun': "true"});

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return (json.decode(response.body) as List<dynamic>).cast<String>();
  } else {
    // If the server did not return a 200 OK response,
    return null;
  }
}
