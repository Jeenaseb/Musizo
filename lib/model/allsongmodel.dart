import 'package:hive_flutter/hive_flutter.dart';
part 'allsongmodel.g.dart';

@HiveType(typeId: 1)
class SongDetails {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  int? id;
  @HiveField(4)
  String? songUrl;

  SongDetails(
      {required this.name,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songUrl});
}
String playlistBoxName = "song_box";

// ignore: non_constant_identifier_names
// late Box<SongDetails> AllSongDb;
// openAllSongs() async {
//   AllSongDb = await Hive.openBox<SongDetails>('all_song_DB');
// }
class AllsongsBox {
  static Box<SongDetails>? _songbox;
  static Box<SongDetails> getInstance() {
    return _songbox ??= Hive.box(playlistBoxName);
  }
}
