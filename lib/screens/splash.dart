import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/model/mostlyplaylist_model.dart';

import 'package:musizo/widget/bottom.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     SongFetch fetch = SongFetch();
//     fetch.fetching();
//     // TODO: implement initState
//     super.initState();

//     Timer(const Duration(seconds: 2), () {
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => BottomNavigation(),
//       ));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//         body: Center(
//       child: Text(
//         'Musizo',
//         style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
//       ),
//     ));
//   }
// }

// class SongFetch {
//   final OnAudioQuery audioQuery = OnAudioQuery();
//   permissionRequest() async {
//     PermissionStatus status = await Permission.storage.request();
//     if (status.isGranted) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   fetching() async {
//     bool status = await permissionRequest();
//     if (status) {
//       List<SongModel> fetchsong = await audioQuery.querySongs(
//           ignoreCase: true,
//           orderType: OrderType.ASC_OR_SMALLER,
//           sortType: null,
//           uriType: UriType.EXTERNAL);

//       for (var element in fetchsong) {
//         if (element.fileExtension == "mp3" &&
//             allsongsDb.values.where((data) => data.id == element.id).isEmpty) {
//           await allsongsDb.put(
//               element.id,
//               SongDetails(
//                   name: element.displayNameWOExt,
//                   artist: element.artist,
//                   duration: element.duration,
//                   id: element.id,
//                   songUrl: element.uri));
//           mostplayedDb.put(
//               element.id,
//               MostPlayed(
//                   songname: element.displayNameWOExt,
//                   artist: element.artist,
//                   duration: element.duration,
//                   songurl: element.uri,
//                   count: 0,
//                   id: element.id));
//         }
//       }
//     }
//   }
// }

final box = AllsongsBox.getInstance();
final audioQuery = OnAudioQuery();

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirstOpen = false; // Flag to indicate if it's the first app open

  @override
  void initState() {
    super.initState();
    checkFirstOpen();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text(
        'Musizo',
        style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
      ),
    ));
  }

  Future<void> checkFirstOpen() async {
    PermissionStatus status = await Permission.storage.status;
    isFirstOpen = status.isGranted;

    if (!isFirstOpen) {
      await requestStoragePermission();
      await addSongsToDatabase();
      goToMyApp();
    } else {
      goToMyApp();
      
    }
  }

  Future<void> requestStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      addSongsToDatabase();
      goToMyApp();
    } else {
      // Permission denied
    }
  }

  Future<void> addSongsToDatabase() async {
    List<SongModel> fetchedSongs = await audioQuery.querySongs();
    List<SongDetails> songsToAdd = [];

    for (var element in fetchedSongs) {
      if (element.fileExtension == 'mp3') {
        songsToAdd.add(
          SongDetails(
            name: element.title,
            artist: element.artist,
            duration: element.duration,
            songUrl: element.uri,
            id: element.id,
          ),
        );
        for (var element in songsToAdd) {
          box.put(
              element.id,
              SongDetails(
                  name: element.name,
                  artist: element.artist,
                  duration: element.duration,
                  songUrl: element.songUrl,
                  id: element.id));

          mostplayedDb.put(
              element.id,
              MostPlayed(
                  songname: element.name,
                  artist: element.artist,
                  duration: element.duration,
                  songurl: element.songUrl,
                  count: 0,
                  id: element.id));

    
        }
      }
    }
  }

  Future<void> goToMyApp() async {
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) =>  BottomNavigation()),
    );
  }
}
