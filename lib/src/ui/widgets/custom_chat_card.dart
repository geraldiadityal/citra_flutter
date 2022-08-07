part of 'widgets.dart';

class CustomChatCard extends StatefulWidget {
  final CitraPartner partner;
  final User user;
  final SessionChat sessionChat;

  const CustomChatCard({
    Key? key,
    required this.partner,
    required this.user,
    required this.sessionChat,
  }) : super(key: key);

  @override
  State<CustomChatCard> createState() => _CustomChatCardState();
}

class _CustomChatCardState extends State<CustomChatCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.sessionChat.transaction!.status ==
                TransactionStatus.success ||
            widget.sessionChat.transaction!.status ==
                TransactionStatus.finish) {
          Get.to(() => DetailChatPage(
                otherUser: widget.user,
                sessionChat: widget.sessionChat,
                service: widget.partner.service,
              ));
        } else if (widget.sessionChat.transaction!.status ==
            TransactionStatus.pending) {
          Get.to(() => InitChatPage(partner: widget.partner));
        }
      },
      child: Container(
        width: double.infinity,
        height: 80,
        margin: EdgeInsets.symmetric(horizontal: kDefaultMargin / 3),
        padding: EdgeInsets.symmetric(horizontal: kDefaultMargin / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultRadius),
          border: Border.all(color: greyColor),
          color: whiteColor,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    storageUrl + widget.user.picturePath,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: kDefaultMargin / 2),
                color: whiteColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.user.name,
                          style: blackTextFont,
                        ),
                        Text(
                          widget.partner.service.name,
                          style: greyTextFont.copyWith(fontSize: 12),
                        ),
                        Text(
                          (widget.sessionChat.messageSession != null)
                              ? widget.sessionChat.messageSession!.content
                              : "Mulailah konsultasi",
                          style: blackTextFont.copyWith(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                        (widget.sessionChat.messageSession != null)
                            ? convertTimeChat(
                                widget.sessionChat.messageSession!.created_at)
                            : "",
                        style: accentTextFont),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
