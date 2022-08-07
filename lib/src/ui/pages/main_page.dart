part of 'pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int bottomNavBarindex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomNavBarindex = context.read<PageCubit>().state;
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = context.read<UserCubit>().state;
    return Scaffold(
      backgroundColor: accentColor1,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              color: accentWhite1,
              width: double.infinity,
              child: bottomNavBarindex == 0
                  ? HomePage()
                  : bottomNavBarindex == 1
                      ? const ListRoomChatPage()
                      : const MorePage(),
            ),
          ),
          createCustomBottomNavBar(userState),
        ],
      ),
    );
  }

  Align createCustomBottomNavBar(UserState userState) {
    // bool isPartner =
    //     ((userState as UserLoaded).user.roles == "ADMIN" ? true : false);
    bool isPartner = (userState is UserLoaded)
        ? (userState as UserLoaded).user.roles == "PARTNER"
            ? true
            : false
        : false;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: const BoxDecoration(
          color: whiteColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!isPartner) ...[
              CustomBottomItem(
                icon: Icons.home,
                text: "Home",
                selectedIndex: 0,
                isTap: bottomNavBarindex == 0,
                onTap: (index) {
                  setState(() {
                    bottomNavBarindex = index;
                  });
                },
              ),
            ],
            CustomBottomItem(
              icon: Icons.chat,
              text: "Chat",
              selectedIndex: 1,
              isTap: bottomNavBarindex == 1,
              onTap: (index) {
                setState(() {
                  bottomNavBarindex = index;
                });
              },
            ),
            CustomBottomItem(
              icon: Icons.more_horiz,
              text: "More",
              selectedIndex: 2,
              isTap: bottomNavBarindex == 2,
              onTap: (index) {
                setState(() {
                  bottomNavBarindex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
