part of 'widgets.dart';

class CustomButton extends StatelessWidget {
  final String textButton;
  final Function() onPressed;
  final double btnWidth;
  final double btnHeight;
  final Color colorBtn;
  final Color colorFont;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.textButton,
    required this.onPressed,
    this.btnWidth = double.infinity,
    this.btnHeight = 50,
    this.colorBtn = accentColor1,
    this.colorFont = whiteColor,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: btnWidth,
      height: btnHeight,
      margin: EdgeInsets.symmetric(vertical: kDefaultMargin),
      child: isLoading
          ? loadingIndicator
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: colorBtn,
                onPrimary: colorFont,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultRadius * 2),
                ),
              ),
              child: Text(
                textButton,
                style: defaultFont.copyWith(
                  fontSize: 16,
                  fontWeight: medium,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
  }
}
