import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pyramidion_two/controller/provider/provider.dart';
import 'package:pyramidion_two/firebase_options.dart';
import 'package:pyramidion_two/view/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ListenableProvider(create: (context) => ProviderClass())],
      builder: (context, child) => MaterialApp(
        title: 'PYRAMIDION',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: BottomNav(),
      ),
    );
  }
}
