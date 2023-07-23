import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musizo/functions/db_functions.dart';
import 'package:musizo/model/allsongmodel.dart';
import 'package:musizo/screens/home_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  var controller = TextEditingController();
  late List<SongDetails> dbSongs;
  late List <SongDetails> tsearchlist;
  
  

  @override
  void initState() {
    dbSongs = allsongsDb.values.toList();
    updateList('');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 34, 5, 76), 
                Colors.purple],)
            ),
            child:  Padding(padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                SingleChildScrollView(
                  
                  child: Column(
                    children: [
                      Container(
                         height: 45,
                         width: 500,
                         decoration: BoxDecoration(
                         color: const Color(0xFF918F93),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                        onChanged: (value) => updateList(value),
                        controller: controller,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF726E6E),
                            ),
                            hintText: 'Search for a song',
                            hintStyle: const TextStyle(
                              color: Color(0xFF726E6E),
                              fontSize: 17,
                            ),
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  updateList('');
                                  controller.clear();
                                },
                                icon: const Icon(Icons.clear))),
                      ),
                    ),
                  ],
                ),
                      )
                    ],
                  ),
                  ),
                 const SizedBox(
                  height: 5,
                 ),
                 Expanded(
                child: ValueListenableBuilder(
              valueListenable: allsongsDb.listenable(),
              builder: (context, value, child) {
                return   ListView.separated(
      itemCount: tsearchlist.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemBuilder: ((context, index) {
        return ListTileWidget(songlist: tsearchlist,tindex: index,song: tsearchlist[index],audioPlayer: audioPlayer,);
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
            
          ),
          
          
        //bottomSheet: MiniScreen(),  
      ),
      
    );
  }
  void updateList(String value) {
    setState(() {
      if(value.isEmpty){
        tsearchlist= List.from(dbSongs);
      }
      tsearchlist = dbSongs
          .where((element) =>
              element.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    
     });
  }
}