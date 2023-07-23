import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:musizo/screens/now_playing.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MiniScreen extends StatelessWidget {
  const MiniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
     
    return audioPlayer.builderCurrent(builder: (context, playing) {
      
   
    return GestureDetector(
      
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NowPlayingScreen(index: 0),
          ),
        );
      },
      child: Container(
        width: height,
        height: height *0.09,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 34, 5, 76),
                  Color(0xFF521293),
                  Color(0xFF14052E)
                ])),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: QueryArtworkWidget(
                artworkHeight: height *0.05,
                artworkWidth: height *0.05,
                artworkFit: BoxFit.fill,
                id: int.parse(playing.audio.audio.metas.id!), 
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  height: height *0.06,
                  width: height *0.06,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image:  DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                              'asset/blogs-the-feed-2014-03-16-kurt-cobain-day.webp'),
                        )
                  ),
                ),
                ),
              ),
            
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Marquee(child: Text(audioPlayer.getCurrentAudioTitle),
                ),
                Marquee(
                      child: Text(
                          audioPlayer.getCurrentAudioArtist == "<unknown>"
                              ? 'Artist Not Found'
                              : audioPlayer.getCurrentAudioArtist,
                          style:
                              const TextStyle(overflow: TextOverflow.ellipsis)),
                    ),
              ],
            )),
            const SizedBox(
              width: 30,
            ),
            PlayerBuilder.isPlaying(player: audioPlayer, 
            builder: (context, isPlaying) => Wrap(
              children: [
                IconButton(onPressed: () {
                  audioPlayer.previous();
                }, icon: const Icon(Icons.skip_previous)),
                IconButton(onPressed: () {
                  audioPlayer.playOrPause();
                }, icon:  Icon((isPlaying) ? Icons.pause : Icons.play_arrow)),
                IconButton(onPressed: () {
                  audioPlayer.next();
                }, icon: const Icon(Icons.skip_next)),
              ],
            ))

            // const Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text('song'),
            //     SizedBox(
            //       height: 5,
            //     ),
            //     Text('artist'),
            //   ],
            // ),
            // const SizedBox(width: 125),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.skip_previous)),
            // IconButton(
            //   icon: const Icon(Icons.pause_circle),
            //   onPressed: () {},
            // ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.skip_next))
          ],
        ),
      ),
    );
     },);
  }
}
