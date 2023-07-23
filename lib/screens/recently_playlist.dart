import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/functions/favoritefunctions.dart';
import 'package:musizo/model/recently_model.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../functions/playlist_functions.dart';
import '../model/playlist_model.dart';
import 'now_playing.dart';

class RecentPlaylistScreen extends StatelessWidget {
  final List<RecentlyPlayed> recentlysongs =
      recentplayeddb.values.toList().reversed.toList();
  RecentPlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recent Playlist'),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 34, 5, 76),
            Colors.purple,
            Color(0xFF521293),
            Color(0xFF14052E)
          ])),
          child: recentlysongs.isEmpty
              ? const Center(child: Text("no recently played songs"))
              : ValueListenableBuilder(
                  valueListenable: recentplayeddb.listenable(),
                  builder: (context, value, child) => ListView.separated(
                    itemCount: recentlysongs.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: ((context, index) {
                      return ListTile(
                        onTap: () {
                          audioPlayer.open(
                              Playlist(audios: audioList, startIndex: index));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => NowPlayingScreen(
                                    index: index,
                                  )));

                        },
                        leading: QueryArtworkWidget(
                          id: recentlysongs[index].id!,
                          type: ArtworkType.AUDIO,
                          size: 3000,
                          artworkFit: BoxFit.cover,
                          artworkBorder: BorderRadius.circular(10),
                          artworkQuality: FilterQuality.high,
                          nullArtworkWidget: const Image(
                            image: AssetImage(
                              'asset/kurt-cobain-mtv-unplugged.jpg',
                            ),
                            width: 50,
                            height: 50,
                          ),
                        ),
                        title: Text(recentlysongs[index].songname!),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        subtitle: Text(recentlysongs[index].artist!),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {
                              isalready(recentlysongs[index].id!) ? removeFromFavorites(recentlysongs[index].id!) : addToFavorites(recentlysongs[index].id!);
                                 
                                  Navigator.pop(context);
                                },
                                child: Text(isalready(recentlysongs[index].id!)
                                    ? 'Remove From favorites'
                                    : 'Add to Favorites'),
                              ),
                            ),
                            PopupMenuItem(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  showDialog(context: context, builder: (context) => playlistDialogue(context, index),);
                                },
                                child: const Text('Add to Playlist'),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                ),
        ),
      ),
    );
  }
playlistDialogue(BuildContext context,  int songindex){
     return AlertDialog(
      title: const Text('Add to Playlist'),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
            Navigator.of(context).pop();
            showDialog(
              context: context, 
              builder: (context) => createPlaylistTextfield(context),);
          }, 
          child: Text('Create new playlist')),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: ValueListenableBuilder<Box<MyPlaylistModel>>(
              valueListenable: playbox.listenable(), 
              builder: (context, value, child) {
                List<MyPlaylistModel> playlistitems = playlistDb.values.toList();
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(playlistitems[index].playlistname.toString(),
                      textAlign: TextAlign.center,
                      ),
                      tileColor: Colors.black,
                      onTap: () {
                        Navigator.of(context).pop();
                        addtoPlaylist(
                          recentlysongs[index].id, 
                          playlistitems[index].playlistname, 
                          context);
                      },
                    );
                  }, 
                  separatorBuilder: (BuildContext context, int index){
                       return const SizedBox(
                        height: 5,
                       );
                  }, 
                  itemCount: playlistitems.length);
              },),
          ),
        )
      ],
     );
  }

  createPlaylistTextfield(BuildContext context){
    TextEditingController playlistcontroller =TextEditingController();
    return AlertDialog(
      title: const Text('Create Playlist'),
      actions: [
        SizedBox(
          child: TextField(
            controller: playlistcontroller,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
              border: InputBorder.none
            ),
            style: const TextStyle(
              fontSize: 20,fontWeight: FontWeight.bold
            ),
          ),
        ),
        ElevatedButton(onPressed: () {
          String name = playlistcontroller.text;
          createplaylist(name, context);
          Navigator.of(context).pop();
        }, 
        child: const Text('Create'))
      ],
    );
  }
}



