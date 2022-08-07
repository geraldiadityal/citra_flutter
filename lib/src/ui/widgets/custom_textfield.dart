part of 'widgets.dart';

class CustomTextfield extends StatefulWidget {
  final String title;
  final double width;
  final double height;
  final int length;
  final TextEditingController controller;
  final Icon iconPrefix;
  final bool obsText;
  final bool isEnabled;
  final TextInputType inputType;

  const CustomTextfield({
    Key? key,
    required this.title,
    this.width = double.infinity,
    this.height = 60,
    required this.controller,
    required this.iconPrefix,
    this.obsText = false,
    this.inputType = TextInputType.text,
    this.isEnabled = true,
    this.length = 128,
  }) : super(key: key);

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.symmetric(vertical: kDefaultMargin / 3),
      child: TextFormField(
        style: blackTextFont,
        enabled: widget.isEnabled,
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.inputType,
        obscureText: widget.obsText,
        inputFormatters: [
          LengthLimitingTextInputFormatter(widget.length),
        ],
        decoration: InputDecoration(
          fillColor: (widget.isEnabled) ? whiteColor : greyColor,
          filled: true,
          prefixIcon: widget.iconPrefix,
          isCollapsed: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: greyColor),
            borderRadius: BorderRadius.circular(kDefaultRadius / 2),
          ),
          labelText: (widget.isEnabled) ? widget.title : "",
          labelStyle: greyTextFont.copyWith(fontSize: 18),
        ),
      ),
    );
  }
}
