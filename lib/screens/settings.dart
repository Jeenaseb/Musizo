import 'package:flutter/material.dart';
import 'package:musizo/screens/about_us.dart';
import 'package:musizo/screens/privacy_policy.dart';
import 'package:musizo/screens/terms_conditions.dart';

class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _SettingsState();
}

class _SettingsState extends State<ScreenSetting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  
                  colors: [
                Color.fromARGB(255, 34, 5, 76),
                Colors.purple,
                Color(0xFF14052E)
              ])),
          child: ListView(
            children: [
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const PrivacyPolicyScreen()));
                    },
                    icon: const Icon(Icons.privacy_tip_outlined)),
              ),
              ListTile(
                title: const Text(
                  'Share App',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.share_rounded)),
              ),
              ListTile(
                title: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 20),
                ),
                trailing: IconButton(onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AboutUsScreen(),));
                }, icon: const Icon(Icons.info_outlined)),
              ),
               ListTile(
                title: const Text('Terms & Conditions', 
                style: TextStyle(fontSize: 20),),
                trailing: IconButton(onPressed: (){
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => const TermsScreen(),));
                }, icon: const Icon(Icons.arrow_forward_ios)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
