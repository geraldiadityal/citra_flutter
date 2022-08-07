part of 'pages.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  List<CitraService>? services;
  List<QuestionCitraService>? question;
  List<QuestionCitraService>? filterQuestion;

  int selectedService = 0;
  String serviceString = "";
  int? selectedId;
  bool isLoading = true;

  Future<void> getService() async {
    services = await context.read<CitraServiceCubit>().getService();
    question = await CitraServiceServices.getQuestion();

    setState(() {
      selectedId = services![0].id;
      serviceString = services![0].name;
      filterQuestion = question!
          .where((element) => element.services_id == selectedId)
          .toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getService();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          color: whiteColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultMargin, vertical: kDefaultMargin / 2),
                child: CustomHeader(
                  titleHeader: "Question",
                ),
              ),
              Expanded(
                child: (!isLoading)
                    ? ListView(
                        children: [
                          Container(
                            width: size.width,
                            height: 48,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                CitraService citraService = services![index];
                                return CustomServiceCard(
                                  text: citraService.name,
                                  onTap: () {
                                    setState(() {
                                      selectedService = index;
                                      selectedId = citraService.id;
                                      serviceString = citraService.name;
                                      filterQuestion = question!
                                          .where((element) =>
                                              element.services_id == selectedId)
                                          .toList();
                                    });
                                  },
                                  isSelected: selectedService == index,
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(
                                  width: kDefaultMargin / 3,
                                );
                              },
                              itemCount: services!.length,
                            ),
                          ),
                          (filterQuestion!.length >= 1)
                              ? Column(
                                  children: filterQuestion!
                                      .map((e) => CustomQuestionCard(
                                            question: e,
                                          ))
                                      .toList(),
                                )
                              : Center(
                                  child: Text(
                                    "Data Kosong",
                                    style: blackTextFont,
                                  ),
                                ),
                        ],
                      )
                    : loadingIndicator,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
