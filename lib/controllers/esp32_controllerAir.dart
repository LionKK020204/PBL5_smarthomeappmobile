import 'dart:convert';
import 'package:http/http.dart' as http;

class ESP32ControllerAir {
  final String esp32Ip;

  ESP32ControllerAir(this.esp32Ip);

  Future<bool> toggleAirConditioner(bool isOn, int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/air/${isOn ? "on" : "off"}?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Air conditioner toggled successfully for room $idRoom: ${response.body}");
        return true;
      } else {
        print("Failed to toggle air conditioner for room $idRoom: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<String?> getAirConditionerStatus(int idRoom) async {
    final url = Uri.parse('http://$esp32Ip/air/status?room=$idRoom');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse["state"];
      } else {
        print("Failed to get air conditioner status for room $idRoom: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
