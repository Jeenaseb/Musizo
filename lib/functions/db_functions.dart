import 'package:hive/hive.dart';
import 'package:musizo/model/mostlyplaylist_model.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:musizo/model/recently_model.dart';

import '../model/allsongmodel.dart';


late Box<MyPlaylistModel> playlistDb;
openplaylistDb() async {
  playlistDb = await Hive.openBox<MyPlaylistModel>("Playlist_box");
}
late Box<SongDetails> allsongsDb;
openAllsongsDb() async {
  allsongsDb = await Hive.openBox<SongDetails>("song_box");
}

late Box<MostPlayed> mostplayedDb;
openMostPlayed() async{
mostplayedDb = await Hive.openBox<MostPlayed>("MostPlayedDb");
}

late Box<RecentlyPlayed> recentplayeddb;
openRecentPlayed() async{

  // Try{
  // 
  // }
  // catch(e) {

  // }

  try {
  recentplayeddb = await Hive.openBox<RecentlyPlayed>('Recently');
  // code that has potential to throw an exception
} catch (e) {
  print("An error occurred: $e");
}

}


addMostplayedCount(id){

    final mostbox = MostPlayedBox.getInstance();
  MostPlayed temp = mostbox.get(id)!;
  temp.count += 1;
  mostplayedDb.put(id, temp);

 
  
}  