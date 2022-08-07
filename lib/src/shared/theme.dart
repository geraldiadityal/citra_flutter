part of 'shared.dart';

const Color whiteColor = Color(0xffffffff);
Color blackColor = const Color(0xff000000);
Color greyColor = const Color(0xff999999);

const Color accentColor1 = Color(0xff14213d);
Color accentColor2 = const Color(0xfffca311);
Color accentColor3 = const Color(0xffA8DADC);
Color accentColor4 = const Color(0xffE63946);

Color accentWhite1 = const Color(0xffe5fcf5);

double kDefaultMargin = 24;
double kDefaultRadius = 16;

TextStyle defaultFont = GoogleFonts.poppins();
TextStyle blackTextFont = defaultFont.copyWith(
  color: blackColor,
);
TextStyle whiteTextFont = defaultFont.copyWith(
  color: whiteColor,
);
TextStyle greyTextFont = defaultFont.copyWith(
  color: greyColor,
);
TextStyle secondaryTextFont = defaultFont.copyWith(
  color: accentColor4,
);TextStyle accentTextFont = defaultFont.copyWith(
  color: accentColor2,
);
TextStyle primaryTextFont = defaultFont.copyWith(
  color: accentColor1,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;

Widget loadingIndicator = SpinKitFadingCircle(
  size: 45,
  color: accentColor1,
);
