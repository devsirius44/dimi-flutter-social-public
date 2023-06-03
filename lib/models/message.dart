import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  
  String id;
  String senderAvatar;
  String senderId;
  String messageType;
  String message;
  bool isRead;
  bool first;
  bool me;
  Timestamp timeStamp;
  
  Message(this.senderId, this.messageType, this.message, {this.isRead = false});
  
  Map<String, dynamic> toMap() => {
    'id': id,
    'sender_id' : senderId,
    'message_type': messageType,
    'message': message,
    'is_read': isRead,
    'first': first,
    // 'timestamp': Timestamp.now()
    'timestamp': FieldValue.serverTimestamp()
  };
  
  Message._internalFromJson(Map jsonMap) {
    first = jsonMap['first'] as bool;
    id = jsonMap['id'] as String;  
    senderId = jsonMap['sender_id'] as String;
    messageType = jsonMap['message_type'] as String;
    message = jsonMap['message'] as String;
    isRead = jsonMap['is_read'];
  }
  factory Message.fromJson(Map jsonMap) => Message._internalFromJson(jsonMap);
}