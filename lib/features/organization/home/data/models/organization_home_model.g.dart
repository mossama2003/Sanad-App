// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_home_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationHomeModelAdapter extends TypeAdapter<OrganizationHomeModel> {
  @override
  final int typeId = 4;

  @override
  OrganizationHomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationHomeModel(
      activeEventsCount: fields[0] as int,
      completedEventsCount: fields[1] as int,
      attendanceCount: fields[2] as int,
      activeEvents: (fields[3] as List).cast<OrganizationEventDetailsModel>(),
      recentCompletedEvents:
          (fields[4] as List).cast<OrganizationEventDetailsModel>(),
      organizationName: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationHomeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.activeEventsCount)
      ..writeByte(1)
      ..write(obj.completedEventsCount)
      ..writeByte(2)
      ..write(obj.attendanceCount)
      ..writeByte(3)
      ..write(obj.activeEvents)
      ..writeByte(4)
      ..write(obj.recentCompletedEvents)
      ..writeByte(5)
      ..write(obj.organizationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationHomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
