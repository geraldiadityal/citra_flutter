part of 'widgets.dart';

class CustomPartnerCard extends StatelessWidget {
  final CitraPartner partner;

  const CustomPartnerCard({Key? key, required this.partner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isExpired = partner.active_at.isAfter(DateTime.now());
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.2,
      padding: EdgeInsets.only(right: 8),
      margin: EdgeInsets.symmetric(
          horizontal: kDefaultMargin / 2, vertical: kDefaultMargin / 3),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(color: accentColor1),
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width * 0.3,
            margin: EdgeInsets.only(right: kDefaultMargin / 3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultRadius),
                  bottomLeft: Radius.circular(kDefaultRadius),
                ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(storageUrl + partner.user!.picturePath),
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partner.user!.name,
                  style: blackTextFont.copyWith(fontSize: 18),
                ),
                Text(
                  partner.service.name,
                  style: greyTextFont.copyWith(fontSize: 14),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        NumberFormat.currency(
                                locale: 'id-ID',
                                symbol: 'Rp ',
                                decimalDigits: 0)
                            .format(partner.price),
                        style: accentTextFont.copyWith(letterSpacing: 2),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (isExpired) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                "Konsultan sedang sibuk",
                                style: blackTextFont.copyWith(
                                    fontWeight: semiBold),
                              ),
                              content: Text(
                                "Silahkan pilih konsultan lain\n${partner.user!.name} sedang menangani konsultasi lain dan perkiraan selesai pada " +
                                    convertDateTime(partner.active_at),
                                style: blackTextFont.copyWith(
                                    fontWeight: light, fontSize: 14),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Ok'),
                                  child: const Text('Ok'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          Get.to(() => InitChatPage(partner: partner));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: (isExpired) ? accentColor1 : accentColor4,
                        onPrimary: whiteColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kDefaultRadius * 2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                              (isExpired)
                                  ? Icons.do_not_disturb_on_total_silence
                                  : Icons.chat,
                              color: accentColor2),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            (isExpired) ? "Busy" : "Chat",
                            style: whiteTextFont,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
