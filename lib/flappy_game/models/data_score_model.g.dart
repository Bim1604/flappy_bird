// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_score_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataScoreModelAdapter extends TypeAdapter<DataScoreModel> {
  @override
  final int typeId = 2;

  @override
  DataScoreModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataScoreModel(
      data: (fields[0] as List).cast<ScoreModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DataScoreModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataScoreModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
