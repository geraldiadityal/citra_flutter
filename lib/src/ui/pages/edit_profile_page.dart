part of 'pages.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? pictureFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController();

  TextEditingController companyController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserState state = context.read<UserCubit>().state;

    if (state is UserLoaded) {
      nameController.text = state.user.name;
      companyController.text = state.user.companyName;
      phoneController.text = state.user.phoneNumber;
    }

    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultMargin, vertical: kDefaultMargin / 2),
          color: whiteColor,
          child: Column(
            children: [
              const CustomHeader(titleHeader: "Edit Profile"),
              Expanded(
                child: SingleChildScrollView(
                  child: (state is UserLoaded)
                      ? Column(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              margin: EdgeInsets.only(
                                  top: kDefaultMargin / 3,
                                  bottom: kDefaultMargin / 2),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: (pictureFile != null)
                                    ? DecorationImage(
                                        image: FileImage(pictureFile!),
                                        fit: BoxFit.cover)
                                    : DecorationImage(
                                        image: NetworkImage(storageUrl +
                                            state.user.picturePath),
                                        fit: BoxFit.cover),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                XFile? pickedFile = await _picker.pickImage(
                                    source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  pictureFile = File(pickedFile.path);
                                  setState(() {});
                                }
                              },
                              child: Text("Change your photo"),
                            ),
                            SizedBox(height: kDefaultMargin),
                            CustomTextfield(
                              controller: nameController,
                              title: "Name",
                              iconPrefix: Icon(Icons.person),
                            ),
                            CustomTextfield(
                              controller: phoneController,
                              title: "Your Phone Number",
                              inputType: TextInputType.phone,
                              length: 16,
                              iconPrefix: const Icon(Icons.phone),
                            ),
                            CustomTextfield(
                              controller: companyController,
                              title: "Company Name",
                              length: 64,
                              iconPrefix: const Icon(Icons.store),
                            ),
                            CustomButton(
                              onPressed: () {
                                update();
                              },
                              isLoading: isLoading,
                              textButton: "Update Profile",
                              colorBtn: accentColor2,
                            ),
                          ],
                        )
                      : RequireLoginWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void update() async {
    setState(() {
      isLoading = true;
    });
    String msg = await context.read<UserCubit>().updateUser(
          name: nameController.text,
          companyName: companyController.text,
          phoneNumber: phoneController.text,
          pictureFile: pictureFile,
        );
    setState(() {
      isLoading = false;
    });
    await Flushbar(
      title: 'Your Profile',
      backgroundColor: accentColor1,
      message: msg,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
