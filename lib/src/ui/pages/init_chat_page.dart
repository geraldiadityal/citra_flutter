part of 'pages.dart';

class InitChatPage extends StatefulWidget {
  final CitraPartner partner;

  const InitChatPage({
    Key? key,
    required this.partner,
  }) : super(key: key);

  @override
  State<InitChatPage> createState() => _InitChatPageState();
}

class _InitChatPageState extends State<InitChatPage> {
  bool isLoading = false;
  bool isFinish = false;

  String oldPayment = "";
  List<Transaction>? oldTransaction;
  String buttonText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MainPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: accentColor1,
        body: SafeArea(
          child: Container(
            color: whiteColor,
            padding: EdgeInsets.all(kDefaultMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context),
                Expanded(
                  child: (isFinish)
                      ? _buildBody(context)
                      : Center(
                          child: loadingIndicator,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    UserState state = context.read<UserCubit>().state;
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.3,
          height: 140,
          margin: EdgeInsets.only(right: kDefaultMargin / 3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kDefaultRadius),
              image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    NetworkImage(storageUrl + widget.partner.user!.picturePath),
              )),
        ),
        Text(
          widget.partner.user!.name,
          style: blackTextFont.copyWith(
              fontSize: 18, fontWeight: medium, letterSpacing: 1.2),
        ),
        Text(
          widget.partner.service.name,
          style: greyTextFont.copyWith(
              fontSize: 16, fontWeight: medium, letterSpacing: 0.5),
        ),
        Text(
          NumberFormat.currency(
                  locale: 'id-ID', symbol: 'Rp ', decimalDigits: 0)
              .format(widget.partner.price),
          style: accentTextFont.copyWith(letterSpacing: 2),
        ),
        (oldTransaction != null)
            ? Column(
                children: [
                  Text(
                    convertDateTime(oldTransaction![0].dateTime),
                    style: greyTextFont,
                  ),
                  Text(
                    (oldTransaction![0].session != null)
                        ? "You need another session consulting ?"
                        : (oldTransaction![0].status ==
                                TransactionStatus.success)
                            ? "You have an success transaction"
                            : (oldTransaction![0].status ==
                                    TransactionStatus.pending)
                                ? "You have an unpaid transaction\nFinish your payment"
                                : "",
                    textAlign: TextAlign.center,
                    style: blackTextFont,
                  )
                ],
              )
            : SizedBox(),
        CustomButton(
          onPressed: () async {
            if (state is UserLoaded) {
              setState(() {
                isLoading = true;
              });

              String? paymentURL;
              //handle unpaid transaction
              if (oldTransaction != null &&
                  oldTransaction![0]
                      .session!
                      .expired_at
                      .isAfter(DateTime.now())) {
                if (oldTransaction![0].status == TransactionStatus.success) {
                  context.read<PageCubit>().setPage(1);
                  Get.offAll(
                    () => const MainPage(),
                  );
                } else {
                  paymentURL = oldTransaction![0].paymentUrl;
                  Get.offAll(() => PaymentMethodPage(paymentURL: paymentURL!));
                }
              } else {
                //new payment
                paymentURL =
                    await context.read<TransactionCubit>().submitTransaction(
                          widget.partner,
                          state.user,
                        );
                TransactionState tranState =
                    context.read<TransactionCubit>().state;
                if (paymentURL != null && tranState is TransactionLoaded) {
                  Get.offAll(() => PaymentMethodPage(paymentURL: paymentURL!));
                } else if (tranState is TransactionLoadingFailed) {
                  setState(() {
                    isLoading = false;
                  });
                  Get.snackbar("", "",
                      backgroundColor: accentColor1,
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      titleText: Text(
                        'Transaksi Gagal dibuat',
                        style: whiteTextFont,
                      ),
                      messageText: Text(
                        tranState.message,
                        style: whiteTextFont,
                      ));
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  Get.snackbar("", "",
                      backgroundColor: accentColor1,
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      titleText: Text(
                        'Transaction Failed',
                        style: whiteTextFont,
                      ),
                      messageText: Text(
                        'Please try again later.',
                        style: whiteTextFont,
                      ));
                }
              }
            } else {
              Get.to(() => LoginPage());
            }
          },
          isLoading: isLoading,
          textButton: (state is UserLoaded) ? buttonText : 'Login Now',
          colorBtn: (state is UserLoaded) ? accentColor4 : accentColor2,
          btnWidth: size.width / 2,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: kDefaultMargin),
      child: GestureDetector(
        onTap: () {
          Get.offAll(
            () => MainPage(),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_back_ios),
            Expanded(
              child: Text(
                'Payment',
                style:
                    blackTextFont.copyWith(fontSize: 18, fontWeight: semiBold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkTransactions() async {
    if (User.token != null) {
      List<Transaction> data = await context
          .read<TransactionCubit>()
          .getTransactionsByStatus(partnerId: widget.partner.id);

      if (data.isNotEmpty) {
        oldTransaction = data;
        oldTransaction = oldTransaction!.reversed.toList();
        buttonText = "Pay Now";
        setState(() {
          isFinish = true;
        });
      } else {
        data = await context.read<TransactionCubit>().getTransactionsByStatus(
            status: "PENDING", partnerId: widget.partner.id);
        if (data.isNotEmpty) {
          oldTransaction = data;
          oldTransaction = oldTransaction!.reversed.toList();
          buttonText = "Pay Now";
        } else {
          data = await context.read<TransactionCubit>().getTransactionsByStatus(
              status: "SUCCESS", partnerId: widget.partner.id);
          if (data.isNotEmpty) {
            oldTransaction = data;
            if (oldTransaction![0].session != null) {
              if (oldTransaction![0]
                  .session!
                  .expired_at
                  .isBefore(DateTime.now())) {
                buttonText = "Checkout";
              } else {
                buttonText = "Chat Now";
              }
            }
          } else {
            oldTransaction = null;
            buttonText = "Checkout";
          }
        }
        setState(() {
          isFinish = true;
        });
      }
    }
    setState(() {
      isFinish = true;
    });
  }
}
