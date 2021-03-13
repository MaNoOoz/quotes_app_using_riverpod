// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Quote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteAdapter extends TypeAdapter<Quote> {
  @override
  final int typeId = 0;

  @override
  Quote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quote(
      id: fields[0] as String,
      tags: (fields[1] as List)?.cast<String>(),
      content: fields[2] as String,
      author: fields[3] as String,
      length: fields[4] as int,
      liked: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Quote obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tags)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.author)
      ..writeByte(4)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.liked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
