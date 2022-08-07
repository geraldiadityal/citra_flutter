part of 'widgets.dart';

class CustomServiceCard extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Function onTap;

  const CustomServiceCard(
      {Key? key,
      required this.isSelected,
      required this.text,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: 96,
        padding: EdgeInsets.all(kDefaultMargin / 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultRadius),
          border: Border.all(
            color: isSelected ? whiteColor : accentColor4,
          ),
          color: isSelected ? accentColor4 : whiteColor,
        ),
        child: Center(
          child: Text(
            text,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: ((isSelected) ? whiteTextFont : blackTextFont)
                .copyWith(fontSize: 9, fontWeight: light),
          ),
        ),
      ),
    );
  }
}
