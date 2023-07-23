import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/functions/favoritefunctions.dart';
import 'package:musizo/functions/playlist_functions.dart';
import 'package:musizo/functions/recently.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/screens/favorites.dart';
import 'package:musizo/screens/mini_screen.dart';
import 'package:musizo/screens/mostly_playlist.dart';
import 'package:musizo/screens/recently_playlist.dart';
import 'package:musizo/screens/settings.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'now_playing.dart';

List<SongDetails> songall = allsongsDb.values.toList();
List<Audio> audioList = [];
final playbox = MyPlaylistSongsBox.getInstance();
AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    for (var item in songall) {
      audioList.add(Audio.file(item.songUrl!,
          metas: Metas(
            title: item.name,
            artist: item.artist,
            id: item.id.toString(),
          )));
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      appBar: AppBar(
        primary: false,
        // ignore: prefer_const_constructors
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Hello \nWelcome...'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ScreenFavorites(),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ScreenSetting(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color.fromARGB(255, 34, 5, 76), Colors.purple],
        )),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>  RecentPlaylistScreen(),
                        ));
                      },
                      child: Container(
                        height: 160,
                        width: 150,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                              image: AssetImage(
                                  'asset/kurt-cobain-mtv-unplugged.jpg'),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const Text(
                      'Recently Played',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MostlyPlayedScreen()));
                      },
                      child: Container(
                        height: 160,
                        width: 150,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage(
                                    'asset/blogs-the-feed-2014-03-16-kurt-cobain-day.webp'),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                    const Text('Mostly Played')
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('All Songs', style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22
            ),),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: allsongsDb.listenable(),
              builder: (context, value, child) {
                // final  List<SongDetails> homesongs = AllSongDb.values.toList();
                return ListView.separated(
                  itemCount: songall.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: ((context, index) {
                    return ListTileWidget(
                      songlist: songall,
                      tindex: index,
                      song: songall[index],
                      audioPlayer: audioPlayer,
                    );
                    // return SingleChildScrollView(
                    //   child: list(photo: 'asset/blogs-the-feed-2014-03-16-kurt-cobain-day.webp', song: Songall[index].name!,),
                    // );
                  }),
                );
              },
            ))
          ],
        ),
      ),
      bottomSheet: const MiniScreen(),
    ),
  
    );
    
  }
}

// ignore: must_be_immutable
class ListTileWidget extends StatelessWidget {
  List<SongDetails> songlist;
  int tindex;
  SongDetails song;
  final AssetsAudioPlayer audioPlayer;
  ListTileWidget({
    required this.song,
    required this.songlist,
    required this.tindex,
    super.key,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        audioPlayer.open(Playlist(audios: audioList, startIndex: tindex));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => NowPlayingScreen(
                  index: tindex,
                )));
        addMostplayedCount(song.id);
        addRecently(song.id);
      },
      leading: QueryArtworkWidget(
        id: songlist[tindex].id!,
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
      title: Text(songlist[tindex].name!),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      subtitle: Text(songlist[tindex].artist!),
      trailing: PopupMenuButton(
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        playlistDialogue(context, tindex),
                  );
                },
                child: const Text("Add to Playlist"),
              ),
            ),
            PopupMenuItem<String>(
              value: 'favorites',
              child: TextButton(
                  onPressed: () {
                    isalready(songall[tindex].id)
                        ? removeFromFavorites(songall[tindex].id!)
                        : addToFavorites(songall[tindex].id!);
                    Navigator.of(context).pop();
                  },
                  child: isalready(songall[tindex].id)
                      ? const Text('Remove from favorites')
                      : const Text('Add to favorites')),
            ),
          ];
        },
      ),
    );
  }

  playlistDialogue(BuildContext context, int songindex) {
    return AlertDialog(
      title: const Text('Add to Playlist'),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => createPlaylistTextfield(context),
              );
            },
            child: const Text('Create New Playlist'),
          ),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: ValueListenableBuilder<Box<MyPlaylistModel>>(
              valueListenable: playbox.listenable(),
              builder: (context, value, child) {
                List<MyPlaylistModel> playlistitems = playbox.values.toList();
                return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        playlistitems[index].playlistname.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                      tileColor: Colors.white,
                      focusColor: Colors.black26,
                      onTap: () {
                        Navigator.pop(context);
                        addtoPlaylist(
                          song.id!,
                          playlistitems[index].playlistname,
                          context,
                        );
                      },
                    );
                  },
                  itemCount: playlistitems.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                );
              },
            ),
          ),
        )
      ],
    );
  }

  createPlaylistTextfield(BuildContext context) {
    TextEditingController playlistcontroller = TextEditingController();
    return AlertDialog(
      title: const Text('Create Playlist'),
      actions: [
        SizedBox(
          child: TextField(
            controller: playlistcontroller,
            decoration: const InputDecoration(
              hintText: 'Playlist Name',
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              String name = playlistcontroller.text;
              createplaylist(name, context);
              Navigator.of(context).pop();
              addtoPlaylist(song.id, name, context);
            },
            child: const Text('Create'))
      ],
    );
  }
}
