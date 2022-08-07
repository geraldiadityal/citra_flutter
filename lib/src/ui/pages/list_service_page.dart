part of 'pages.dart';

class ListServicePage extends StatelessWidget {
  const ListServicePage({Key? key}) : super(key: key);

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
              CustomHeader(titleHeader: 'Our Services'),
              Expanded(
                child: BlocBuilder<CitraServiceCubit, CitraServiceState>(
                  builder: (context, state) {
                    if (state is CitraServiceLoaded) {
                      var data = state.citraService;
                      return GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        crossAxisCount: 2,
                        children:
                            data.map((e) => _buildServiceCard(e)).toList(),
                      );
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

Widget _buildServiceCard(CitraService service) {
  return GestureDetector(
    onTap: () {
      Get.to(() => ListPartnerPage(
            selectedService: service,
          ));
    },
    child: Container(
      height: 120,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: accentColor2,
        border: Border.all(color: accentColor1),
        borderRadius: BorderRadius.circular(kDefaultRadius),
      ),
      child: Center(
        child: Text(
          service.name,
          textAlign: TextAlign.center,
          style: whiteTextFont.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    ),
  );
}
