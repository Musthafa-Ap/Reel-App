import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reel_app/bloc/reel_bloc/reel_bloc.dart';
import 'package:reel_app/bloc/upload_bloc/upload_bloc.dart';
import 'package:reel_app/reel_screen/reel_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ReelBloc(),
          ),
          BlocProvider(
            create: (context) => UploadBloc(),
          )
        ],
        child: MaterialApp(
            title: 'Reel App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: const ReelScreen()));
  }
}
