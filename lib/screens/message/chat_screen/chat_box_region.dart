import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_state.dart';
import 'package:social_app/screens/message/chat_screen/left_message_item.dart';
import 'package:social_app/screens/message/chat_screen/right_message_item.dart';
import 'package:social_app/screens/common_widget/loading_indicator.dart';

class ChatBoxRegion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      condition: (prevState, state) {
        return (prevState.runtimeType != state.runtimeType) && (state is MessageChanged || state is MessageFetching);
      },
      builder: (context, state) {
        if(state is MessageFetching) {
          return LoadingIndicator();
        } else if(state is MessageChanged) {
           return Column(
            children: List.generate(state.messages.length, (int index) {
              return state.messages[index].me ? RightMessageItem(message: state.messages[index]) : LeftMessageItem(message: state.messages[index]);
            })
          );
        } else {
          return Text('Unimplemented State');
        }
    });
  }
}