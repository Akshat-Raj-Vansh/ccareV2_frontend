//@dart=2.9
import 'package:ccarev2_frontend/cache/local_store.dart';
import 'package:ccarev2_frontend/user/domain/token.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'message.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatModel extends Model {
  String userChatID;
  List<Message> messages = [];
  IO.Socket socket;

  SharedPreferences sharedPreferences;
  ILocalStore localStore;

  void init(String patientID, String token) {
    userChatID = patientID + "-" + token;

    socket = IO.io(
        BASEURL,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({"token": token, "patientID": patientID})
            .build());
    socket.connect();
    socket.onConnect((_) {
      //print('connect');
    });
    socket.onConnectError((err) {
      //print(err);
    });

    socket.on("receive_message", (jsonData) {
      //print(jsonEncode(jsonData));
      //print(jsonEncode(jsonData['content']));
      Map<String, dynamic> data = jsonDecode(jsonEncode(jsonData));
      messages.add(Message(data['content'], data['senderChatID'],
          data['receiverChatID'], data['type'], data['time'],
          path: data["type"] == "IMAGE" ? data['path'] : ""));
      notifyListeners();
    });
  }

  void addMessages(List<Message> data) {
    //print('777777777777777777');
    //print(data.last);
    messages.addAll(data);
    //print('888888888888888888');
    print(messages.last);

    notifyListeners();
  }

  void closeChat() {
    socket.close();
  }

  void sendMessage(String text, String receiverChatID, String type,
      {String path}) {
    messages.add(Message(
        text, userChatID, receiverChatID, type, DateTime.now().toString(),
        path: type == "IMAGE" ? path : ""));
    //print("UserChatID$userChatID");
    socket.emit("send_message", [
      {
        "content": text,
        "senderChatID": userChatID,
        "receiverChatID": receiverChatID,
        "type": type,
        "time": DateTime.now().toString(),
        "path": type == "IMAGE" ? path : ""
      }
    ]);
    notifyListeners();
  }

  List<Message> getMessagesForChatID(String chatID) {
    //print(messages
    // .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
    // .toList());
    print(messages.length);
    return messages;
    // return messages
    //     .where((msg) => msg.senderID == chatID || msg.receiverID == chatID)
    //     .toList();
  }
}
