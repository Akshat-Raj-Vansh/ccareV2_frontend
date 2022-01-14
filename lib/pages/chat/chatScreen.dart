import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/components/chatModel.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:scoped_model/scoped_model.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

import 'components/message.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String recieverID;
  final String patientID;
  final String token;
  ChatPage(this.name, this.recieverID, this.patientID, this.token);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  late String recieverChatID;
  late ChatModel chatModel = ChatModel();
  late MainState currentState;
  BoxDecoration decA = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decC = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30)));
  BoxDecoration decB = const BoxDecoration(
      color: kPrimaryColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomLeft: Radius.circular(30)));

  TextStyle styles = const TextStyle(color: Colors.white, fontSize: 18);
  @override
  void initState() {
    super.initState();
    recieverChatID = widget.patientID + "-" + widget.recieverID;
    print(widget.token);
    chatModel.init(widget.patientID, widget.token);
    CubitProvider.of<MainCubit>(context).loadMessages(widget.patientID);
  }

  Widget buildSingleMessage(Message message) {
    return Align(
      alignment: message.senderID == recieverChatID
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        decoration: message.senderID == recieverChatID ? decA : decB,
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: Text(
          message.text,
          style: styles,
        ),
      ),
    );
  }

  Widget buildChatList() {
    return ScopedModel(
      model: chatModel,
      child: ScopedModelDescendant<ChatModel>(
        builder: (context, child, model) {
          List<Message> messages = model.getMessagesForChatID(recieverChatID);

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return buildSingleMessage(messages[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildChatArea() {
    return ScopedModel(
      model: chatModel,
      child: ScopedModelDescendant<ChatModel>(
        builder: (context, child, model) {
          return Container(
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: textEditingController,
                  ),
                ),
                SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: () {
                    model.sendMessage(
                        textEditingController.text, recieverChatID);
                    textEditingController.text = '';
                  },
                  elevation: 0,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CubitConsumer<MainCubit, MainState>(
        builder: (context, state) {
          if (state is MessagesLoadedState) {
            print('Messages loaded state');
            print(state.messages.last);
            chatModel.addMessages(state.messages);
            currentState = state;
          }

          return buildBody();
        },
        listener: (context, state) {
          if (state is ErrorState) {
            print("Error State Called CHAT SCREEN");
            // // _hideLoader();
          }
        },
      ),
    );
  }

  ListView buildBody() {
    return ListView(
      children: <Widget>[
        buildChatList(),
        buildChatArea(),
      ],
    );
  }
}
