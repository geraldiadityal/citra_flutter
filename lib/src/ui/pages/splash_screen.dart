part of 'pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Image logo;
  String? errorText;

  startSplash() async {
    try {
      List<CitraService>? services =
          await context.read<CitraServiceCubit>().getService();
      await context.read<CitraPartnerCubit>().getAllPartner();

      SharedPreferences _prefs = await SharedPreferences.getInstance();
      String? token = PrefsHelper(sharedPreferences: _prefs).initialUserToken();

      if (token != null) {
        await context.read<UserCubit>().loginWithPrefs(token);
        UserState state = context.read<UserCubit>().state;
        if ((state as UserLoaded).user.roles == "PARTNER") {
          context.read<PageCubit>().setPage(1);
        }
        Get.offAll(
          () => const MainPage(),
          transition: GetTransition.Transition.cupertino,
          duration: const Duration(seconds: 1),
        );
      } else {
        Get.offAll(
          () => StartPage(
            services: services,
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorText = "Check your connection";
      });
      await Flushbar(
        title: 'Check your connection',
        backgroundColor: accentColor1,
        message: e.toString(),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logo = Image.asset(
      'assets/logo.png',
      fit: BoxFit.cover,
    );
    startSplash();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          color: accentWhite1,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: Hero(
                    tag: "logo",
                    child: logo,
                  ),
                ),
                Text(
                  "Citra Consulting",
                  style:
                      blackTextFont.copyWith(fontSize: 18, fontWeight: light),
                ),
                Text(
                  "Versi 1.0.1",
                  style:
                      blackTextFont.copyWith(fontSize: 14, fontWeight: light),
                ),
                SizedBox(
                  height: kDefaultMargin,
                ),
                (errorText != null)
                    ? Column(
                        children: [
                          Text(
                            errorText!,
                            style: blackTextFont,
                          ),
                          CustomButton(
                            onPressed: () {
                              startSplash();
                            },
                            textButton: "Retry",
                            btnWidth: 150,
                          ),
                        ],
                      )
                    : SizedBox(
                        width: 128,
                        child: LinearProgressIndicator(
                          backgroundColor: accentWhite1,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(accentColor1),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
