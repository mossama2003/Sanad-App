// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_event_details_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrganizationEventDetailsModelAdapter
    extends TypeAdapter<OrganizationEventDetailsModel> {
  @override
  final int typeId = 1;

  @override
  OrganizationEventDetailsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrganizationEventDetailsModel(
      id: fields[0] as int,
      creator: (fields[1] as Map?)?.cast<String, dynamic>(),
      location: (fields[2] as Map?)?.cast<String, dynamic>(),
      joiners: fields[3] as int,
      attendees: fields[4] as int,
      spots: fields[5] as int,
      joined: fields[6] as bool,
      avgRating: fields[7] as double,
      unreadChatMessages: fields[8] as int,
      latestMessage: (fields[9] as Map?)?.cast<String, dynamic>(),
      cover: fields[10] as String?,
      name: fields[11] as String,
      description: fields[12] as String,
      category: fields[13] as String,
      date: fields[14] as DateTime,
      due: fields[15] as DateTime?,
      skills: (fields[16] as List).cast<String>(),
      status: fields[17] as String,
      qr: fields[18] as String?,
      created: fields[19] as DateTime?,
      modified: fields[20] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OrganizationEventDetailsModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.creator)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.joiners)
      ..writeByte(4)
      ..write(obj.attendees)
      ..writeByte(5)
      ..write(obj.spots)
      ..writeByte(6)
      ..write(obj.joined)
      ..writeByte(7)
      ..write(obj.avgRating)
      ..writeByte(8)
      ..write(obj.unreadChatMessages)
      ..writeByte(9)
      ..write(obj.latestMessage)
      ..writeByte(10)
      ..write(obj.cover)
      ..writeByte(11)
      ..write(obj.name)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.category)
      ..writeByte(14)
      ..write(obj.date)
      ..writeByte(15)
      ..write(obj.due)
      ..writeByte(16)
      ..write(obj.skills)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.qr)
      ..writeByte(19)
      ..write(obj.created)
      ..writeByte(20)
      ..write(obj.modified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationEventDetailsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
