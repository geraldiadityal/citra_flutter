part of 'pages.dart';

class AboutCitraPage extends StatefulWidget {
  final int initPage;

  const AboutCitraPage({Key? key, this.initPage = 1}) : super(key: key);

  @override
  State<AboutCitraPage> createState() => _AboutCitraPageState();
}

class _AboutCitraPageState extends State<AboutCitraPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoading = true;

  List<Citra> link = [
    Citra(link: "https://citraalterindo.id/", title: "About Us"),
    Citra(
        link: "https://citraalterindo.id/index.php/serivices/",
        title: "Our Services"),
    Citra(
        link: "https://citraalterindo.id/index.php/our-team/",
        title: "Our Team"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: accentWhite1,
      appBar: AppBar(
        title: Text(
          link[widget.initPage - 1].title,
          style: whiteTextFont,
        ),
        backgroundColor: accentColor1,
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          color: whiteColor,
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebView(
                      initialUrl: link[widget.initPage - 1].link,
                      javascriptMode: JavascriptMode.unrestricted,
                      onPageFinished: (finish) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      onWebViewCreated: (WebViewController webViewController) {
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
                                "Mohon menunggu",
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
    );
  }
}

class Citra {
  final String title;
  final String link;

  Citra({required this.title, required this.link});
}
