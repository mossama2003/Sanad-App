// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_home_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VolunteerHomeModelAdapter extends TypeAdapter<VolunteerHomeModel> {
  @override
  final int typeId = 3;

  @override
  VolunteerHomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VolunteerHomeModel(
      xp: fields[0] as int,
      streak: fields[1] as int,
      badgeCount: fields[2] as int,
      activeEvents: (fields[3] as List).cast<VolunteerEventDetailsModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VolunteerHomeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.xp)
      ..writeByte(1)
      ..write(obj.streak)
      ..writeByte(2)
      ..write(obj.badgeCount)
      ..writeByte(3)
      ..write(obj.activeEvents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolunteerHomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
