part of 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: size.width,
          color: accentWhite1,
          height: size.height,
          padding: EdgeInsets.all(kDefaultMargin),
          child: Column(
            children: [
              const CustomHeader(titleHeader: "Login"),
              Expanded(
                child: ListView(
                  children: [
                    _buildText(),
                    SizedBox(
                      width: size.width,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/scene/login1.svg",
                          fit: BoxFit.cover,
                          height: size.height * 0.18,
                        ),
                      ),
                    ),
                    CustomTextfield(
                      controller: emailController,
                      title: "Email Address",
                      iconPrefix: const Icon(Icons.email),
                    ),
                    CustomTextfield(
                      controller: passController,
                      title: "Password",
                      obsText: true,
                      iconPrefix: const Icon(Icons.lock),
                    ),
                    CustomButton(
                      textButton: "Login",
                      isLoading: isLoading,
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await context.read<UserCubit>().signIn(
                              emailController.text,
                              passController.text,
                            );

                        UserState state = context.read<UserCubit>().state;

                        if (state is UserLoaded) {
                          SharedPreferences _prefs =
                              await SharedPreferences.getInstance();
                          PrefsHelper(sharedPreferences: _prefs)
                              .setUserToken(User.token!);
                          if (state.user.roles == "PARTNER") {
                            context.read<PageCubit>().setPage(1);
                          } else {
                            context.read<PageCubit>().setPage(0);
                          }
                          PrefsHelper(sharedPreferences: _prefs)
                              .setUserId(state.user.id!);
                          await PusherBeams.instance.start(beamId);
                          await PusherBeams.instance
                              .addDeviceInterest("user.${state.user.id!}");
                          Get.offAll(() => const MainPage());
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          await Flushbar(
                            title: 'Login Gagal',
                            backgroundColor: accentColor1,
                            message: ((state as UserLoadingFailed).message),
                            duration: const Duration(seconds: 3),
                          ).show(context);
                        }
                      },
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const ForgotPasswordPage());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Forgot your password? ',
                            style: greyTextFont.copyWith(
                              fontSize: 12,
                              fontWeight: semiBold,
                            ),
                            children: [
                              TextSpan(
                                text: "Reset Password",
                                style: secondaryTextFont.copyWith(
                                    fontSize: 12, fontWeight: semiBold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kDefaultMargin,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const RegisterPage());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: greyTextFont.copyWith(
                              fontSize: 14,
                              fontWeight: semiBold,
                            ),
                            children: [
                              TextSpan(
                                text: "Register",
                                style: accentTextFont.copyWith(
                                    fontSize: 14, fontWeight: semiBold),
                              ),
                            ],
                          ),
                        ),
                      ),
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

  Widget _buildText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back!",
          style: blackTextFont.copyWith(fontSize: 24, fontWeight: semiBold),
        ),
        Text(
          "Login to continue",
          style: greyTextFont.copyWith(fontSize: 18, fontWeight: regular),
        ),
      ],
    );
  }
}
