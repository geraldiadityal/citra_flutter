part of 'pages.dart';

class DetailExpertPage extends StatefulWidget {
  final CitraService citraService;

  const DetailExpertPage({
    Key? key,
    required this.citraService,
  }) : super(key: key);

  @override
  State<DetailExpertPage> createState() => _DetailExpertPageState();
}

class _DetailExpertPageState extends State<DetailExpertPage> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: accentWhite1,
          padding: EdgeInsets.all(kDefaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(titleHeader: widget.citraService.name),
              Expanded(
                child: _buildCard(),
              ),
              Center(
                child: _buildGotoChat(widget.citraService.id),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    List<String> listQuestion = [
      "${widget.citraService.name} 1",
      "${widget.citraService.name} 2",
      "${widget.citraService.name} 3",
    ];
    return Container(
      margin: EdgeInsets.all(kDefaultMargin / 2),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(kDefaultRadius),
        border: Border.all(color: accentColor1),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: listQuestion
            .map(
              (e) => _buildQueCard(e),
            )
            .toList(),
      ),
    );
  }

  Widget _buildQueCard(
    String question,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: kDefaultMargin),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(
          color: isTapped ? accentColor1 : accentColor3,
        ),
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: ExpansionTile(
        title: Text(
          "Pertanyaan $question",
          style: blackTextFont.copyWith(fontSize: 18),
        ),
        children: [
          ListTile(
            title: Text(
              "Jawaban $question",
              style: blackTextFont,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGotoChat(int id) {
    return GestureDetector(
      onTap: () async {
        Future<List<CitraPartner>?> result =
            context.read<CitraPartnerCubit>().getPartnerWithService(id);
        List<CitraPartner>? partner = await result;
        // Get.to(() => ChatPage(partner!));
      },
      child: RichText(
        text: TextSpan(
          text: 'Langsung tanya ke konsultan ? ',
          style: greyTextFont.copyWith(
            fontSize: 14,
            fontWeight: semiBold,
          ),
          children: [
            TextSpan(
              text: "Disini",
              style: secondaryTextFont.copyWith(
                  fontSize: 14, fontWeight: semiBold),
            ),
          ],
        ),
      ),
    );
  }
}
