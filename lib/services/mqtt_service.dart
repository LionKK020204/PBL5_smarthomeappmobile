import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  final String broker;
  final String username;
  final String password;
  final String clientId;

  late MqttServerClient client;
  bool _isConnected = false;

  MQTTService({
    required this.broker,
    required this.username,
    required this.password,
    required this.clientId,
  });

  Future<void> connect() async {
    client = MqttServerClient(broker, clientId);
    client.port = 1884;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.secure = false;
    client.setProtocolV311();
    client.autoReconnect = true;

    client.connectionMessage = MqttConnectMessage()
        .authenticateAs(username, password)
        .withClientIdentifier(clientId)
        .startClean();

    try {
      final connectionStatus = await client.connect();

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;
        print('✅ MQTT kết nối thành công');
      } else {
        print('❌ MQTT kết nối thất bại: ${client.connectionStatus}');
        disconnect();
      }
    } catch (e) {
      print('❌ Lỗi kết nối MQTT: $e');
      disconnect();
    }
  }


  void publish(String topic, String message) {
    if (!_isConnected) {
      print('⚠️ Không thể gửi. MQTT chưa kết nối.');
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    print('📤 Đã gửi: [$topic] → $message');
  }

  final Map<String, Function(String)> _listeners = {};

  void subscribe(String topic, Function(String) onMessage) {
    if (!_isConnected) {
      print('⚠️ Không thể đăng ký. MQTT chưa kết nối.');
      return;
    }

    client.subscribe(topic, MqttQos.atMostOnce);
    _listeners[topic] = onMessage; // Ghi lại callback

    // Đảm bảo chỉ đăng ký `updates.listen` duy nhất 1 lần
    _startListening();
  }

  bool _isListening = false;

  void _startListening() {
    if (_isListening) return; // Đã lắng nghe rồi
    _isListening = true;

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      if (c == null || c.isEmpty) return;

      for (var msg in c) {
        final topic = msg.topic;
        final payload = msg.payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(payload.payload.message);

        print('📥 Nhận dữ liệu từ [$topic]: $message');

        if (_listeners.containsKey(topic)) {
          _listeners[topic]!(message); // Gọi đúng callback
        }
      }
    });
  }


  void disconnect() {
    _isConnected = false;
    client.disconnect();
  }

  void onConnected() {
    print('🔌 MQTT đã kết nối');

  }

  void onDisconnected() {
    _isConnected = false;
    print('📴 MQTT đã ngắt kết nối');
  }

  void onSubscribed(String topic) {
    print('🔔 Đã đăng ký topic: $topic');
    publish('home/app/status', 'CONNECTED');
  }

  bool get isConnected => _isConnected;
}
