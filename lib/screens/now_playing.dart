


import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:musizo/functions/favoritefunctions.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../functions/playlist_functions.dart';
import '../model/playlist_model.dart';
// AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key,required this.index});
final int index;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  Widget build(BuildContext context) {
    return audioPlayer.builderCurrent(builder: (context, playing) =>  Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        
        children: [
          QueryArtworkWidget(
            artworkHeight: MediaQuery.sizeOf(context).height/1.7,
            artworkWidth: MediaQuery.sizeOf(context).width,
            artworkFit: BoxFit.cover,
            id: int.parse(playing.audio.audio.metas.id!), 
          type: ArtworkType.AUDIO,
          artworkQuality: FilterQuality.high,
          size: 2000,
          nullArtworkWidget: Container(
                width: MediaQuery.sizeOf(context).width * 0.134,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // image: DecorationImage(
                  //     fit: BoxFit.cover,
                  //     image: AssetImage(
                  //         'assets/images/pulse-music-low-resolution-color-logo.png')
                  //         ),
                ),
                //child: Icon(Icons.abc),
              ),
          
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.5),
                        const Color(0xFF31314F).withOpacity(1),
                        const Color(0xFF31314F).withOpacity(1)
                ]        
                )
            ),
             child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                       Column(
                         children: [
                           InkWell(
                                child:  Icon(
                              Icons.favorite,
                              color: isalready(songall[widget.index].id!) ?  Colors.red : Colors.white,
                              size: 30,
                            ),
                    
                            onTap: () {
                              setState(() {
                               isalready(songall[widget.index].id!) 
                               ? removeFromFavorites(songall[widget.index].id!) : addToFavorites(songall[widget.index].id!,);
                              });
                            },
                      ),
                      IconButton(onPressed: () {
                               showDialog(
                context: context,
                builder: (BuildContext context) =>
                    playlistDialogue(context,widget.index ),
              );
                      }, icon: const Icon(Icons.playlist_add, size: 45,))
                         ],
                       )
                    ],
                  ),
                  ),
                  const Spacer(),
                  
                   SizedBox(
                      height: MediaQuery.of(context).size.height/2.5,
                  
                      child:  Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 20),
                          child: Column(
                            children: [
                              Marquee(
                                child: Text(audioPlayer.getCurrentAudioTitle, style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 24,fontWeight: FontWeight.bold
                                ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Marquee(
                                child: Text(audioPlayer.getCurrentAudioArtist, 
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 18,
                                  
                                ),
                                ),
                              ),
                            ],
                          ),
                          ),
                          Column(
                            children: [

                                 SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: PlayerBuilder.realtimePlayingInfos(
                              player: audioPlayer,
                              builder: (context, realtimePlayingInfos) {
                                final duration = realtimePlayingInfos
                                    .current!.audio.duration;
                                final position =
                                    realtimePlayingInfos.currentPosition;
                                return ProgressBar(
                                  progress: position,
                                  total: duration,
                                  progressBarColor: Colors.white,
                                  baseBarColor: Colors.white.withOpacity(0.5),
                                  thumbColor: Colors.red,
                                  barHeight: 3.0,
                                  thumbRadius: 7.0,
                                  timeLabelTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  onSeek: (duration) {
                                    audioPlayer.seek(duration);
                                  },
                                );
                              },
                            ),
                          ),

                              // Slider(
                              //   min: 0,
                              //   max: 100,
                              //   value: 40, 
                              //   onChanged: (value){
                  
                              // },
                              // activeColor: Colors.white,
                              // inactiveColor: Colors.white54,
                              // ),
                          
                            ],
                          ),
                          const SizedBox(height: 30,),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 35,
                                  onPressed: playing.index == 0
                                      ? () {}
                                      : () async {
                                          await audioPlayer.previous();
                                          if (!isPlaying) {
                                            audioPlayer.pause();
                                            // setState(() {});
                                          }
                                        },
                                  icon: playing.index == 0
                                      ? Icon(
                                          Icons.skip_previous,
                                          color: Colors.white.withOpacity(0.4),
                                          size: 35,
                                        )
                                      : const Icon(
                                          Icons.skip_previous,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                );
                              }),
                          
                              // IconButton(onPressed: (){}, 
                              // icon: const Icon(Icons.skip_previous,size: 30,),
                              // ),
                                IconButton(
                            iconSize: 35,
                            onPressed: () async {
                              audioPlayer.seekBy(const Duration(seconds: -10));
                            },
                            icon: const Icon(Icons.replay_10,
                                color: Colors.white, size: 35),
                          ),

                            //  IconButton(onPressed: (){}, 
                            //  icon: const Icon(Icons.play_arrow,size: 30,)),
                              PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 55,
                                  onPressed: () {
                                    audioPlayer.playOrPause();
                                  },
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle
                                        : Icons.play_circle,
                                    // color: Colors.red,
                                    size: 55,
                                  ),
                                );
                              }),
                                  IconButton(
                            iconSize: 35,
                            onPressed: () async {
                              audioPlayer.seekBy(const Duration(seconds: 10));
                            },
                            icon: const Icon(Icons.forward_10,
                                color: Colors.white, size: 35),
                          ),

                            //  IconButton(onPressed: () {
                               
                            //  }, 
                            //  icon: const Icon(Icons.skip_next,size: 30,))
                             PlayerBuilder.isPlaying(
                              player: audioPlayer,
                              builder: (context, isPlaying) {
                                return IconButton(
                                  iconSize: 35,
                                  onPressed: () {
                              
                               audioPlayer.next();
                                  },
                          
                                  icon: const Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                  ),
                                );
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                  
                ],
              ),
             ),
          ),
        ],
      ),
    )
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
                          songall[widget.index].id!,
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
              addtoPlaylist(songall[widget.index].id!, name, context);
            },
            child: const Text('Create'))
      ],
    );
  }
}