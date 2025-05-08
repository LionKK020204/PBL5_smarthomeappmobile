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
        try {
          final jsonResponse = jsonDecode(response.body);
          return jsonResponse["state"];
        } catch (_) {
          print("Không parse được JSON: ${response.body}");
        }
      } else {
        print("Lỗi HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
    }
    return null;
  }
}
