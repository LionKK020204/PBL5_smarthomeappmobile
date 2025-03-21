import 'dart:convert';
import 'package:http/http.dart' as http;

class ESP32ControllerLight {
  final String esp32Ip;

  ESP32ControllerLight(this.esp32Ip);

  Future<bool> toggleLight(bool isOn, int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/light/${isOn ? "on" : "off"}?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Light toggled successfully for room $idRoom: ${response.body}");
        return true;
      } else {
        print("Failed to toggle light for room $idRoom: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<String?> getLightStatus(int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/light/status?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["state"];
      } else {
        print("Failed to get light status for room $idRoom: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
