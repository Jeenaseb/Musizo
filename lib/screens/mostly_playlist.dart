import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/functions/favoritefunctions.dart';
import 'package:musizo/functions/playlist_functions.dart';
import 'package:musizo/model/mostlyplaylist_model.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:musizo/widget/player_function.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayedScreen extends StatefulWidget {
  MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedState();
}

final box = MostPlayedBox.getInstance();
final List<Audio> songs = [];
final List<MostPlayed> mostfinalsongs = [];
var size, height, width;

class _MostlyPlayedState extends State<MostlyPlayedScreen> {
  @override
  void initState() {
    List<MostPlayed> songlist = box.values.toList();

    for (var element in songlist) {
      for (int i = 0; i < mostfinalsongs.length; i++) {
        if (mostfinalsongs[i].songname == element.songname)
          mostfinalsongs.removeAt(i);
      }
      if (element.count > 3) {
        mostfinalsongs.insert(0, element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Most Play'),
        ),
        body: Container(
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 34, 5, 76), Colors.purple],
            ),
          ),
          child: Column(children: [
            Expanded(
              child: ValueListenableBuilder<Box<MostPlayed>>(
                  valueListenable: box.listenable(),
                  builder: (context, value, child) {
                    return mostfinalsongs.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            itemBuilder: (context, index) => MostPlayedList(
                                song: mostfinalsongs[index],
                                songlist: mostfinalsongs,
                                index: index),
                            itemCount: mostfinalsongs.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              );
                            },
                          )
                        : const Center(
                            child: Text(
                              "Your most played songs will appear here!`",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}

class MostPlayedList extends StatelessWidget {
  MostPlayedList(
      {required this.song,
      required this.songlist,
      this.color,
      required this.index,
      super.key});

  final MostPlayed song;
  final List<MostPlayed> songlist;
  final Color? color;
  final int index;

  final playbox = MyPlaylistSongsBox.getInstance();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color ?? Colors.black,
      onTap: () {
        audioPlayer.stop();
        audioList.clear();
        for (MostPlayed item in songlist) {
          audioList.add(Audio.file(item.songurl!,
              metas: Metas(
                  title: item.songname,
                  artist: item.artist,
                  id: item.id.toString())));
        }
        playingaudio(context, index);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: QueryArtworkWidget(
        id: song.id!,
        size: 3000,
        artworkFit: BoxFit.cover,
        type: ArtworkType.AUDIO,
        artworkBorder: BorderRadius.circular(10),
        artworkQuality: FilterQuality.high,
        nullArtworkWidget: const Image(
          width: 50,
          height: 50,
          image: AssetImage(
            'asset/Musizo-1.png',
          ),
        ),
      ),
      title: Marquee(
        child: Text(
          song.songname!,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      subtitle: Marquee(
          child: Text(
        song.artist.toString(),
        style: TextStyle(color: Colors.white),
      )),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                isalready(song.id!)
                    ? removeFromFavorites(song.id!)
                    : addToFavorites(song.id!);
                Navigator.of(context).pop();
              },
              child: Text(isalready(song.id!)
                  ? 'Remove from Favorites'
                  : 'Add to favorites'),
            ),
          ),
          PopupMenuItem(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => playlistDialogue(context, index),
                );
              },
              child: Text('Add to Playlist'),
            ),
          )
        ],
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
              child: Text('Create new playlist')),
        ),
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: ValueListenableBuilder<Box<MyPlaylistModel>>(
              valueListenable: playbox.listenable(),
              builder: (context, value, child) {
                List<MyPlaylistModel> playlistitems =
                    playlistDb.values.toList();
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          playlistitems[index].playlistname.toString(),
                          textAlign: TextAlign.center,
                        ),
                        tileColor: Colors.black,
                        onTap: () {
                          Navigator.of(context).pop();
                          addtoPlaylist(song.id,
                              playlistitems[index].playlistname, context);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                    itemCount: playlistitems.length);
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
                hintText: 'Playlist Name', border: InputBorder.none),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              String name = playlistcontroller.text;
              createplaylist(name, context);
              Navigator.of(context).pop();
            },
            child: const Text('Create'))
      ],
    );
  }
}
