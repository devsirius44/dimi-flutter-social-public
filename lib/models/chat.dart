import 'package:social_app/models/models.dart';

class Chat {
  String id;
  String avatar;
  String title;
  Message lastSentMessage;


  /// Opponent Information
  String opponentName;
  String opponentAvatar;
  int opponentAge;
  String opponentLocation;
}