// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventChatCreatorModelAdapter extends TypeAdapter<EventChatCreatorModel> {
  @override
  final int typeId = 6;

  @override
  EventChatCreatorModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventChatCreatorModel(
      id: fields[0] as int,
      name: fields[1] as String,
      avatar: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventChatCreatorModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventChatCreatorModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventChatDetailModelAdapter extends TypeAdapter<EventChatDetailModel> {
  @override
  final int typeId = 7;

  @override
  EventChatDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventChatDetailModel(
      id: fields[0] as int,
      creator: fields[1] as EventChatCreatorModel,
      role: fields[2] as String,
      created: fields[3] as DateTime,
      modified: fields[4] as DateTime,
      message: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventChatDetailModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creator)
      ..writeByte(2)
      ..write(obj.role)
      ..writeByte(3)
      ..write(obj.created)
      ..writeByte(4)
      ..write(obj.modified)
      ..writeByte(5)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventChatDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
