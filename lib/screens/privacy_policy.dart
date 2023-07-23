import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: Future.delayed(const Duration(microseconds: 150)).then(
                (value) => rootBundle.loadString('asset/privacy_policy.md')),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Markdown(
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      ThemeData(
                        textTheme: const TextTheme(
                          bodyMedium: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 15.0,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    data: snapshot.data!);
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ))
        ],
      ),
    );
  }
}
