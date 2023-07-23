// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyPlaylistModelAdapter extends TypeAdapter<MyPlaylistModel> {
  @override
  final int typeId = 3;

  @override
  MyPlaylistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyPlaylistModel(
      playlistname: fields[0] as String?,
      playlistSongs: (fields[1] as List?)?.cast<SongDetails>(),
    );
  }

  @override
  void write(BinaryWriter writer, MyPlaylistModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistname)
      ..writeByte(1)
      ..write(obj.playlistSongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyPlaylistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
