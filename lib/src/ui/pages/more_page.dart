part of 'pages.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    UserState state = context.read<UserCubit>().state;
    List<Menu> listMenu1 = [
      Menu(
        text: "Edit Your Profile",
        iconData: Icons.people,
        onPressed: () {
          Get.to(() => EditProfilePage());
        },
      ),
      Menu(
        text: "Change your password",
        iconData: Icons.lock,
        onPressed: () {
          Get.to(() => ChangePasswordPage());
        },
      ),
    ];
    List<Menu> listMenu2 = [
      Menu(
        text: "About Citra Alterindo",
        iconData: Icons.corporate_fare,
        onPressed: () {
          Get.to(() => AboutCitraPage());
        },
      ),
      Menu(
        text: "Our Services",
        iconData: Icons.room_service,
        onPressed: () {
          Get.to(() => AboutCitraPage(
                initPage: 2,
              ));
        },
      ),
      Menu(
        text: "Our Team",
        iconData: Icons.groups,
        onPressed: () {
          Get.to(() => AboutCitraPage(
                initPage: 3,
              ));
        },
      ),
      Menu(
          text: "Our Location",
          iconData: Icons.map,
          onPressed: () async {
            String url = "https://goo.gl/maps/j4XJLWjY5NeT1yi77";
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            }
          }),
    ];

    return Column(
      children: [
        _buildProfile(),
        Text(
          "Your Profile",
          style: blackTextFont.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        _buildListMenu(listMenu1),
        Text(
          "Citra Alterindo",
          style: blackTextFont.copyWith(fontSize: 18, fontWeight: semiBold),
        ),
        _buildListMenu(listMenu2),
        (isLoading)
            ? Center(
                child: loadingIndicator,
              )
            : _buildLogout(state, context),
      ],
    );
  }

  Widget _buildProfile() {
    return Container(
      width: double.infinity,
      height: 100,
      padding: EdgeInsets.all(kDefaultMargin / 2),
      decoration: BoxDecoration(
        color: accentColor1,
        border: Border(
          bottom: BorderSide(color: accentColor4, width: 2),
        ),
      ),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          return Row(
            children: [
              (state is UserLoaded)
                  ? CircleAvatar(
                      backgroundColor: accentColor2,
                      radius: 40,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: whiteColor,
                        backgroundImage: NetworkImage(
                          storageUrl + state.user.picturePath,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 40,
                      color: whiteColor,
                    ),
              SizedBox(width: kDefaultMargin / 3),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (state is UserLoaded)
                            ? "Hi, ${(state).user.name}"
                            : "Hi, Guest",
                        maxLines: 2,
                        style: whiteTextFont.copyWith(
                            fontSize: 18, fontWeight: semiBold),
                      ),
                      Text(
                        (state is UserLoaded) ? (state).user.companyName : "",
                        style: whiteTextFont.copyWith(
                            fontSize: 16, fontWeight: regular),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogout(UserState state, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (state is UserLoaded) {
          setState(() {
            isLoading = true;
          });
          await context.read<UserCubit>().signOut(User.token!);
          User.token = null;
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          PrefsHelper(sharedPreferences: _prefs).removeUserToken();
          PrefsHelper(sharedPreferences: _prefs).removeUserId();
          await PusherBeams.instance.clearDeviceInterests();
          List<CitraService>? services =
              await context.read<CitraServiceCubit>().getService();
          Get.offAll(
            () => StartPage(
              services: services,
            ),
          );
        } else {
          Get.to(() => const LoginPage());
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(kDefaultMargin / 3),
        margin: EdgeInsets.all(kDefaultMargin / 2),
        decoration: BoxDecoration(
            color: (state is UserLoaded) ? accentColor4 : accentColor2,
            borderRadius: BorderRadius.circular(kDefaultRadius),
            border: Border.all(color: accentColor1),
            boxShadow: [
              BoxShadow(
                color: blackColor,
                blurRadius: 2,
                spreadRadius: 0.0,
                offset: Offset(1, 1),
              ),
            ]),
        child: Center(
          child: Text(
            (state is UserLoaded) ? "Log out" : "Log In",
            style: whiteTextFont.copyWith(fontSize: 16, fontWeight: semiBold),
          ),
        ),
      ),
    );
  }

  Widget _buildListMenu(List<Menu> listMenu) {
    return Container(
      margin: EdgeInsets.all(kDefaultMargin / 2),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(color: accentColor1),
        boxShadow: [
          BoxShadow(
            color: blackColor,
            blurRadius: 2,
            spreadRadius: 0.0,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: listMenu
            .map(
              (e) => CustomMenu(menu: e),
            )
            .toList(),
      ),
    );
  }
}
