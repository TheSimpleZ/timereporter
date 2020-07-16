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
  var url = 'https://timereporter-api.herokuapp.com';

  final credentials = "$username:$password";

  final params = {
    'plan': plan,
    if (workOrder?.isNotEmpty == true) 'workOrder': workOrder,
    if (hoursPerDay?.isNotEmpty == true) 'hoursPerDay': hoursPerDay,
    if (includeDays?.isNotEmpty == true) 'includeDays': includeDays,
    if (ready == true) 'ready': ready
  };

  return http.post(url, body: jsonEncode(params), headers: {
    'Content-type': 'application/json',
    'Authorization': base64.encode(utf8.encode(credentials))
  });
}

Future<WeeklyData> getWeeklyData(String username, String password) async {
  final url = 'https://timereporter-api.herokuapp.com';
  final credentials = "$username:$password";

  final response = await http.get(url,
      headers: {'Authorization': base64.encode(utf8.encode(credentials))});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return WeeklyData.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    return null;
  }
}
