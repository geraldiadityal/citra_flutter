part of 'widgets.dart';

class CustomBottomItem extends StatelessWidget {
  final String text;
  final IconData icon;
  bool isTap;
  final Function(int index) onTap;
  final int selectedIndex;

  CustomBottomItem({
    Key? key,
    required this.text,
    required this.icon,
    this.isTap = false,
    required this.onTap,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(selectedIndex);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: whiteColor,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: (isTap) ? accentColor2 : accentColor3,
            ),
            Text(
              text,
              style: ((isTap) ? primaryTextFont : greyTextFont).copyWith(
                  fontSize: 16, fontWeight: semiBold, letterSpacing: 1.2),
            ),
            (isTap)
                ? Divider(
                    height: 2,
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: accentColor4,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
