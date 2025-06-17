import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:libby_guild/common/local_storage.dart';
import 'package:libby_guild/res/strings.dart';
import 'package:libby_guild/ui/page/home_page.dart';
import 'package:libby_guild/vm/home_page.dart';

import 'firebase/firebase_cloud_messing.dart';

final MyLocalStorage localStorage = MyLocalStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localStorage.initialize();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyC6gLODirru5Rb9oNSeArZJll9SG_pRjjg",
        authDomain: "ribbyguild.firebaseapp.com",
        projectId: "ribbyguild",
        storageBucket: "ribbyguild.firebasestorage.app",
        messagingSenderId: "93104993339",
        appId: "1:93104993339:web:48f5dd15a23afc99e5181e",
        measurementId: "G-Q62JTBFCE0",
        databaseURL: "https://ribbyguild-default-rtdb.firebaseio.com"),
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await setupFlutterNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ko', 'KR'),
          Locale('en', 'US'),
        ],
        home: const HomePage(),
      ),
    );
  }
}
