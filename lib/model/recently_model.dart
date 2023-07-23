import 'package:hive_flutter/hive_flutter.dart';
part 'recently_model.g.dart';

@HiveType(typeId: 5)
class RecentlyPlayed{
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;



  RecentlyPlayed(
    {
      required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id
    }
  );

 
}

 class RecentlyPlayedBox{
    static Box<RecentlyPlayed>? _box;
    static Box<RecentlyPlayed> getinstance(){
      return _box ??= Hive.box('Recent');
    }

  }