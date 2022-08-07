part of 'widgets.dart';

class CustomHeader extends StatelessWidget {
  final String titleHeader;
  final bool isBack;

  const CustomHeader({
    Key? key,
    required this.titleHeader,
    this.isBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultMargin),
      child: (isBack)
          ? GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back_ios),
                  Expanded(
                    child: Text(
                      titleHeader,
                      style: blackTextFont.copyWith(
                          fontSize: 18, fontWeight: semiBold),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                titleHeader,
                style:
                    blackTextFont.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
            ),
    );
  }
}
