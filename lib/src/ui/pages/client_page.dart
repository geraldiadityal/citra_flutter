part of 'pages.dart';

class ClientPage extends StatefulWidget {
  final User user;
  final bool fromUser;
  final CitraService? service;

  const ClientPage({
    Key? key,
    required this.user,
    this.fromUser = true,
    this.service,
  }) : super(key: key);

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  bool isSubmit = false;
  CitraService? selectedValue;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    CitraServiceState serviceState = context.read<CitraServiceCubit>().state;

    return Scaffold(
      backgroundColor: accentColor1,
      body: SafeArea(
        child: Container(
          width: size.width,
          color: accentWhite1,
          height: size.height,
          padding: EdgeInsets.all(kDefaultMargin),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomHeader(titleHeader: "Daftar Client"),
              Container(
                width: size.width,
                margin: EdgeInsets.only(
                    bottom: kDefaultMargin, top: kDefaultMargin / 2),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/scene/client.svg",
                    fit: BoxFit.cover,
                    height: size.height * 0.17,
                  ),
                ),
              ),
              Text(
                "Nama Klien\t\t: ${widget.user.name}",
                style: blackTextFont,
              ),
              Text(
                (widget.user.companyName == "PRIBADI")
                    ? ""
                    : "Perusahaan\t: ${widget.user.companyName}",
                style: blackTextFont,
              ),
              (serviceState is CitraServiceLoaded)
                  ? (widget.fromUser)
                      ? Container(
                          width: size.width,
                          padding: EdgeInsets.all(kDefaultMargin / 3),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            border: Border.all(color: accentColor1),
                            borderRadius: BorderRadius.circular(kDefaultRadius),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                                hint: Text(
                                  "Select Service",
                                  style: blackTextFont,
                                ),
                                dropdownColor: whiteColor,
                                value: selectedValue,
                                style: blackTextFont,
                                onChanged: (CitraService? value) {
                                  setState(() {
                                    selectedValue = value;
                                  });
                                },
                                items: serviceState.citraService
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList()),
                          ),
                        )
                      : Text(
                          "Service : ${widget.service!.name}",
                          style: blackTextFont,
                        )
                  : SizedBox(),
              SizedBox(
                height: kDefaultMargin / 2,
              ),
              TextFormField(
                controller: descriptionController,
                style: blackTextFont,
                minLines: 1,
                maxLines: 5,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.text,
                enabled: !isSubmit,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(kDefaultMargin / 2),
                  fillColor: whiteColor,
                  filled: true,
                  isCollapsed: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentColor2, width: 2),
                    borderRadius: BorderRadius.circular(kDefaultRadius),
                  ),
                  hintText: "Description",
                  hintStyle: greyTextFont,
                ),
              ),
              Text(
                (widget.fromUser)
                    ? (isSubmit)
                        ? "Pendaftaran Selesai, Informasi lebih lanjut akan kami hubungin melalui E-Mail"
                        : "Tuliskan pengerjaan apa yang anda inginkan?"
                    : (isSubmit)
                        ? "Pendaftaran berhasil dilakukan"
                        : "Isikan Description perngerjaan yang diinginkan oleh User",
                style: greyTextFont.copyWith(fontSize: 12),
              ),
              Visibility(
                visible: !isSubmit,
                child: CustomButton(
                  textButton: "Submit",
                  isLoading: isLoading,
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      if (descriptionController.text.length < 1) {
                        throw 'Description harap diisi';
                      }
                      if (widget.fromUser) {
                        if (selectedValue == null) {
                          throw 'Harap diisi bidang jasa';
                        }
                      }
                      bool isSuccess;
                      if (descriptionController.text.length <= 1) {
                        throw 'Isikan data description dengan benar';
                      }
                      if (widget.fromUser) {
                        isSuccess = await CitraServiceServices.createClient(
                            user_id: widget.user.id!,
                            services_id: selectedValue!.id,
                            desc: descriptionController.text);
                      } else {
                        isSuccess = await CitraServiceServices.createClient(
                            user_id: widget.user.id!,
                            services_id: widget.service!.id,
                            desc: descriptionController.text);
                      }
                      if (!isSuccess) {
                        throw 'Harap Hubungin Admin';
                      }
                      setState(() {
                        isSubmit = true;
                        isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        isLoading = false;
                      });
                      await Flushbar(
                        title: 'Daftar Client gagal',
                        backgroundColor: accentColor1,
                        message: e.toString(),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  },
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
