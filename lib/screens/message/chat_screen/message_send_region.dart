import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_event.dart';
import 'package:social_app/blocs/chatbloc/chat_state.dart';
import 'package:social_app/models/message.dart';
import 'package:social_app/utils/singletons/global.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class MessageSendRegion extends StatefulWidget {
  
  final ValueChanged<String> onSend;
  
  const MessageSendRegion({Key key, this.onSend}) : super(key: key);
  @override
  _MessageSendRegionState createState() => _MessageSendRegionState();
}

class _MessageSendRegionState extends State<MessageSendRegion> {
  String hintText = 'Type a message';
  String email;  
  TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    
    _controller = TextEditingController(text: '');
    email = SessionManager.getEmail();
  }
  
  onSend(ChatBloc chatBloc) {
    
    if(_controller.text.isEmpty) {
      Global.showToastMessage('Please input message');
      return;
    }
    
    Message message = Message(SessionManager.getUserID(), 'text', _controller.text);
    chatBloc.add(Send(message));
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if(state is MessageError) {
          Global.showToastMessage(state.errorMsg);
        }
        return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Container(
          color: Color(0xffe3e2e4),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Row(
                  children: <Widget>[
                    Image.file(File(SessionManager.getAvatarPath(email)), width: 34, fit: BoxFit.fitWidth),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Container(                        
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0
                          ),          
                        ),
                        height: 40,
                        child: TextFormField(                      
                          controller: _controller,                          
                          decoration: InputDecoration(                            
                            border: InputBorder.none,
                            hintText: hintText,
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5)
                          ),
                          
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    if(state is MessageSending)  return;
                    onSend(BlocProvider.of<ChatBloc>(context));
                    _controller.text = '';
                  });
                },
                child: Container(
                  width: 315, 
                  height: 40,
                  color: Color(0xff423547),
                  child: Center(
                    child: state is MessageSending 
                    ? CircularProgressIndicator(backgroundColor: Colors.white)
                    : Text('SEND', style: TextStyle(color: Colors.white, fontFamily: 'Lato-Rregular', fontSize: 13)
                  ),
                ),
              ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
      }
    );
  }
}