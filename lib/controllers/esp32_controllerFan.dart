import 'dart:convert';
import 'package:http/http.dart' as http;

class ESP32ControllerFan {
  final String esp32Ip;

  ESP32ControllerFan(this.esp32Ip);

  Future<bool> toggleFan(bool isOn, int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/fun/${isOn ? "on" : "off"}?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Fun toggled successfully for room $idRoom: ${response.body}");
        return true;
      } else {
        print("Failed to toggle Fun for room $idRoom: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<String?> getAirConditionerStatus(int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/fun/status?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["state"];
      } else {
        print("Failed to fun status for room $idRoom: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
