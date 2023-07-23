
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

import 'package:marquee_widget/marquee_widget.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/functions/playlist_functions.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widget/player_function.dart';



class PlaylistSongs extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final playlistname;
  // final int songindex;
  const PlaylistSongs({required this.playlistname, super.key});

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  late MyPlaylistModel? element;
  late ValueNotifier<List<dynamic>> playlistelementsonglistNotifier;
  // bool shouldReload = false;
  // final playbox = MyPlaylistSongsBox.getInstance();

  @override
  void initState() {
    element = playlistDb.get(widget.playlistname);
    final List playlistelementsonglist = element!.playlistSongs!;
    playlistelementsonglistNotifier =
        ValueNotifier<List<dynamic>>(playlistelementsonglist);
    super.initState();
  }

  removeSongFromPlaylist(int index) {
    element!.playlistSongs!.removeAt(index);
    playlistDb.put(element!.playlistname, element!);

    setState(() {});
    showSnackbar('Removed from playlist', Colors.green, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.playlistname),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color.fromARGB(255, 34, 5, 76), Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Builder(builder: (context) {
          return ValueListenableBuilder<List<dynamic>>(
              valueListenable: playlistelementsonglistNotifier,
              builder: (context, value, child) {
                return element!.playlistSongs!.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor: Colors.grey,
                            onTap: () {
                              audioPlayer.stop();
                              audioList.clear();
                              for (var item in element!.playlistSongs!) {
                                audioList.add(Audio.file(item.songUrl!,
                                    metas: Metas(
                                      title: element!.playlistSongs?[index].name.toString(),

                                      artist: item.artist,
                                      id: item.id.toString(),
                                    )));
                              }
                              playingaudio(context, index);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            leading: QueryArtworkWidget(
                              id: element!.playlistSongs![index].id!,
                              size: 3000,
                              artworkFit: BoxFit.cover,
                              type: ArtworkType.AUDIO,
                              artworkBorder: BorderRadius.circular(10),
                              artworkQuality: FilterQuality.high,
                              // nullArtworkWidget: const Image(
                              //   width: 50,
                              //   height: 50,
                              //   image: AssetImage(
                              //     'assets/images/pulse-music-low-resolution-color-logo.png',
                              //   ),
                              // ),
                            ),
                            title: Marquee(
                              child: Text(
                                element!.playlistSongs![index].name!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            subtitle: Marquee(
                              child: Text(
                                  element!.playlistSongs![index].artist!,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            trailing: PopupMenuButton(
                              color: Colors.white,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // removefromplaylist(index, element!.playlistName);
                                    removeSongFromPlaylist(index);
                                  },
                                  child: const Text('Remove From Playlist'),
                                )),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 5,
                          );
                        },
                        itemCount: element!.playlistSongs!.length)
                    : const Center(
                        child: Text(
                        "No Songs",
                        style: TextStyle(color: Colors.white),
                      ));
              });
        }),
      ),
      // bottomSheet: const MiniPlayer(),
    );
  }

  // playlistDialogue(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text('Add to Playlist'),
  //     actions: [
  //       Center(
  //         child: ElevatedButton(
  //           onPressed: () {
  //             showDialog(
  //               context: context,
  //               builder: (context) => createPlaylistTextfield(context),
  //             );
  //           },
  //           child: const Text('Create New Playlist'),
  //         ),
  //       ),
  //       Center(
  //         child: SizedBox(
  //           width: 200,
  //           height: 200,
  //           child: ValueListenableBuilder<Box<PlaylistSongs>>(
  //             valueListenable: pl.listenable(),
  //             builder: (context, value, child) {
  //               List<PlaylistSongs> playlistitems = playlistDb.values.toList();
  //               return ListView.separated(
  //                 shrinkWrap: true,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(
  //                       playlistitems[index].playlistName.toString(),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                     tileColor: Colors.amber[100],
  //                   );
  //                 },
  //                 itemCount: playlistitems.length,
  //                 separatorBuilder: (BuildContext context, int index) {
  //                   return const SizedBox(
  //                     height: 5,
  //                   );
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  createPlaylistTextfield(BuildContext context) {
    TextEditingController playlistcontroller = TextEditingController();
    final formkey=GlobalKey<FormState>();
    return AlertDialog(
      title: const Text('Create Playlist'),
      actions: [
        SizedBox(
          child: Form(
            key: formkey,
            child: TextFormField(
              validator: (value) {
                return 'empty';
              },
              controller: playlistcontroller,
              decoration: const InputDecoration(
                hintText: 'Playlist Name',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
             if(formkey.currentState!.validate()){
               String name = playlistcontroller.text;
              name!=""?
              createplaylist(name, context):null;
              Navigator.of(context).pop();
             }
            },
            child: const Text('Create'))
      ],
    );
  }
}
