//@dart=2.9
import 'package:ccarev2_frontend/cache/local_store.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'message.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChatModel extends Model {
  String userChatID;
  List<Message> messages = [];
  IO.Socket socket;
 
  SharedPreferences sharedPreferences;
  ILocalStore localStore;

  void init()  {
    const patientID = "61a1ea2abab826de9860f7a2";
  
    // localStore =  LocalStore(sharedPreferences);
    // var token = await localStore.fetch();
    const token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNjFhMWU5ZGNiYWI4MjZkZTk4NjBmNzkzIiwiaWF0IjoxNjM4MjY1MzkxLCJleHAiOjE2Mzg4NzAxOTEsImlzcyI6ImNvbS5jY2FyZW5pdGgifQ.K-_DprXx2ipOwWt17DODlMDqQSgtWdv8aARjlPdEuzA";
    userChatID = patientID+"-"+token;


  socket = IO.io('http://192.168.252.151:3000',
      IO.OptionBuilder()
       .setTransports(['websocket'])
       .disableAutoConnect()
       .setQuery({
         "token": token,
          "patientID": patientID
       })
       .build());
       socket.connect();
    socket.onConnect((_){
     print('connect');
    });

    socket.on("receive_message", (jsonData){
      print(jsonData);
    Map<String, dynamic> data = json.decode(jsonData);
      messages.add(Message(
          data['content'], data['senderChatID'], data['receiverChatID']));
      notifyListeners();
    });

   
  }

  void addMessages(List<Message> data){
    messages.addAll(data);
    notifyListeners();
  }

  void sendMessage(String text, String receiverChatID) {
    messages.add(Message(text, userChatID, receiverChatID));
    socket.emit("send_message", [
      {
        "content": text,
        "senderChatID": userChatID,
        "receiverChatID": receiverChatID
      }
    ]);
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    return messages
        .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
        .toList();
  }
}