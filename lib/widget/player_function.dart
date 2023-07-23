import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:musizo/screens/home_screen.dart';

import '../screens/now_playing.dart';

playingaudio(context, int index) async {
  await audioPlayer
      .open(
        Playlist(audios:audioList , startIndex: index),loopMode: LoopMode.playlist,showNotification: true);
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) =>  const NowPlayingScreen(index: 0)));
}