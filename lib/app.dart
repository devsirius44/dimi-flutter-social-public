import 'package:flutter/material.dart';
import 'package:social_app/screens/message/message_screen.dart';
import 'package:social_app/screens/dashboard/dashboard-screen.dart';
import 'package:social_app/screens/favorite/favorite_screen.dart';
import 'package:social_app/screens/login_screen.dart';
import 'package:social_app/screens/room/room_home.dart';
import 'package:social_app/screens/search/search_screen.dart';
import 'package:social_app/screens/signup/signup_screen.dart';

class SocialApp extends StatefulWidget {
  @override
  _SocialAppState createState() => _SocialAppState();
}

class _SocialAppState extends State<SocialApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SocialApp',
      initialRoute: '/',
      theme: ThemeData(backgroundColor: Color(0xFFf5f9fa),   
       textTheme: TextTheme(
         caption: TextStyle(fontFamily: 'Trajan-Pro-Bold', fontSize: 25, fontWeight: FontWeight.bold, color: Color(0xFFf4b630)),
         title: TextStyle(fontFamily: 'PlayfairDisplay',fontSize: 32, color: Color(0xFF342e37)), 
        ), primaryColor: Color(0xFF5f5b61),
        appBarTheme: AppBarTheme(color: Color(0xFFf5f9fa), elevation: 0)
        ),
        
      routes: {
        '/': (context) => LoginScreen(),
        '/signUp': (context) => SignUpScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/loginScreen': (context) => LoginScreen(),
        '/favorite': (context) => FavoriteScreen(),
        '/messages': (context) => MessageScreen(),
        '/room': (context) => RoomHome(),
        '/search': (context) => SearchScreen(),
      }
    );
  }
}