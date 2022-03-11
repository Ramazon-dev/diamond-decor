import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'package:wallpaper/constants/sizeconfig.dart';
import 'package:wallpaper/core/graphql_clients.dart';
import 'package:wallpaper/core/query.dart';

class ChatPageMoney extends StatefulWidget {
  const ChatPageMoney({Key? key}) : super(key: key);

  @override
  _ChatPageMoneyState createState() => _ChatPageMoneyState();
}

class _ChatPageMoneyState extends State<ChatPageMoney> {
  List<types.Message> _messages = [];
  final _user = types.User(id: '${box.read('id')}');

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: getHeight(160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleImageSelection();
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Photo'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final message = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        mimeType: lookupMimeType(result.files.single.path!),
        name: result.files.single.name,
        size: result.files.single.size,
        uri: result.files.single.path!,
      );

      _addMessage(message);
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  // void handleMessageTap({types.Message? message}) async {
  //   if (message is types.FileMessage) {
  //     await OpenFile.open(message.uri);
  //   }
  // }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = _messages[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _messages[index] = updatedMessage;
      });
    });
  }

  void _handleSendPressed(types.PartialText message) async {
    QueryResult? sendmes = await clientAll.value.mutate(MutationOptions(
      document: gql(sendMessagemoney(message.text)),
    ));

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }

  void _loadMessages() async {
    QueryResult? moneycommets = await clientAll.value.mutate(MutationOptions(
      document: gql(moneycomentsQuery()),
    ));
    final commentJson = moneycommets.data?['moneyComments']['edges'];
    List<int> sonlar = List<int>.generate(10, (i) => i * 0);
    final res = List.generate(commentJson.length, (i) {
      if (!(commentJson[i]['node']['photo'] == null)) {
        return {
          "author": {
            "firstName": "${commentJson[i]['node']['user']['userName']}",
            "id": "${commentJson[i]['node']['userId']}",
            "imageUrl": "https://avatars.githubusercontent.com/u/14123304?v=4"
          },
          "createdAt": 1598438789000,
          "height": 600,
          "id": "${commentJson[i]['node']['id']}",
          "size": 8565,
          "name": "image",
          "status": "seen",
          "text": "${commentJson[i]['node']['commentsText']}",
          "type": "image",
          "uri":
              "https://diamond.softcity.uz/media/${commentJson[i]['node']['photo']}",
          "width": 1128
        };
      } else {
        return {
          "author": {
            "firstName": "${commentJson[i]['node']['user']['userName']}",
            "id": "${commentJson[i]['node']['userId']}",
            "imageUrl": "https://avatars.githubusercontent.com/u/14123304?v=4"
          },
          "createdAt": 1598438797000,
          "id": "${commentJson[i]['node']['id']}",
          "status": commentJson[i]['node']['status'] == 1 ? "seen" : "send",
          "text": "${commentJson[i]['node']['commentsText']}",
          "type": "text"
        };
      }
    });

    final messages = res.reversed
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Chat(
          theme: DefaultChatTheme(
            inputTextDecoration: InputDecoration(
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                gapPadding: 10,
                borderRadius: BorderRadius.circular(30),
              ),
              contentPadding: const EdgeInsets.all(13),
              filled: true,
              fillColor: Colors.white,
              isDense: true,
            ),
            inputBackgroundColor: Colors.grey.shade300,
            inputTextColor: Colors.black,
            inputTextStyle: const TextStyle(
              color: Colors.black,
            ),
            attachmentButtonIcon: Icon(
              Icons.attach_file,
              color: Colors.black,
              size: getHeight(30),
            ),
            inputBorderRadius: BorderRadius.circular(0),
          ),
          messages: _messages,
          onAttachmentPressed: _handleAtachmentPressed,
          // onMessageTap: handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          user: _user,
        ),
      ),
    );
  }
}
