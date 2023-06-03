import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:social_app/blocs/chatbloc/chat_event.dart';
import 'package:social_app/blocs/chatbloc/chat_state.dart';
import 'package:social_app/firebase/base.dart';
import 'package:social_app/repositories/repositories.dart';
import 'package:social_app/models/models.dart';
import 'package:social_app/utils/singletons/session_manager.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final Chat chat;
  final ChatRepository chatRepository;

  StreamSubscription _messageListener;

  Timer _timer;
  bool firstMessage = true;
  int counter = 0;
  List<Message> messages = [];

  ChatBloc(this.chat, this.chatRepository);

  @override
  ChatState get initialState => MessageEmpty();

  restartTimer() {
    firstMessage = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timer.tick > 10) {
        firstMessage = true;
        _timer.cancel();
      }
    });
  }

  stopTimer() {
    _timer?.cancel();
    firstMessage = true;
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is Fetch) {
      if (state == MessageEmpty()) {
        yield* fetchMessages();
      }
    } else if (event is Send) {
      yield* _mapSendToState(event);
    } else if (event is MessageReceived) {
      stopTimer();

      yield* _mapMessageReceivedToState(event);
    }
  }

  @override
  Future<void> close() {
    _messageListener?.cancel();
    _timer?.cancel();
    return super.close();
  }

  Stream<ChatState> _mapMessageReceivedToState(MessageReceived event) async* {
    if (state is MessageWaiting) {
      messages.add(event.message);
      yield MessageChanged(messages);
      yield MessageWaiting();
    } else {
      ChatState prevState = state;
      messages.add(event.message);
      yield MessageChanged(messages);
      yield prevState;
    }
  }

  Stream<ChatState> _mapSendToState(Send sendEvent) async* {
    if (state is MessageWaiting) {
      yield MessageSending();
      try {
        Message sentMessage = sendEvent.message;
        sentMessage.first = firstMessage;
        await chatRepository.sendMessage(chat.id, sentMessage);
        sentMessage.me = true;
        sentMessage.senderAvatar =
            SessionManager.getAvatarPath(SessionManager.getEmail());
        messages.add(sentMessage);

        restartTimer();

        yield MessageChanged(messages);
        yield MessageWaiting();
      } catch (e) {
        yield MessageError('Could not send message');
      }
    }
  }

  Stream<ChatState> fetchMessages() async* {
    yield MessageFetching();
    try {
      messages = await chatRepository.fetchMessages(chat.id);
      if (messages == null) {
        messages = [];
      }
      messages.forEach((message) {
        message.me = message.senderId == SessionManager.getUserID();
        !message.me
            ? message.senderAvatar = chat.avatar
            : message.senderAvatar =
                SessionManager.getAvatarPath(SessionManager.getEmail());
      });
      yield MessageChanged(messages);
      yield MessageWaiting();
    } catch (e) {
      yield MessageError('Could not fetch messages');
    }

    _messageListener = chatCollection
        .document(chat.id)
        .collection('messages')
        .snapshots()
        .listen((snapShot) {

      if(snapShot.documentChanges.length != messages.length || counter == 2) {
        Map data = snapShot.documentChanges[0].document.data;
        if(data.keys.length != 0) {
          counter++;
          Message message = Message.fromJson(data);
          if(message.senderId != SessionManager.getUserID()) {
            message.me = false;
            message.senderAvatar = chat.avatar;
            add(MessageReceived(message));
          }
        } 
      }
    });
  }
}
