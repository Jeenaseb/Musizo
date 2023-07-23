import 'package:flutter/material.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/model/playlist_model.dart';

import '../model/allsongmodel.dart';

createplaylist(String name, BuildContext context) async {
  // final playsbox = p.getInstance();
  List<SongDetails> songsplaylist = [];

  List<MyPlaylistModel> list = playlistDb.values.toList();
  bool isnotpresent =
      list.where((element) => element.playlistname == name).isEmpty;

  if (name.isEmpty) {
    showSnackbar("Playlist name can't be empty", Colors.red, context);
  } else if (isnotpresent) {
    playlistDb.put(name,
        MyPlaylistModel(playlistname: name, playlistSongs: songsplaylist));
    showSnackbar('Playlist Created', Colors.green, context);
  } else {
    showSnackbar('That playlist alredy exists', Colors.red, context);
  }
}

editPlaylist(String? playlistName, BuildContext context) {
  TextEditingController editingController = TextEditingController();
  editingController.text = playlistName!;
  final formkey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Playlist Name'),
          content: SizedBox(
            child: Form(
              key: formkey,
              child: TextFormField(
                validator: (value) {
                  if(value!.isEmpty){
                    return 'empty ';
                  }
                  return null;
                },
                controller: editingController,
                decoration: const InputDecoration(
                  hintText: 'Enter new name',
                  border: InputBorder.none,
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  final playlistElement = playlistDb.get(playlistName);
                  final newPlaylistName = editingController.text;

                  // Remove old key-value pair
                  playlistDb.delete(playlistName);

                  // Update playlist name in the playlist element
                  playlistElement?.playlistname = newPlaylistName;

                  // Add new key-value pair with updated playlist name

                  playlistDb.put(newPlaylistName, playlistElement!);

                  showSnackbar(
                      'Playlist name $playlistName changed as $newPlaylistName',
                      Colors.green,
                      context);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Change'),
            ),
          ],
        );
      });
}

deleteplaylist(playlistname, BuildContext context) {
  playlistDb.delete(playlistname);
  showSnackbar("Playlist '$playlistname' deleted ", Colors.green, context);
}

void showSnackbar(String message, Color color, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      elevation: 70,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.white,
    ),
  );
}

addtoPlaylist(id, playlistname, BuildContext context) {
  var plylstelement = playlistDb.get(playlistname);
  // final songboxplylst = alls.getInstance();

  SongDetails songplylst = allsongsDb.get(id)!;
  // bool isalreadyinSameplylst =
  //     plylstelement!.playlistsSongs!.contains(songplylst);
  bool isalreadyinSameplylst =
      plylstelement!.playlistSongs!.any((song) => song.id == songplylst.id);
  if (!isalreadyinSameplylst) {
    plylstelement.playlistSongs!.add(songplylst);
    playlistDb.put(playlistname, plylstelement);
    // plylstelement.save();
    showSnackbar("Added to playlist ", Colors.green, context);
  } else {
    showSnackbar("Song already added to playlist", Colors.red, context);
  }
}
