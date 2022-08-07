import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/services/services.dart';
import 'package:project_citra/src/shared/shared.dart';
import 'package:project_citra/src/ui/pages/pages.dart';

part 'custom_button.dart';

part 'custom_textfield.dart';

part 'custom_question_card.dart';

part 'custom_navbar_clipper.dart';

part 'custom_header.dart';

part 'custom_menu.dart';

part 'custom_service_card.dart';

part 'custom_partner_card.dart';

part 'custom_chat_card.dart';

part 'require_login_widget.dart';

part 'custom_message_card.dart';

part 'custom_bottom_item.dart';

class Menu {
  final IconData iconData;
  final String text;
  final Function() onPressed;

  Menu({
    required this.iconData,
    required this.text,
    required this.onPressed,
  });
}
