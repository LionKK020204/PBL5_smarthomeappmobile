import 'package:pbl5_smarthome/core/shared/domain/entities/smart_device.dart';
import 'package:pbl5_smarthome/globals/globals.dart';


import 'music_info.dart';

class SmartRoom {
  SmartRoom({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.temperature,
    required this.airHumidity,
    required this.lights,
    required this.fans,
    required this.timer,
    required this.musicInfo,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double temperature;
  final double airHumidity;
  final SmartDevice lights;
  final SmartDevice fans;
  final SmartDevice timer;
  final MusicInfo musicInfo;

  SmartRoom copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? temperature,
    double? airHumidity,
    SmartDevice? lights,
    SmartDevice? fans,
    SmartDevice? timer,
    MusicInfo? musicInfo,
  }) =>
      SmartRoom(
        id: id ?? this.id,
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        temperature: temperature ?? this.temperature,
        airHumidity: airHumidity ?? this.airHumidity,
        lights: lights ?? this.lights,
        fans: fans ?? this.fans,
        musicInfo: musicInfo ?? this.musicInfo,
        timer: timer ?? this.timer,
      );

  static List<SmartRoom> fakeValues = [
    _room,
    _room.copyWith(id: '2', name: 'KITCHEN', imageUrl: _imagesUrls[3]),
    _room.copyWith(id: '3', name: 'BEDROOM', imageUrl: _imagesUrls[2]),
    _room.copyWith(id: '4', name: 'BATHROOM', imageUrl: _imagesUrls[1]),
  ];
}

final _room = SmartRoom(
  id: '1',
  name: 'LIVING ROOM',
  imageUrl: _imagesUrls[0],
  temperature: 0.0,
  airHumidity: 0.0,
  lights: SmartDevice(type: DeviceType.light, isOn: false, value: 0),
  timer: SmartDevice(type: DeviceType.timer, isOn: false, value: 20),
  fans: SmartDevice(type: DeviceType.fan, isOn: false, value: 0),
  musicInfo: MusicInfo(
    isOn: false,
    currentSong: Song.defaultSong,
  ),
);

const _imagesUrls = [
  'assets/images/0.jpeg',
  'assets/images/1.jpeg',
  'assets/images/2.jpeg',
  'assets/images/3.jpeg',
];
