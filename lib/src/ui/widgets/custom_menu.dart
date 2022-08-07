part of 'widgets.dart';

class CustomMenu extends StatelessWidget {
  final Menu menu;

  const CustomMenu({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: menu.onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(kDefaultMargin / 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(menu.iconData),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultMargin / 2),
                child: Text(
                  menu.text,
                  style: blackTextFont.copyWith(
                    fontWeight: semiBold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
