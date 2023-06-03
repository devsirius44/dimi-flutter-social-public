import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_bloc.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:social_app/screens/message/chat_screen/text_chat_form.dart';
import 'package:social_app/screens/room/video_chat_form.dart';
import 'package:social_app/utils/singletons/session_manager.dart';
import 'package:social_app/models/models.dart';

class ChatScreen extends StatefulWidget {
  final bool chatFlag;
  final Chat chat;
  const ChatScreen( {Key key, this.chat, this.chatFlag }) : super(key: key);
  
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  
  String email;
  bool showDropdownList = false;
  ChatRepository _chatRepository;
  
  @override
  void initState() {
    super.initState();
    
    _chatRepository = ChatRepository();
    email = SessionManager.getEmail();
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(
      create: (context) => ChatBloc(widget.chat, _chatRepository),
      child: widget.chatFlag ? TextChatForm(chat: widget.chat) :  VideoChatForm(chat: widget.chat)
    );
  }
}