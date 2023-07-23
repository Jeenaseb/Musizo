import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:musizo/screens/home_screen.dart';
import 'package:musizo/screens/playlist.dart';
import 'package:musizo/screens/search.dart';


class BottomNavigation extends StatelessWidget {
   BottomNavigation({super.key});
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.white,
      body: PageView(
        
     
        controller: _pageController,
        children:  const <Widget> [
           HomeScreen(),
           SearchScreen(),
           PlaylistScreen()
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor:const Color.fromARGB(56, 94, 7, 85),
        height: 65,

        items: const <Widget>[
          Icon(
              Icons.home,
              size: 35,
              color: Colors.red,
            ),
            Icon(
              Icons.search,
              size: 35,
              color: Colors.deepPurpleAccent,
            ),
            Icon(
              Icons.playlist_add,
              size: 35,
              color: Colors.green,
            ),
            
        ],
        onTap: (index) {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut);
          },
        ),
    );
  }
}


