part of 'pages.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrans();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserState userState = context.read<UserCubit>().state;
    CitraPartnerState partnerState = context.read<CitraPartnerCubit>().state;
    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          color: whiteColor,
          width: size.width,
          padding: EdgeInsets.all(kDefaultMargin),
          child: Column(
            children: [
              const CustomHeader(
                titleHeader: "Riwayat Transaksi",
              ),
              Expanded(
                child: (userState is UserLoaded)
                    ? BlocBuilder<TransactionCubit, TransactionState>(
                        builder: (context, state) {
                          if (state is TransactionLoaded) {
                            var transaction = state.transactions;
                            if (transaction.isNotEmpty) {
                              if (partnerState is AllPartnerLoaded) {
                                return ListView.separated(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var data = transaction[index];
                                    var partner = partnerState.allCitraPartner
                                        .where((element) =>
                                            element.id == data.partner_id)
                                        .toList();

                                    var status = (data.status ==
                                            TransactionStatus.success)
                                        ? "Berhasil dibayar"
                                        : (data.status ==
                                                TransactionStatus.pending)
                                            ? "Belum dibayar"
                                            : (data.status ==
                                                    TransactionStatus.finish)
                                                ? "Selesai"
                                                : "Expire";
                                    return Container(
                                      width: size.width,
                                      padding: const EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: greyColor),
                                        borderRadius: BorderRadius.circular(
                                            kDefaultRadius),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "Transaksi ${data.id}\n",
                                                      style: blackTextFont,
                                                      children: [
                                                TextSpan(
                                                  text: partner[0].user!.name +
                                                      "\n",
                                                  style: blackTextFont.copyWith(
                                                      fontWeight: bold,
                                                      letterSpacing: 1.2),
                                                ),
                                                TextSpan(
                                                  text:
                                                      partner[0].service.name +
                                                          "\n",
                                                  style:
                                                      accentTextFont.copyWith(
                                                          fontWeight: bold,
                                                          letterSpacing: 1.2),
                                                ),
                                                TextSpan(
                                                    text: status,
                                                    style: blackTextFont),
                                              ]))),
                                          (data.status ==
                                                      TransactionStatus
                                                          .finish ||
                                                  data.status ==
                                                      TransactionStatus
                                                          .success ||
                                                  data.status ==
                                                      TransactionStatus.expire)
                                              ? const SizedBox()
                                              : GestureDetector(
                                                  onTap: () {
                                                    Get.offAll(() =>
                                                        PaymentMethodPage(
                                                            paymentURL: data
                                                                .paymentUrl));
                                                  },
                                                  child: Container(
                                                    width: 75,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kDefaultRadius),
                                                      color: accentColor4,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Bayar",
                                                        style: whiteTextFont,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: kDefaultMargin / 3,
                                    );
                                  },
                                  itemCount: transaction.length,
                                );
                              } else {
                                return SizedBox();
                              }
                            } else {
                              return Center(
                                child: Text(
                                  "Kamu belum melakukan transaksi",
                                  style: blackTextFont,
                                ),
                              );
                            }
                          } else {
                            return loadingIndicator;
                          }
                        },
                      )
                    : const RequireLoginWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getTrans() async {
    if (User.token != null) {
      await context.read<TransactionCubit>().getTransactions();
    }
  }
}
