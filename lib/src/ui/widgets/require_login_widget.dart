part of 'widgets.dart';

class RequireLoginWidget extends StatelessWidget {
  const RequireLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login terlebih dahulu",
          style: blackTextFont.copyWith(fontSize: 18),
        ),
        CustomButton(
          onPressed: () {
            Get.to(() => const LoginPage());
          },
          textButton: 'Login',
          btnWidth: size.width * 0.5,
          colorBtn: accentColor2,
        ),
      ],
    );
  }
}
