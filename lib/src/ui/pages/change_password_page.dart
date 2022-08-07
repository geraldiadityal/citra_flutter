part of 'pages.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController passController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserState state = context.read<UserCubit>().state;
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: size.width,
          color: accentWhite1,
          height: size.height,
          padding: EdgeInsets.all(kDefaultMargin),
          child: SingleChildScrollView(
            child: (state is UserLoaded)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomHeader(titleHeader: "Change Password"),
                      Container(
                        width: size.width,
                        margin: EdgeInsets.only(
                            bottom: kDefaultMargin, top: kDefaultMargin / 2),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/scene/forgot_password.svg",
                            fit: BoxFit.cover,
                            height: size.height * 0.2,
                          ),
                        ),
                      ),
                      CustomTextfield(
                        controller: passController,
                        title: "Current Password",
                        obsText: true,
                        length: 64,
                        iconPrefix: const Icon(Icons.password),
                      ),
                      CustomTextfield(
                        controller: newPassController,
                        title: "New Password",
                        obsText: true,
                        length: 64,
                        iconPrefix: const Icon(Icons.lock_open),
                      ),
                      CustomTextfield(
                        controller: confirmController,
                        title: "New Password Confirmation",
                        obsText: true,
                        length: 64,
                        iconPrefix: const Icon(Icons.lock),
                      ),
                      CustomButton(
                        textButton: "Change Password",
                        isLoading: isLoading,
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            if (passController.text.length < 1 ||
                                confirmController.text.length < 1) {
                              throw 'Mohon lengkapi isian yang ada';
                            }
                            if (passController.text.length <= 8 ||
                                confirmController.text.length <= 8) {
                              throw 'Minimal panjang password 8 character';
                            }

                            if (newPassController.text !=
                                confirmController.text) {
                              throw 'Password tidak sama';
                            }
                            if (User.token == null) {
                              throw 'Login terlebih dahulu';
                            }
                            StatusPassword status =
                                await UserServices.changePassword(
                                    token: User.token!,
                                    currentPassword: passController.text,
                                    newPassword: newPassController.text,
                                    passConfirm: confirmController.text);
                            setState(() {
                              isLoading = false;
                            });
                            await Flushbar(
                              title: "${status.code}! ${status.message}",
                              backgroundColor: accentColor1,
                              message: status.data,
                              duration: const Duration(seconds: 3),
                            ).show(context);

                            if (status.code == 200) {
                              Get.back();
                            }
                          } catch (e) {
                            setState(() {
                              isLoading = false;
                            });
                            await Flushbar(
                              title: 'Ganti Password Gagal',
                              backgroundColor: accentColor1,
                              message: e.toString(),
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          }
                        },
                      ),
                    ],
                  )
                : RequireLoginWidget(),
          ),
        ),
      ),
    );
  }
}
