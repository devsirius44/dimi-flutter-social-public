import 'package:equatable/equatable.dart';
import 'package:social_app/models/models.dart';

abstract class ChatState extends Equatable {
  
  const ChatState();
  
  @override
  List<Object> get props => [];
}

class MessageEmpty extends ChatState {}
class MessageFetching extends ChatState {}
class MessageWaiting extends ChatState {}
class MessageSending extends ChatState {}
class MessageError extends ChatState {

  final String errorMsg;

  MessageError(this.errorMsg);
}
class MessageChanged extends ChatState {

  final List<Message> messages;

  MessageChanged(this.messages);
}