


import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/functions/favoritefunctions.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/model/favouritesmodel.dart';
import 'package:musizo/screens/home_screen.dart';
// import 'package:musizo/screens/mostlyplaylist.dart';

import 'package:on_audio_query/on_audio_query.dart';

import 'now_playing.dart';

class ScreenFavorites extends StatefulWidget {
  
  
  const ScreenFavorites({super.key});

  @override
  State<ScreenFavorites> createState() => _ScreenFavoritesState();
}

class _ScreenFavoritesState extends State<ScreenFavorites> {
    final List<SongDetails> favList =[] ;
    late ValueNotifier<List<SongDetails>> favNotifier;



  @override
  void initState() {
        favNotifier = ValueNotifier<List<SongDetails>>(favList);

   final List<SongDetails> box = allsongsDb.values.toList();
  final List<FavoriteModel> favbox = favouritedb.values.toList();

  for (int i = 0; i < box.length; i++) {
    if (favbox.any((element) => element.id == box[i].id)) {
      favList.add(box[i]);
    }
  }


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(favouritedb.values.length);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liked Songs'),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 34, 5, 76), Colors.purple],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: favNotifier,
                  builder: (context, List<SongDetails> favList, child) {
                    return favList.isEmpty
                        ? const Center(
                            child: Text('No favorite songs available'),
                          )
                        : ListView.separated(
                            itemCount: favList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10,
                            ),
                            itemBuilder: ((context, index) {
                              return ListTile(
                                onTap: () {
                                    audioPlayer.open(Playlist(audios: audioList, startIndex: index));
                                       Navigator.of(context).push(MaterialPageRoute(
                                       builder: (context) => NowPlayingScreen(
                                       index: index,
                                )));
                                },
                                leading: QueryArtworkWidget(
                                  id: favList[index].id!,
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
                                title: Text(favList[index].name!),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                subtitle: Text(favList[index].artist!),
                                trailing: PopupMenuButton<String>(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: TextButton(
                                          onPressed: () {},
                                          child: const Text("Add to Playlist"),
                                        ),
                                      ),
                                      const PopupMenuItem<String>(
                                        value: 'favorites',
                                        child: Text('Remove from favorites',style: TextStyle(color: Colors.blue),),
                                      )
                                    ];
                                  },
                                  onSelected: (String value) {
                                    if (value == 'favorites') {
                                      removeFromFavorites(
                                          favList[index].id!);
                                          setState(() {
                                            favList.removeAt(index);
                                          });

                                    }
                                  },
                                ),
                              );
                            }),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
