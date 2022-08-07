part of 'pages.dart';

class PaymentMethodPage extends StatefulWidget {
  final String paymentURL;

  const PaymentMethodPage({
    Key? key,
    required this.paymentURL,
  }) : super(key: key);

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }

    super.initState();
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.offAll(() => MainPage());
        return true;
      },
      child: Scaffold(
        backgroundColor: accentColor1,
        appBar: AppBar(
          title: Text(
            'Finish Your Payment',
            style: whiteTextFont,
          ),
          backgroundColor: accentColor1,
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Get.offAll(() => MainPage());
              },
              child: Text(
                'Finish',
                style: whiteTextFont,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            color: whiteColor,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      WebView(
                        initialUrl: widget.paymentURL,
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: (finish) {
                          setState(() {
                            isLoading = false;
                          });
                        },
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          _controller.complete(webViewController);
                        },
                      ),
                      isLoading
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loadingIndicator,
                                Text(
                                  "Sedang menyiapkan pembayaranmu",
                                  style: blackTextFont,
                                ),
                              ],
                            )
                          : Stack(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
