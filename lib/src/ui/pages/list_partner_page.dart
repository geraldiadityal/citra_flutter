part of 'pages.dart';

class ListPartnerPage extends StatelessWidget {
  final CitraService selectedService;

  const ListPartnerPage({Key? key, required this.selectedService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: whiteColor,
          padding: EdgeInsets.all(kDefaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomHeader(titleHeader: selectedService.name),
              Expanded(
                child: BlocBuilder<CitraPartnerCubit, CitraPartnerState>(
                  builder: (context, state) {
                    if (state is AllPartnerLoaded) {
                      var data = state.allCitraPartner
                          .where((element) =>
                              element.service.id == selectedService.id)
                          .toList();
                      if (data.isNotEmpty) {
                        return ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CustomPartnerCard(
                              partner: data[index],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: kDefaultMargin / 2,
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: Text(
                            "Partner belum ada",
                            style: blackTextFont.copyWith(
                                fontSize: 18, fontWeight: semiBold),
                          ),
                        );
                      }
                    } else {
                      return loadingIndicator;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
