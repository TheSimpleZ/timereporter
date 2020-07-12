import 'package:http/http.dart' as http;

Future<http.Response> sendNormalTimeReport(String username, String password,
    String workOrder, String activity, String hoursPerDay, bool ready) async {
  var url = 'https://timereporter-api.herokuapp.com/';
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
