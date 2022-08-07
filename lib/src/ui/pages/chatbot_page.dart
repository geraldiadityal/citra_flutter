part of 'pages.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({Key? key}) : super(key: key);

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  final FocusNode messageFocus = FocusNode();

  List<Map<String, dynamic>> messages = [];

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DialogFlowtter.fromFile(
            path: "assets/sacred-truck-347220-cd67f7eedb94.json")
        .then((value) => dialogFlowtter = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor1,
      appBar: AppBar(
        backgroundColor: accentColor1,
        title: Text("Chatbot"),
      ),
      body: SafeArea(
        child: Container(
          color: accentWhite1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Silahkan chat dengan bot kami",
                style: blackTextFont,
              ),
              Expanded(
                child: ListView.separated(
                    reverse: true,
                    itemBuilder: (context, index) {
                      var obj = messages[messages.length - 1 - index];
                      Message msg = obj['message'];
                      bool isUser = obj['isUserMessage'] ?? false;
                      return Row(
                        mainAxisAlignment: isUser
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          _buildChatCard(context, msg, isUser),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: messages.length),
              ),
              Container(
                color: accentColor1,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        minLines: 1,
                        focusNode: messageFocus,
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: whiteColor,
                          contentPadding: const EdgeInsets.all(8),
                          isCollapsed: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: greyColor),
                            borderRadius: BorderRadius.circular(kDefaultRadius),
                          ),
                          hintText: "Kirim Pesan",
                          hintStyle: greyTextFont,
                        ),
                        cursorColor: blackColor,
                        controller: _controller,
                        style: blackTextFont,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      color: whiteColor,
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      addMessage(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    dialogFlowtter.projectId = "sacred-truck-347220";

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text, languageCode: 'id')),
    );

    if (response.message == null) return;
    setState(() {
      addMessage(response.message!);
    });
  }

  void addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

  Widget _buildChatCard(BuildContext context, Message msg, bool isUser) {
    Size size = MediaQuery.of(context).size;
    return Container(
      constraints: BoxConstraints(
        minWidth: size.width * 0.1,
        maxWidth: size.width * 0.8,
      ),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: kDefaultMargin / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        color: isUser ? accentColor2 : accentColor4,
      ),
      child: (msg.type == MessageType.card)
          ? Text(
              msg.card!.title.toString(),
              style: whiteTextFont,
            )
          : Text(
              msg.text?.text?[0] ?? '',
              style: whiteTextFont,
            ),
    );
  }
}
