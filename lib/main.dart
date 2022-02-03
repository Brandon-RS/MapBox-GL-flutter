import 'package:flutter/material.dart';
import 'package:map_gl/src/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MapBox GL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: FullScreenMap.routeName,
      routes: {
        FullScreenMap.routeName: (_) => const FullScreenMap(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
