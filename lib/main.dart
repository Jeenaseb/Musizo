import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/model/favouritesmodel.dart';
import 'package:musizo/model/mostlyplaylist_model.dart';
import 'package:musizo/model/playlist_model.dart';
import 'package:musizo/model/recently_model.dart';

import 'package:musizo/screens/splash.dart';





void main()async {
  WidgetsFlutterBinding.ensureInitialized();
 await Hive.initFlutter();
 if (!Hive.isAdapterRegistered(SongDetailsAdapter().typeId)) {
    Hive.registerAdapter(SongDetailsAdapter());
  }
  Hive.registerAdapter(FavoriteModelAdapter());
  Hive.registerAdapter(MyPlaylistModelAdapter());
  Hive.registerAdapter(MostPlayedAdapter());
  Hive.registerAdapter(RecentlyPlayedAdapter());
  
  
 await openAllsongsDb();
 await openFavouritesdb();
 await openplaylistDb();
 await openMostPlayed();
 await openRecentPlayed();

  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      
      title: 'Musizo',
      debugShowCheckedModeBanner: false,
      
      home:  SplashScreen(),
      
      theme: ThemeData.dark(),
    );
  }
}