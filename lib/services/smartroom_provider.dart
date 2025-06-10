import 'package:flutter/cupertino.dart';

import '../core/shared/domain/entities/smart_room.dart';

class SmartRoomProvider extends ChangeNotifier {
  final Map<String, SmartRoom> _rooms = {
    for (var room in SmartRoom.fakeValues) room.id: room,
  };

  SmartRoom getRoomById(String id) => _rooms[id]!;

  void updateRoom(String id, SmartRoom updatedRoom) {
    _rooms[id] = updatedRoom;
    notifyListeners();
  }
}
