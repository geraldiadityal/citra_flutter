part of 'pages.dart';

class ListRoomChatPage extends StatefulWidget {
  const ListRoomChatPage({Key? key}) : super(key: key);

  @override
  State<ListRoomChatPage> createState() => _ListRoomChatPageState();
}

class _ListRoomChatPageState extends State<ListRoomChatPage> {
  late CitraPartner partner;

  // bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChats();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = context.read<UserCubit>().state;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildHeader(),
        (userState is UserLoaded)
            ? ((userState).user.roles == "PARTNER")
                ? _buildContentForPartner(userState)
                : _buildContentForUser(userState)
            : RequireLoginWidget(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: kDefaultMargin),
      margin: EdgeInsets.only(bottom: kDefaultMargin),
      decoration: BoxDecoration(
        color: accentColor1,
        border: Border(
          bottom: BorderSide(color: accentColor4, width: 2),
        ),
      ),
      child: Row(
        children: [
          Text(
            "Chat",
            style: whiteTextFont.copyWith(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildContentForPartner(UserState userState) {
    return Expanded(
      child: (userState is UserLoaded)
          ? BlocBuilder<CitraPartnerCubit, CitraPartnerState>(
              builder: (context, statePartner) {
                if (statePartner is AllPartnerLoaded) {
                  return BlocBuilder<SessionChatCubit, SessionChatState>(
                    builder: (context, state) {
                      if (state is SessionChatLoaded) {
                        var data = state.sessionChat;

                        if (data.isNotEmpty) {
                          return ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                var dataPartner = statePartner.allCitraPartner
                                    .where((element) =>
                                        element.id ==
                                        data[index].transaction!.partner_id)
                                    .toList();
                                partner = dataPartner[0];

                                return CustomChatCard(
                                  partner: partner,
                                  user: data[index].user,
                                  sessionChat: data[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  color: greyColor,
                                );
                              },
                              itemCount: data.length);
                        } else {
                          return Center(
                            child: Text(
                              "Konsultasi kosong",
                              style: blackTextFont,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      } else if (state is SessionChatFailed) {
                        return Center(
                          child: Text(
                            "Chat Gagal di muat",
                            style: blackTextFont,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          : const RequireLoginWidget(),
    );
  }

  Widget _buildContentForUser(UserState userState) {
    return Expanded(
      child: (userState is UserLoaded)
          ? BlocBuilder<CitraPartnerCubit, CitraPartnerState>(
              builder: (context, statePartner) {
                if (statePartner is AllPartnerLoaded) {
                  return BlocBuilder<SessionChatCubit, SessionChatState>(
                    builder: (context, state) {
                      if (state is SessionChatLoaded) {
                        var data = state.sessionChat;

                        if (data.isNotEmpty) {
                          return ListView.separated(
                              itemBuilder: (BuildContext context, int index) {
                                var dataPartner = statePartner.allCitraPartner
                                    .where((element) =>
                                        element.id ==
                                        data[index].transaction!.partner_id)
                                    .toList();
                                partner = dataPartner[0];
                                return CustomChatCard(
                                  partner: partner,
                                  user: data[index].dataPartner,
                                  sessionChat: data[index],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  color: greyColor,
                                );
                              },
                              itemCount: data.length);
                        } else {
                          return Center(
                            child: Text(
                              "Chat Kosong\nSilahkan ke Home\nUntuk Memulai Chat",
                              style: blackTextFont,
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      } else if (state is SessionChatFailed) {
                        return Center(
                          child: Text(
                            "Chat Gagal di muat",
                            style: blackTextFont,
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        return Stack();
                      }
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          : const Center(
              child: RequireLoginWidget(),
            ),
    );
  }

  Future<void> getChats() async {
    await context.read<CitraPartnerCubit>().getAllPartner();
    if (User.token != null) {
      UserState user = context.read<UserCubit>().state;
      context.read<SessionChatCubit>().getSessionChat();
      if (user is UserLoaded) {
        context.read<SessionChatCubit>().initSessionPusher(id: user.user.id!);
      }
    }
  }
}
