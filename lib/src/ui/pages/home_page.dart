part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CitraService>? services;
  int selectedService = 0;
  String serviceString = "";
  int? selectedId;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getService();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        _buildHeader(context),
        //120 height header
        Container(
          width: size.width,
          margin: const EdgeInsets.only(top: 80),
          height: size.height - 140,
          child: Column(
            children: [
              _buildMenuCard(size, context),
              Expanded(
                child: (!isLoading)
                    ? Column(
                        children: [
                          _buildByService(size),
                          Expanded(
                            child: _buildPartnerByService(),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      )
                    : Center(
                        child: loadingIndicator,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    UserState state = context.read<UserCubit>().state;
    return Container(
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.all(kDefaultMargin / 2),
      decoration: BoxDecoration(
        color: accentColor1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (state is UserLoaded)
              ? CircleAvatar(
                  backgroundColor: accentColor2,
                  radius: 24,
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: whiteColor,
                    backgroundImage: NetworkImage(
                      storageUrl + state.user.picturePath,
                    ),
                  ),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 30,
                  color: whiteColor,
                ),
          SizedBox(
            width: kDefaultMargin / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, Welcome",
                style: whiteTextFont,
              ),
              Text(
                (state is UserLoaded) ? "${(state).user.name}" : "Guest",
                maxLines: 2,
                style:
                    whiteTextFont.copyWith(fontSize: 16, fontWeight: semiBold),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              Get.to(() => RiwayatPage());
            },
            color: whiteColor,
            icon: Icon(Icons.history),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(Size size, BuildContext context) {
    UserState state = context.read<UserCubit>().state;
    _menuCard(String title, IconData iconsCard) {
      return Container(
        width: size.width / 3 - (kDefaultMargin / 2 + 12),
        margin: EdgeInsets.symmetric(
            horizontal: kDefaultMargin / 2, vertical: kDefaultMargin / 3),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: accentColor2,
          borderRadius: BorderRadius.circular(kDefaultRadius),
          border: Border.all(color: accentColor3),
        ),
        child: Column(
          children: [
            Icon(
              iconsCard,
              size: 24,
              color: accentWhite1,
            ),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: whiteTextFont.copyWith(fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Container(
      width: size.width,
      // height: ,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => ChatbotPage());
            },
            child: _menuCard('Chatbot', Icons.psychology),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => QuestionPage());
            },
            child: _menuCard('Question', Icons.quiz),
          ),
          GestureDetector(
            onTap: () {
              if (state is UserLoaded) {
                Get.to(() => ClientPage(user: state.user));
              } else {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Login terlebih dahulu"),
                    content: Text(
                        "Untuk melakukan pendaftaran c  lient, harap register atau login menggunakan akun anda"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'No'),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => LoginPage()),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: _menuCard('Daftar Klien', Icons.app_registration),
          ),
        ],
      ),
    );
  }

  Widget _buildByService(Size size) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: kDefaultMargin / 2, vertical: kDefaultMargin / 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Choose by Service",
                style: blackTextFont.copyWith(
                  fontSize: 18,
                  fontWeight: medium,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => ListServicePage());
                },
                child: Text(
                  "See All",
                  style: accentTextFont.copyWith(
                    fontSize: 12,
                    fontWeight: light,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          width: size.width,
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              CitraService citraService = services![index];
              return CustomServiceCard(
                text: citraService.name,
                onTap: () {
                  setState(() {
                    selectedService = index;
                    selectedId = citraService.id;
                    serviceString = citraService.name;
                  });
                },
                isSelected: selectedService == index,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: kDefaultMargin / 3,
              );
            },
            itemCount: services!.length,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          serviceString,
          style: blackTextFont.copyWith(fontSize: 16, fontWeight: light),
        ),
      ],
    );
  }

  Widget _buildPartnerByService() {
    return BlocBuilder<CitraPartnerCubit, CitraPartnerState>(
      builder: (context, state) {
        if (state is AllPartnerLoaded) {
          var data = state.allCitraPartner
              .where((element) => element.service.id == selectedId)
              .toList();
          if (data.isNotEmpty) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomPartnerCard(
                  partner: data[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: kDefaultMargin / 2,
                );
              },
            );
          } else {
            return Text("Data Konsultant Kosong :(");
          }
        } else {
          return Center(
            child: loadingIndicator,
          );
        }
      },
    );
  }

  Future<void> getService() async {
    services = await context.read<CitraServiceCubit>().getService();
    await context.read<CitraPartnerCubit>().getAllPartner();
    setState(() {
      selectedId = services![0].id;
      serviceString = services![0].name;
      isLoading = false;
    });
  }
}
