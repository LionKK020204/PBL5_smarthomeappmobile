enum DeviceType{ light, fan, music, timer }

class SmartDevice {
  SmartDevice({
    required this.type,
    required this.isOn,
    required this.value,
  });

  final DeviceType type;
  bool isOn;
  final int value;

  SmartDevice copyWith({
    DeviceType? type,
    bool? isOn,
    int? value,
  }) {
    return SmartDevice(
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      value: value ?? this.value,
    );
  }
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
