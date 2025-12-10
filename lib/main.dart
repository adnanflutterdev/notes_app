import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notes/home_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {

  
  WidgetsFlutterBinding.ensureInitialized();

  final path = await getApplicationDocumentsDirectory();
  Hive.init(path.path);

  print(path.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const HomeScreen(),
    );
  }
}
