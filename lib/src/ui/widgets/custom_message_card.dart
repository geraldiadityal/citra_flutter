part of 'widgets.dart';

class CustomMessageCard extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime time;

  const CustomMessageCard({
    Key? key,
    required this.text,
    this.isUser = true,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin:
              EdgeInsets.symmetric(vertical: kDefaultMargin / 4, horizontal: 8),
          padding: EdgeInsets.all(kDefaultMargin / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultRadius),
            color: isUser ? accentColor2 : accentColor4,
          ),
          constraints: BoxConstraints(
            minWidth: 20,
            maxWidth: size.width * 0.9,
          ),
          child: Column(
            crossAxisAlignment:
                (isUser) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: whiteTextFont.copyWith(
                  letterSpacing: 1.2,
                  fontSize: 16,
                  fontWeight: medium,
                ),
              ),
              Text(
                convertDateChat(time),
                style: primaryTextFont.copyWith(fontSize: 10),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
