part of 'pages.dart';

class DetailChatPage extends StatefulWidget {
  final User otherUser;
  final CitraService service;
  final SessionChat sessionChat;

  const DetailChatPage({
    Key? key,
    required this.otherUser,
    required this.sessionChat,
    required this.service,
  }) : super(key: key);

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  User? dataUser;
  final TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  final FocusNode messageFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<PusherMessageCubit>()
        .getFetchMessage(sessionChatId: widget.sessionChat.id);

    dataUser = (context.read<UserCubit>().state as UserLoaded).user;
    initMessage();
  }

  Future<void> initMessage() async {
    await context
        .read<PusherMessageCubit>()
        .initPusher(sessionChatId: widget.sessionChat.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = context.read<UserCubit>().state;

    return WillPopScope(
      onWillPop: () async {
        context.read<PageCubit>().setPage(1);
        Get.offAll(() => MainPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: accentColor1,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: accentWhite1,
            child: Column(
              children: [
                _buildHeader(userState),
                Expanded(
                  child: BlocBuilder<PusherMessageCubit, PusherMessageState>(
                    builder: (context, state) {
                      if (state is PusherMessageSuccess) {
                        List<PusherMessage> data =
                            state.pusherMessage.reversed.toList();
                        if (data.isNotEmpty) {
                          return ListView.builder(
                            controller: _controller,
                            shrinkWrap: false,
                            reverse: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                if (_controller.hasClients) {
                                  // scrollController();
                                }
                              });

                              if (userState is UserLoaded) {
                                var message = data[index];

                                if (message.chat.userId == userState.user.id &&
                                    message.chat.isUser == true) {
                                  return CustomMessageCard(
                                    text: message.content,
                                    time: message.chat.createdAt!,
                                  );
                                } else {
                                  if (message.chat.isUser == false) {
                                    return const SizedBox();
                                  } else {
                                    return CustomMessageCard(
                                      text: message.content,
                                      isUser: false,
                                      time: message.chat.createdAt!,
                                    );
                                  }
                                }
                              } else {
                                return const SizedBox();
                              }
                            },
                            itemCount: data.length,
                          );
                        } else {
                          return Text(
                            "Halo, Selamat Datang di Citra Consulting",
                            style: blackTextFont,
                          );
                        }
                      } else if (state is PusherMessageLoading) {
                        return Center(
                          child: loadingIndicator,
                        );
                      } else {
                        return Center(
                          child: Text("Error :("),
                        );
                      }
                    },
                  ),
                ),
                _buildSend(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scrollController() async {
    if (_controller.position.hasContentDimensions) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget _buildSend() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(width: 1, color: accentColor4),
        ),
      ),
      child: BlocBuilder<SessionChatCubit, SessionChatState>(
        builder: (context, state) {
          if (state is SessionChatLoaded) {
            SessionChat sessionChat = state.sessionChat
                .singleWhere((element) => element.id == widget.sessionChat.id);
            bool isEnd = sessionChat.expired_at.isBefore(DateTime.now());
            if (isEnd) {
              return Row(
                children: [
                  Text(
                    "Konsultasi telah selesai, Terima Kasih",
                    style: blackTextFont,
                  ),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      focusNode: messageFocus,
                      style: blackTextFont,
                      minLines: 1,
                      maxLines: 5,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        fillColor: whiteColor,
                        filled: true,
                        isCollapsed: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: greyColor),
                          borderRadius: BorderRadius.circular(kDefaultRadius),
                        ),
                        hintText: "Kirim Pesan",
                        hintStyle: greyTextFont,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (messageController.text.length >= 1) {
                        String msg = messageController.text;
                        messageController.clear();
                        await PusherMessageServices.sendMessage(
                          message: msg,
                          userId: widget.otherUser.id!,
                          sessionChatId: widget.sessionChat.id,
                        );
                        await PusherMessageServices.sendNotification(
                            toUser: widget.otherUser.id!,
                            title: dataUser!.name,
                            body: msg);
                      } else {
                        FocusScope.of(context).requestFocus(messageFocus);
                      }
                    },
                    color: accentColor2,
                    icon: const Icon(Icons.send),
                  ),
                ],
              );
            }
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildHeader(UserState state) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: kDefaultMargin / 2),
      decoration: BoxDecoration(
        color: accentColor1,
        border: Border(
          bottom: BorderSide(width: 1, color: accentColor4),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            color: accentColor3,
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () async {
              context.read<PageCubit>().setPage(1);
              Get.offAll(() => MainPage());
            },
          ),
          Container(
            width: 48,
            height: 48,
            margin: EdgeInsets.only(right: kDefaultMargin / 3),
            decoration: BoxDecoration(
              color: whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: accentColor2, width: 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  storageUrl + widget.otherUser.picturePath,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUser.name,
                  style:
                      whiteTextFont.copyWith(fontSize: 16, letterSpacing: 1.2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Sesi Konsultasi selesai pada\n" +
                      convertDateTime(widget.sessionChat.expired_at),
                  style: whiteTextFont.copyWith(fontSize: 8, letterSpacing: 1),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () async {
              _joinJitsi();
            },
            color: accentColor3,
            icon: const Icon(Icons.videocam),
          ),
          ((state as UserLoaded).user.roles == "PARTNER")
              ? PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: whiteColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(
                        "Daftarkan",
                        style: blackTextFont,
                      ),
                      value: 'REG',
                    ),
                    PopupMenuItem(
                      child: Text(
                        "End Chat",
                        style: accentTextFont,
                      ),
                      value: 'END',
                    )
                  ],
                  onSelected: (String newValue) {
                    if (newValue == "REG") {
                      Get.to(() => ClientPage(
                            user: widget.otherUser,
                            fromUser: false,
                            service: widget.service,
                          ));
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("End Chat"),
                          content: Text("Konsultasi akan diselesaikan"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'NO'),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await SessionChatServices.endSessionChat(
                                    sessionId: widget.sessionChat.id);
                                setState(() {});
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _joinJitsi() async {
    try {
      await PusherMessageServices.sendNotification(
          toUser: widget.otherUser.id!,
          title: dataUser!.name,
          body: "Memulai Video Conference, Join Sekarang");

      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.INVITE_ENABLED: false,
        FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
        FeatureFlagEnum.CHAT_ENABLED: false,
      };
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      var options =
          JitsiMeetingOptions(room: "citraconsulting-${widget.sessionChat.id}")
            ..serverURL = null
            ..subject = "Citra Consulting ${widget.sessionChat.id}"
            ..userDisplayName = dataUser!.name
            ..userEmail = ""
            ..userAvatarURL = storageUrl + dataUser!.picturePath // or .png
            ..audioOnly = true
            ..audioMuted = true
            ..videoMuted = true
            ..featureFlags.addAll(featureFlags);

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
}
