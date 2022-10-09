import 'dart:async';
import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;

void runServer() async {
  WebSocket? ws;

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8088);
  await server.transform(WebSocketTransformer()).forEach((websocket) {
    ws?.close();
    ws = websocket;
    websocket.forEach((data) => http.post(
        Uri.http("192.168.14.8:8090", "/metrics", {"patient_id": "3"}),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(jsonDecode(data)
            .entries
            .map((entry) => {
                  "metric_type": "HEARTRATE",
                  "value": entry.value,
                  "timestamp": entry.key
                })
            .toList())));
  });
}

void Function(String)? onAlert;

void pollAlerts() {
  Stream.periodic(const Duration(seconds: 10)).forEach((_) async {
    final res = await http.post(Uri.http(
        "192.168.14.8:8090", "/medical-alerts/read", {"patient_id": "3"}));
    jsonDecode(utf8.decode(res.bodyBytes))
        .map((resData) => resData["message"])
        .forEach((data) {
      if (onAlert != null) {
        onAlert!(data);
      }
    });
  });
}
