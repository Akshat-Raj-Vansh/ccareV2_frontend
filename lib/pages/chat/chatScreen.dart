//@dart=2.9
import 'package:ccarev2_frontend/main/domain/edetails.dart';
import 'package:ccarev2_frontend/pages/chat/components/chatModel.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/user/domain/details.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:scoped_model/scoped_model.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sizer/sizer.dart';
import 'components/message.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final String recieverID;
  final String patientID;
  final String token;
  final MainCubit mainCubit;
  ChatPage(
      this.name, this.recieverID, this.patientID, this.token, this.mainCubit);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  String recieverChatID;
  ChatModel chatModel = ChatModel();
  MainState currentState;
  ScrollController _scrollController = ScrollController();
  BoxDecoration decA = const BoxDecoration(
      color: kSecondaryColor,
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

  TextStyle styles = TextStyle(color: Colors.white, fontSize: 14.sp);
  @override
  void initState() {
    super.initState();
    recieverChatID = widget.patientID + "-" + widget.recieverID;
    print(widget.token);
    chatModel.init(widget.patientID, widget.token);
    widget.mainCubit.loadMessages(widget.patientID);
    _scrollController = ScrollController();
  }

  _scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        rebuildOnChange: true,
        builder: (context, child, model) {
          List<Message> messages = model.getMessagesForChatID(recieverChatID);
          // scrollToBottom();

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              // reverse: true,
              controller: _scrollController,
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
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Row(
              children: <Widget>[
                Container(
                  // padding: const EdgeInsets.symmetric(
                  //     vertical: 5.0, horizontal: 20.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kPrimaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kPrimaryColor)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: kPrimaryColor)),
                      labelText: 'Send',
                      labelStyle: TextStyle(
                        color: kPrimaryColor,
                      ),
                      hintText: 'Write your message here.',
                    ),
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 12.sp,
                        decorationColor: kPrimaryColor),
                    cursorColor: kPrimaryColor,
                  ),
                ),
                SizedBox(width: 1.w),
                FloatingActionButton(
                  onPressed: () {
                    if(textEditingController.text!=""){
                    model.sendMessage(
                        textEditingController.text, recieverChatID);
                    textEditingController.text = '';
                    _scrollToEnd();}
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
        backgroundColor: kPrimaryColor,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: CubitConsumer<MainCubit, MainState>(
        cubit: widget.mainCubit,
        builder: (context, state) {
          print("ChatScreen Builder state: $state");
          if (state is MessagesLoadedState) {
            //print('Messages loaded state');
            print(state.messages.last);
            chatModel.messages = [];
            chatModel.addMessages(state.messages);
            currentState = state;
            //  scrollToBottom();
          }
          if (currentState == null)
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
          return buildBody();
        },
        listener: (context, state) {
          print("ChatScreen Listner state: $state");
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
      padding: EdgeInsets.zero,
      children: <Widget>[
        buildChatList(),
        buildChatArea(),
      ],
    );
  }
}
