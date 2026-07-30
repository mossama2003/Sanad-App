// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteer_communities_cache.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VolunteerCommunitiesCacheAdapter
    extends TypeAdapter<VolunteerCommunitiesCache> {
  @override
  final int typeId = 5;

  @override
  VolunteerCommunitiesCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VolunteerCommunitiesCache(
      communities: (fields[0] as List).cast<VolunteerEventDetailsModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, VolunteerCommunitiesCache obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.communities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VolunteerCommunitiesCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
