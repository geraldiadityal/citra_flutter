part of 'widgets.dart';

class CustomAddRemove extends StatelessWidget {
  final bool isAdd;
  final Function() onTap;

  const CustomAddRemove({
    Key? key,
    this.isAdd = true,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: (isAdd) ? accentColor2 : accentColor4),
          borderRadius: BorderRadius.circular(kDefaultRadius / 2),
        ),
        child: Icon(
          (isAdd) ? Icons.add : Icons.remove,
          size: 32,
          color: (isAdd) ? accentColor4 : accentColor2,
        ),
      ),
    );
  }
}
