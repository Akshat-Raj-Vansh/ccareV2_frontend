//@dart=2.9
// import 'package:camera/camera.dart';
import 'package:ccarev2_frontend/pages/chat/components/camera_components/cameraScreen.dart';
import 'package:ccarev2_frontend/pages/chat/components/chatModel.dart';
import 'package:ccarev2_frontend/pages/chat/components/chat_ui/ownCardUI.dart';
import 'package:ccarev2_frontend/pages/chat/components/chat_ui/ownImageCardUI.dart';
import 'package:ccarev2_frontend/pages/chat/components/chat_ui/replyCardUI.dart';
import 'package:ccarev2_frontend/pages/chat/components/chat_ui/replyImageCardUI.dart';
import 'package:ccarev2_frontend/state_management/main/main_state.dart';
import 'package:ccarev2_frontend/utils/constants.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:ccarev2_frontend/state_management/main/main_cubit.dart';

import 'components/message.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final String recieverID;
  final String patientID;
  final String token;
  final MainCubit mainCubit;
  const ChatScreen({
    this.name,
    this.recieverID,
    this.patientID,
    this.token,
    this.mainCubit,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatModel chatModel = ChatModel();
  MainState currentState;
  FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController;
  bool _showEmojiPicker = false;
  bool _sendButtonEnabled = false;
  final ImagePicker _imagePicker = ImagePicker();
  XFile _image;
  bool clickImage;
  String message = "Message";
  String recieverChatID;

  ScrollController _scrollController = ScrollController();
  _scrollToEnd() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }

  _sendImage(XFile file) {
    widget.mainCubit.uploadChatImage(file);
  }

  _onEmojiSelected(Category category, Emoji emoji) {
    _textEditingController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  _onBackspacePressed() {
    _textEditingController
      ..text = _textEditingController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: _textEditingController.text.length));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // chatModel.closeChat();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _textEditingController = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          // _sendButtonEnabled = true;
          _showEmojiPicker = false;
        });
      }
    });
    recieverChatID = widget.patientID + "-" + widget.recieverID;
    print('Token:' + widget.token);
    print('PatientID:' + widget.patientID);
    chatModel.init(widget.patientID, widget.token);
    // widget.mainCubit.loadMessages(widget.patientID);
    widget.mainCubit.chatLoading();
  }

  Widget buildSingleMessage(Message message) {
    if (message.type == "text")
      return message.senderID == recieverChatID
          ? ReplyCard(message: message.text, time: message.time)
          : OwnMessageCard(message: message.text, time: message.time);
    else
      return message.senderID == recieverChatID
          ? ReplyImageCard(path: message.path, time: message.time)
          : OwnImageCard(path: message.path, time: message.time);
  }

  Widget buildChatList() {
    return ScopedModel(
      model: chatModel,
      child: ScopedModelDescendant<ChatModel>(
        rebuildOnChange: true,
        builder: (context, child, model) {
          List<Message> messages = model.getMessagesForChatID(recieverChatID);
          // scrollToBottom();
          print(messages.length);
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                // reverse: true,
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildSingleMessage(messages[index]);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _imgFromCamera() async {
    XFile image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    if (image != null) {
      _sendImage(image);
    }
    // setState(() {
    //   _image = image;
    //   clickImage = true;
    //   print(_image.path);
    //   // widget.mainCubit.imageClicked(image);
    // });
  }

  _imgFromGallery() async {
    XFile image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      _sendImage(image);
      setState(() {
        //add message to db with image
        // _image = image;
        // clickImage = true;
        // print(_image.path);
        // // widget.mainCubit.imageClicked(image);
      });
    }
  }

  Widget emojiPicker() {
    return EmojiPicker(
      config: Config(
        bgColor: Colors.grey[200],
        indicatorColor: Colors.grey[300],
      ),
      onEmojiSelected: _onEmojiSelected,
      onBackspacePressed: _onBackspacePressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          // widget.name,
          "Danish Sheikh",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ),
      // body: buildBody(),
      body: CubitConsumer<MainCubit, MainState>(
        cubit: widget.mainCubit,
        builder: (context, state) {
          print("ChatScreen Builder state: $state");

          if (state is ChatLoadingState) {
            widget.mainCubit.loadMessages(widget.patientID);
          }
          if (state is MessagesLoadedState) {
            print('Messages loaded state');
            print(state.messages.last);
            chatModel.messages = [];
            print(state.messages.length);
            chatModel.addMessages(state.messages);
            currentState = state;
            WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
            //  scrollToBottom();
          }
          if (state is ErrorState) {
            currentState = state;
          }
          if (currentState == null)
            return Container(
                color: Colors.white,
                child: Center(child: CircularProgressIndicator()));

          return buildBody();
        },
        listener: (context, state) {
          print("ChatScreen Listner state: $state");
          if (state is ErrorState) {
            print("Error State Called CHAT SCREEN");
            // // _hideLoader();
          }
          if (state is ChatImageUploaded) {
            print("Image Uploaded");
            chatModel.sendMessage("-", recieverChatID, "image",
                path: state.fileID);
          }
        },
      ),
    );
  }

  Widget buildBody() => Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: WillPopScope(
        onWillPop: () {
          if (_showEmojiPicker) {
            setState(() {
              _showEmojiPicker = false;
            });
          } else {
            Navigator.of(context).pop(true);
          }
          return Future.value(false);
        },
        child: Stack(
          children: [buildChatList(), buildChatArea()],
        ),
      ));

  Align buildChatArea() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: ScopedModel(
          model: chatModel,
          child: ScopedModelDescendant<ChatModel>(
            builder: (context, child, model) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                          margin:
                              EdgeInsets.only(left: 5, right: 5, bottom: 1.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: TextFormField(
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            textAlignVertical: TextAlignVertical.center,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                            decoration: InputDecoration(
                                suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (builder) =>
                                                    bottomSheet());
                                          },
                                          icon: Icon(
                                            Icons.attach_file,
                                            color: kPrimaryColor,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            _imgFromCamera();
                                            // Navigator.of(context).push(
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             CameraScreen()));
                                          },
                                          icon: Icon(Icons.camera,
                                              color: kPrimaryColor))
                                    ]),
                                prefixIcon: IconButton(
                                    onPressed: () {
                                      print("Emoji Pressed");
                                      _focusNode.unfocus();
                                      // _focusNode.canRequestFocus = false;
                                      setState(() {
                                        _showEmojiPicker = !_showEmojiPicker;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.emoji_emotions,
                                      color: kPrimaryColor,
                                    )),
                                contentPadding: EdgeInsets.all(1.h),
                                border: InputBorder.none,
                                hintText: message),
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CircleAvatar(
                      backgroundColor: kAccentColor,
                      child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (_textEditingController.text != "") {
                              FocusManager.instance.primaryFocus?.unfocus();
                              model.sendMessage(_textEditingController.text,
                                  recieverChatID, "text");
                              _textEditingController.text = '';
                              _scrollToEnd();
                            }
                          }),
                    ),
                  ),
                ]),
                Offstage(
                  offstage: !_showEmojiPicker,
                  child: SizedBox(height: 250, child: emojiPicker()),
                )
              ],
            ),
          ),
        ));
  }

  Widget bottomSheet() {
    return Container(
      height: 20.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // iconCreation(
              //     Icons.insert_drive_file, Colors.indigo, "Document", () {}),
              // SizedBox(
              //   width: 40,
              // ),
              iconCreation(Icons.camera_alt, Colors.pink, "Camera", () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => CameraScreen()));
                _imgFromCamera();
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (_) => CameraExampleHome()));
              }),
              SizedBox(
                width: 40,
              ),
              iconCreation(Icons.insert_photo, Colors.purple, "Gallery", () {
                _imgFromGallery();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }
}
