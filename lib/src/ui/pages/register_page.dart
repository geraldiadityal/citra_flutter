part of 'pages.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late User userRegister;
  StatusCompany? _statusCompany = StatusCompany.company;
  bool isLoading = false;
  File? pictureFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    companyController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: accentWhite1,
          padding: EdgeInsets.all(kDefaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(titleHeader: "Register as a User"),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          XFile? pickedFile = await _picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            pictureFile = File(pickedFile.path);
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          margin: EdgeInsets.only(
                              top: kDefaultMargin / 3,
                              bottom: kDefaultMargin / 2),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/photo_border.png'))),
                          child: (pictureFile != null)
                              ? Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(pictureFile!),
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage('assets/photo.png'),
                                          fit: BoxFit.cover)),
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Perusahaan'),
                                Radio<StatusCompany>(
                                  value: StatusCompany.company,
                                  groupValue: _statusCompany,
                                  onChanged: (StatusCompany? value) {
                                    setState(() {
                                      _statusCompany = value;
                                      companyController.text = "";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Pribadi'),
                                Radio<StatusCompany>(
                                  value: StatusCompany.pribadi,
                                  groupValue: _statusCompany,
                                  onChanged: (StatusCompany? value) {
                                    setState(() {
                                      _statusCompany = value;
                                      companyController.text = "Pribadi";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CustomTextfield(
                        isEnabled: (_statusCompany == StatusCompany.pribadi)
                            ? false
                            : true,
                        controller: companyController,
                        title: "Company Name",
                        length: 64,
                        iconPrefix: const Icon(Icons.store),
                      ),
                      CustomTextfield(
                        controller: nameController,
                        title: "Your Full Name",
                        inputType: TextInputType.name,
                        length: 32,
                        iconPrefix: const Icon(Icons.person),
                      ),
                      CustomTextfield(
                        controller: emailController,
                        title: "Your Email Address",
                        length: 80,
                        inputType: TextInputType.emailAddress,
                        iconPrefix: const Icon(Icons.email),
                      ),
                      CustomTextfield(
                        controller: passController,
                        title: "Your Password",
                        obsText: true,
                        length: 64,
                        iconPrefix: const Icon(Icons.lock),
                      ),
                      CustomTextfield(
                        controller: phoneController,
                        title: "Your Phone Number",
                        inputType: TextInputType.phone,
                        length: 16,
                        iconPrefix: const Icon(Icons.phone),
                      ),
                      CustomButton(
                        textButton: "Continue",
                        isLoading: isLoading,
                        onPressed: () async {
                          if ((emailController.text.length >= 1 &&
                                  emailValidator(emailController.text)) &&
                              passController.text.length >= 8 &&
                              nameController.text.length >= 1 &&
                              companyController.text.length >= 1) {
                            register();
                            setState(() {
                              isLoading = false;
                            });
                          } else if (passController.text.length < 8) {
                            setState(() {
                              isLoading = false;
                            });
                            await Flushbar(
                              title: 'Password tidak memenuhi syarat',
                              backgroundColor: accentColor1,
                              message: "Password minimal memiliki 8 karakter",
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            await Flushbar(
                              title: 'Registrasi Gagal',
                              backgroundColor: accentColor1,
                              message: "Check your data for signup",
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async {
    setState(() {
      isLoading = true;
    });
    userRegister = User(
        name: nameController.text,
        email: emailController.text,
        roles: '',
        picturePath: '',
        companyName: companyController.text,
        phoneNumber: phoneController.text);
    await context.read<UserCubit>().registerUser(
        userRegister, passController.text,
        pictureFile: (pictureFile != null) ? pictureFile : null);

    UserState state = context.read<UserCubit>().state;
    if (state is UserLoaded) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      PrefsHelper(sharedPreferences: _prefs).setUserToken(User.token!);
      PrefsHelper(sharedPreferences: _prefs).setUserId(state.user.id!);
      await PusherBeams.instance.start(beamId);
      await PusherBeams.instance.addDeviceInterest("user.${state.user.id!}");
      Get.offAll(() => MainPage());
    } else {
      setState(() {
        isLoading = false;
      });
      await Flushbar(
        title: 'Register Gagal',
        backgroundColor: accentColor1,
        message: ((state as UserLoadingFailed).message),
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  bool emailValidator(String value) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
  }
}
