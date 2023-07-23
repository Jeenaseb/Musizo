import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/playlist_functions.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:musizo/screens/playlist_songs.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistState();
}

class _PlaylistState extends State<PlaylistScreen> {
  final playbox = MyPlaylistSongsBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PlayList'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 34, 5, 76), Colors.purple],
            ),
          ),
          child: ValueListenableBuilder(
            valueListenable: playbox.listenable(),
            builder: (context, value, child) {
              List<MyPlaylistModel> playlistitems = playbox.values.toList();

              return playlistitems.isNotEmpty
                  ? ListView.builder(
                      itemCount: playlistitems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(playlistitems[index].playlistname ?? ''),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  editPlaylist(
                                      playlistitems[index].playlistname,
                                      context);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deletePlaylist(
                                      playlistitems[index]
                                          .playlistname
                                          .toString(),
                                      index);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaylistSongs(
                                      playlistname:
                                          playlistitems[index].playlistname),
                                ));
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No playlist to show',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton(
            child: const Icon(Icons.playlist_add),
            backgroundColor: Colors.white,
            onPressed: () {
              _addPlaylist();
            },
          ),
        ),
      ),
    );
  }

  void _addPlaylist() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController playlistNameController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Playlist'),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(
              labelText: 'Playlist Name',
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                setState(() {
                  String playlistName = playlistNameController.text;
                  createplaylist(playlistName, context);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePlaylist(String playlistname, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Playlist'),
          content: const Text('Are you sure you want to delete this playlist?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  deleteplaylist(playlistname, context);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
