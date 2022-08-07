part of 'pages.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  StatusPassword? status;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomHeader(titleHeader: "Forgot Password"),
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
                  controller: emailController,
                  title: "Email Address",
                  iconPrefix: const Icon(Icons.email),
                ),
                CustomButton(
                  textButton: "Reset Password",
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (emailController.text.length < 1) {
                      setState(() {
                        isLoading = false;
                      });
                      await Flushbar(
                        title: 'Email tidak diisi',
                        backgroundColor: accentColor1,
                        message: 'Mohon diisi email anda',
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    } else {
                      status = await UserServices.forgotPasswordUser(
                          emailController.text);
                      setState(() {
                        isLoading = false;
                      });
                      await Flushbar(
                        title: "${status!.code}! ${status!.message}",
                        backgroundColor: accentColor1,
                        message: status!.data,
                        duration: const Duration(seconds: 3),
                      ).show(context);

                      if (status!.code == 200) {
                        Get.back();
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
