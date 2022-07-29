// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IconInfoAdapter extends TypeAdapter<IconInfo> {
  @override
  final int typeId = 0;

  @override
  IconInfo read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IconInfo(
      name: fields[0] as String,
      value: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, IconInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IconInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
