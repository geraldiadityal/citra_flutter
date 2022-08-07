part of 'pages.dart';

class StartPage extends StatefulWidget {
  final List<CitraService>? services;

  const StartPage({
    Key? key,
    this.services,
  }) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  int _currentIndex = 0;

  List sceneList = [
    'assets/scene/start1.svg',
    'assets/scene/start2.svg',
    'assets/scene/start3.svg',
    'assets/scene/start4.svg',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: size.height,
          color: whiteColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(size),
              _buildSceneSlider(size),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    btnWidth: size.width / 2 - 36,
                    textButton: 'Sign Up',
                    colorBtn: accentWhite1,
                    colorFont: accentColor1,
                    onPressed: () {
                      Get.to(() => const RegisterPage());
                    },
                  ),
                  CustomButton(
                    btnWidth: size.width / 2 - 36,
                    textButton: 'Login',
                    onPressed: () {
                      Get.to(() => const LoginPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Column(
      children: [
        Container(
          width: size.width * 0.12,
          margin: EdgeInsets.only(top: kDefaultMargin / 2),
          child: Hero(
            tag: "logo",
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          "Citra Consulting",
          style: blackTextFont.copyWith(fontSize: 18, fontWeight: bold),
        ),
        Text(
          "We Glad to Alter Your Business",
          style: blackTextFont.copyWith(fontSize: 14, fontWeight: regular),
        ),
      ],
    );
  }

  Widget _buildSceneSlider(Size size) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "Our Services",
            style: blackTextFont.copyWith(
              fontSize: 14,
              fontWeight: semiBold,
            ),
          ),
          _buildServicesScene(size),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.services!.map(
              (e) {
                int index = widget.services!.indexOf(e);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? accentColor4 : accentColor3,
                  ),
                );
              },
            ).toList(),
          ),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              onPressed: () async {
                Get.offAll(
                  () => MainPage(),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Get Started",
                    style: whiteTextFont,
                  ),
                  const Icon(
                    Icons.arrow_forward,
                  ),
                ],
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(8),
                onPrimary: accentWhite1,
                primary: accentColor4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kDefaultRadius / 2)),
                // shape: const CircleBorder(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: kDefaultMargin),
            child: Text(
              "Kami siap bermitra dengan Perusahaan dalam menerapkan solusi yang aplikatif dan integratif sesuai kebutuhan dan demi kemajuan bisnis Perusahaan.",
              style: greyTextFont.copyWith(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesScene(Size size) {
    return CarouselSlider(
      items: widget.services?.map((e) {
        var index = widget.services?.indexOf(e);
        return Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                SvgPicture.asset(
                  sceneList[index! % 4],
                  fit: BoxFit.cover,
                  height: size.height * 0.32,
                ),
                Text(
                  e.name,
                  style: blackTextFont.copyWith(
                    fontSize: 16,
                    fontWeight: bold,
                  ),
                ),
              ],
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
          height: size.height * 0.4,
          enlargeCenterPage: true,
          viewportFraction: 1.2,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(seconds: 2),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: true,
          onPageChanged: (index, reason) {
            setState(() {
              _currentIndex = index;
            });
          }),
    );
  }
}
