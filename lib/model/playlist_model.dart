import 'package:hive_flutter/hive_flutter.dart';

import 'allsongmodel.dart';
part 'playlist_model.g.dart';



@HiveType(typeId: 3)
class MyPlaylistModel{
  @HiveField(0)
  String? playlistname;
  @HiveField(1)
  List<SongDetails>? playlistSongs;
MyPlaylistModel({required this.playlistname,required this.playlistSongs});

}
String playlistBoxName = "Playlist_box";

class MyPlaylistSongsBox {
  static Box<MyPlaylistModel>? _box;
  static Box<MyPlaylistModel> getInstance() {
    return _box ??= Hive.box(playlistBoxName);
  }
}