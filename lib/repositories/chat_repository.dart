import 'dart:async';

import 'package:social_app/firebase/base.dart';
import 'package:social_app/models/models.dart';
import 'package:social_app/utils/helpers/date_helper.dart';

class ChatRepository {
  /// Get Full Chat Info from FireStore Chat Collection Document
  /// chatJsonMap : Conent of Chats Collection Document in Firestore

  Future<Chat> getFullChatInfo(Map chatJsonMap, String myID) async {
    try {      
      Chat chat = Chat();
      chat.id = chatJsonMap['id'];
      
      /// Get OpponentID
      var memberIds = chatJsonMap['memberIds'];
      String opponentID = memberIds.firstWhere((item) => item != myID);
      
      /// Get Opponent Name
      var opponentDocumentSnapshot =
          await userTbl.where('id', isEqualTo: opponentID).getDocuments();
      UserTbl user = UserTbl.fromJson(opponentDocumentSnapshot.documents[0].data);
      chat.title = user.email;
      chat.opponentName = user.email;
      
      /// Get Opponent Avatar
      var opponentBasicInfo = 
          await basicInfo.where('id', isEqualTo: opponentID).getDocuments();
      if (opponentBasicInfo.documents.length > 0) {
        chat.avatar = opponentBasicInfo.documents.first.data['dashphotourl'];
        chat.opponentAvatar = opponentBasicInfo.documents.first.data['dashphotourl'];
        chat.opponentLocation = opponentBasicInfo.documents.first.data['curlocation']; 

        String dob = opponentBasicInfo.documents.first.data['birthday'];
        DateTime birthday = parseDateTime(dob, 'MM-dd-yyyy');
        chat.opponentAge = DateTime.now().difference(birthday).inDays % 365;
      } else {
        chat.avatar = null;
      }
      
      /// Get Last Sent Message
      String messageID = chatJsonMap['last_message_id'];
      if (messageID != null) {
        var messageSnapShot = await chatCollection
            .document(chat.id)
            .collection('messages')
            .document(messageID)
            .get();
        Message message = Message.fromJson(messageSnapShot.data);
        chat.lastSentMessage = message;
      }
      return chat;
    } catch (e) {
      return null;
    }
  }

  Future<Chat> getSearchFullChatInfo(Map chatJsonMap, String myID, String srchName) async {
    try {      
      Chat chat = Chat();
      chat.id = chatJsonMap['id'];
      
      /// Get OpponentID
      var memberIds = chatJsonMap['memberIds'];
      String opponentID = memberIds.firstWhere((item) => item != myID);
      
      /// Get Opponent Name
      var opponentDocumentSnapshot =
          await userTbl.where('id', isEqualTo: opponentID).getDocuments();
      UserTbl user = UserTbl.fromJson(opponentDocumentSnapshot.documents[0].data);
      String email = user.email;

      if(!email.contains(srchName)) return null; 
      
      chat.title = email;
      chat.opponentName = email;
      
      /// Get Opponent Avatar
      var opponentBasicInfo = 
          await basicInfo.where('id', isEqualTo: opponentID).getDocuments();
      if (opponentBasicInfo.documents.length > 0) {
        chat.avatar = opponentBasicInfo.documents.first.data['dashphotourl'];
        chat.opponentAvatar = opponentBasicInfo.documents.first.data['dashphotourl'];
        chat.opponentLocation = opponentBasicInfo.documents.first.data['curlocation']; 

        String dob = opponentBasicInfo.documents.first.data['birthday'];
        DateTime birthday = parseDateTime(dob, 'MM-dd-yyyy');
        chat.opponentAge = DateTime.now().difference(birthday).inDays % 365;
      } else {
        chat.avatar = null;
      }
      
      /// Get Last Sent Message
      String messageID = chatJsonMap['last_message_id'];
      if (messageID != null) {
        var messageSnapShot = await chatCollection
            .document(chat.id)
            .collection('messages')
            .document(messageID)
            .get();
        Message message = Message.fromJson(messageSnapShot.data);
        chat.lastSentMessage = message;
      }
      return chat;
    } catch (e) {
      return null;
    }
  }

  /// If There is no chat that include me and opponent, create one, and if exists return that chat
  /// myID : my Firebase ID, opponentID: Opponent's Firebase ID
  
  Future<Chat> getPrivateChat(String myID, String opponentID) async {
    try {
      var myInfoDocumentSnapshot =
          await userTbl.where('id', isEqualTo: myID).getDocuments();
      var chatIds = myInfoDocumentSnapshot.documents[0].data['chats'] ?? [];

      if (chatIds.isNotEmpty) {
        /// If document exists
        for (int i = 0; i < chatIds.length; i++) {
          var chatDocument = await chatCollection.document(chatIds[i]).get();
          var memberIds = chatDocument.data['memberIds'];
          if (memberIds.contains(opponentID)) {
            Map chatJsonMap = chatDocument.data;
            return getFullChatInfo(chatJsonMap, myID);
          }
        }
        List<String> memberIds = [myID, opponentID];
        var document = await chatCollection.add({});
        String chatID = document.documentID;
        Map<String, dynamic> chatMapJson = {
          'memberIds': memberIds,
          'id': chatID,
        };
        await chatCollection.document(chatID).updateData(chatMapJson);
       
        // for myID
        var documentSnapshot =
            await userTbl.where('id', isEqualTo: myID).limit(1).getDocuments();
        var myInfo = documentSnapshot.documents[0];
        var chatList = myInfo.data['chats'] as List ?? [];
        var _chatList = [];

        if (chatList.isEmpty) {
          _chatList = [chatID];
        } else {
          for (int i = 0; i < chatList.length; i++) {
            if(chatID != chatList[i])                  // debug for duplicating chat ids
              _chatList.add(chatList[i]);
          }
          _chatList.add(chatID);
        }
        await userTbl
            .document(myInfo.documentID)
            .updateData({'chats': _chatList});

        // for opponentID
        documentSnapshot = await userTbl
            .where('id', isEqualTo: opponentID)
            .limit(1)
            .getDocuments();
        var opponentInfo = documentSnapshot.documents[0];
        chatList = opponentInfo.data['chats'] as List ?? [];
        if (chatList.isEmpty) {
          _chatList = [chatID];
        } else {
          // chatList.map((chat) {
          //   _chatList.add(chat);
          // });
          for (int i = 0; i < chatList.length; i++) {
            if(chatID != chatList[i])                  // debug for duplicating chat ids
              _chatList.add(chatList[i]);
          }
          _chatList.add(chatID);
        }

        await userTbl
            .document(opponentInfo.documentID)
            .updateData({'chats': _chatList});
        return getFullChatInfo(chatMapJson, myID);

      } else {
        /// Else if document does not exist
        List<String> memberIds = [myID, opponentID];
        var document = await chatCollection.add({});
        String chatID = document.documentID;
        Map<String, dynamic> chatMapJson = {
          'memberIds': memberIds,
          'id': chatID,
        };
        await chatCollection.document(chatID).updateData(chatMapJson);

        var documentSnapshot =
            await userTbl.where('id', isEqualTo: myID).limit(1).getDocuments();
        var myInfo = documentSnapshot.documents[0];
        var chatList = myInfo.data['chats'] as List ?? [];
        var _chatList = [];

        if (chatList.isEmpty) {
          _chatList = [chatID];
        } else {
          // chatList.map((chat) {
          //   _chatList.add(chat);
          // });
          for (int i = 0; i < chatList.length; i++) {
            if(chatID != chatList[i])                  // debug for duplicating chat ids
              _chatList.add(chatList[i]);
          }
          _chatList.add(chatID);
        }

        await userTbl
            .document(myInfo.documentID)
            .updateData({'chats': _chatList});
         
        documentSnapshot = await userTbl
            .where('id', isEqualTo: opponentID)
            .limit(1)
            .getDocuments();
        var opponentInfo = documentSnapshot.documents[0];
        chatList = opponentInfo.data['chats'] as List ?? [];
        if (chatList.isEmpty) {
          _chatList = [chatID];
        } else {
          // chatList.map((chat) {
          //   _chatList.add(chat);
          // });
          for (int i = 0; i < chatList.length; i++) {
            if(chatID != chatList[i])                  // debug for duplicating chat ids
              _chatList.add(chatList[i]);
          }
         _chatList.add(chatID);
        }

        await userTbl
            .document(opponentInfo.documentID)
            .updateData({'chats': _chatList});
        return getFullChatInfo(chatMapJson, myID);
      }
    } catch (e) {
      return null;
    }
  }
  
  /// Get All Chats That Include Me using My Firebase ID
  /// myID: my firebase id
  Future<List<Chat>> getAllChats(String myID) async {
    try {
      var myInfoSnapshot =
          await userTbl.where('id', isEqualTo: myID).getDocuments();
      var chatIds = myInfoSnapshot.documents[0].data['chats'] ?? [];
      if (chatIds.length > 0) {
        List<Chat> chatList = [];
        for (int i = 0; i < chatIds.length; i++) {
          var chatSnapshot = await chatCollection.document(chatIds[i]).get();
          Chat chat = await getFullChatInfo(chatSnapshot.data, myID);
          chatList.add(chat);
        }
        return chatList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Get All with 'srchName' among Chats That Include Me using My Firebase ID
  /// myID: my firebase id
  Future<List<Chat>> getSearchAllChats(String myID, String srchName) async {
    try {
      var myInfoSnapshot =
          await userTbl.where('id', isEqualTo: myID).getDocuments();
      var chatIds = myInfoSnapshot.documents[0].data['chats'] ?? [];
      if (chatIds.length > 0) {
        List<Chat> chatList = [];
        for (int i = 0; i < chatIds.length; i++) {
          var chatSnapshot = await chatCollection.document(chatIds[i]).get();
          //Chat chat = await getFullChatInfo(chatSnapshot.data, myID);
          Chat chat = await getSearchFullChatInfo(chatSnapshot.data, myID, srchName);
          if(chat != null)
            chatList.add(chat);
        }
        return chatList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Send Message
  Future<bool> sendMessage(String chatID, Message message) async {
    try {
      var documentSnapshot =
          await chatCollection.document(chatID).collection('messages').add({});
      String id = documentSnapshot.documentID;
      message.id = id;
      await chatCollection
          .document(chatID)
          .collection('messages')
          .document(id)
          .updateData(message.toMap());
      await chatCollection.document(chatID).updateData({'last_message_id': id});
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mark As Read
  Future<bool> markAsRead(String chatID, String myID) async {
    try {
      var documentSnapshot = await chatCollection
          .document(chatID)
          .collection('messages')
          .where('is_read', isEqualTo: false)
          .getDocuments();
      if (documentSnapshot.documents.length > 0) {
        for (int i = 0; i < documentSnapshot.documents.length; i++) {
          if (documentSnapshot.documents[i].data['sender_id'] != myID) {
            await chatCollection
                .document(chatID)
                .collection('messages')
                .document(documentSnapshot.documents[i].documentID)
                .updateData({'is_read': true});
          }
        }
        return true;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  /// Fetch Messages
  Future<List<Message>> fetchMessages(String chatID) async {
    try {
      var documentSnapshot = await chatCollection
          .document(chatID)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .getDocuments();
      if (documentSnapshot.documents.length > 0) {
        List<Message> messageList = [];
        for (int i = 0; i < documentSnapshot.documents.length; i++) {
          Message message =
              Message.fromJson(documentSnapshot.documents[i].data);
          messageList.add(message);
        }
        return messageList;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
