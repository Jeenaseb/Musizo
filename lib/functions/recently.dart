import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/model/recently_model.dart';

addRecently(id) {
  final box = AllsongsBox.getInstance();

  
  List<SongDetails> songlist = box.values.toList();
  List<RecentlyPlayed> recentlist = recentplayeddb.values.toList();
  bool isalready = false;
  int? rindex;
  for (int i = 0; i < recentlist.length; i++) {
    if (id == recentlist[i].id) {
      isalready = true;
      rindex = i;
      break;
    }
  }
  final index = songlist.indexWhere((element) => element.id == id);
  // final Rindex = recentlist.indexWhere((element) => element.id == id);

  if (isalready && rindex != null) {
    recentplayeddb.deleteAt(rindex);
    recentplayeddb.add(RecentlyPlayed(
        songname: songlist[index].name,
        artist: songlist[index].artist,
        duration: songlist[index].duration,
        songurl: songlist[index].name,
        id: songlist[index].id));
  } else {
    recentplayeddb.add(RecentlyPlayed(
        songname: songlist[index].name,
        artist: songlist[index].artist,
        duration: songlist[index].duration,
        songurl: songlist[index].songUrl,
        id: songlist[index].id));
  }
}