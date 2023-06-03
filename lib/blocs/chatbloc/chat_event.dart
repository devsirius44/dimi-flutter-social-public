import 'package:equatable/equatable.dart';
import 'package:social_app/models/models.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => null;
}

class Fetch extends ChatEvent {}

class Send extends ChatEvent {
  final Message message;

  Send(this.message);
}

class MessageReceived extends ChatEvent {
  
  final Message message;
  
  MessageReceived(this.message);
}

class MarkRead extends ChatEvent {
  final String chatID;

  MarkRead(this.chatID);
}