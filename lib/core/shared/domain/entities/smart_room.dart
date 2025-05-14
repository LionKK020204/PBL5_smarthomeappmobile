import 'package:pbl5_smarthome/core/shared/domain/entities/smart_device.dart';
import 'package:pbl5_smarthome/globals.dart';


import 'music_info.dart';

class SmartRoom {
  SmartRoom({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.temperature,
    required this.airHumidity,
    required this.lights,
    required this.fanCondition,
    required this.timer,
    required this.musicInfo,
    required this.esp32Ip, // Thêm địa chỉ IP ESP32
  });

  final String id;
  final String name;
  final String imageUrl;
  final double temperature;
  final double airHumidity;
  final SmartDevice lights;
  final SmartDevice fanCondition;
  final SmartDevice timer;
  final MusicInfo musicInfo;
  final String esp32Ip; // Địa chỉ IP của ESP32 điều khiển phòng

  SmartRoom copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? temperature,
    double? airHumidity,
    SmartDevice? lights,
    SmartDevice? airCondition,
    SmartDevice? timer,
    MusicInfo? musicInfo,
    String? esp32Ip,
  }) =>
      SmartRoom(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        temperature: temperature ?? this.temperature,
        airHumidity: airHumidity ?? this.airHumidity,
        lights: lights ?? this.lights,
        fanCondition: airCondition ?? this.fanCondition,
        musicInfo: musicInfo ?? this.musicInfo,
        timer: timer ?? this.timer,
        esp32Ip: esp32Ip ?? this.esp32Ip, // Cập nhật địa chỉ IP nếu có
      );

  static List<SmartRoom> fakeValues = [
    _room,
    _room.copyWith(id: '2', name: 'KITCHEN', imageUrl: _imagesUrls[3], esp32Ip: esp32ID),
    _room.copyWith(id: '3', name: 'BEDROOM', imageUrl: _imagesUrls[2], esp32Ip: esp32ID),
    _room.copyWith(id: '4', name: 'BATHROOM', imageUrl: _imagesUrls[1], esp32Ip: esp32ID),
  ];
}

final _room = SmartRoom(
  id: '1',
  name: 'LIVING ROOM',
  imageUrl: _imagesUrls[0],
  temperature: 12,
  airHumidity: 23,
  lights: SmartDevice(type: DeviceType.light, isOn: false, value: 0),
  timer: SmartDevice(type: DeviceType.timer, isOn: false, value: 20),
  fanCondition: SmartDevice(type: DeviceType.fan, isOn: false, value: 0),
  musicInfo: MusicInfo(
    isOn: false,
    currentSong: Song.defaultSong,
  ),
  esp32Ip: esp32ID, // Địa chỉ IP mặc định của ESP32
);

const _imagesUrls = [
  'assets/images/0.jpeg',
  'assets/images/1.jpeg',
  'assets/images/2.jpeg',
  'assets/images/3.jpeg',
];
