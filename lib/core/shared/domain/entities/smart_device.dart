class SmartDevice {
  SmartDevice({required this.isOn, required this.value});

  late bool isOn;
  final int value;
}
// enum DeviceType { light, fan, music, timer }
//
// class SmartDevice {
//   final String name;
//   final DeviceType type;
//   bool isOn;
//   final int? value;
//
//   SmartDevice({
//     required this.name,
//     required this.type,
//     required this.isOn,
//     this.value,
//   });
// }
