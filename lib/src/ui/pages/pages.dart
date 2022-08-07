import 'dart:async';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as GetTransition;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_citra/src/cubit/cubit.dart';
import 'package:project_citra/src/cubit/page_cubit.dart';
import 'package:project_citra/src/cubit/session_chat_cubit.dart';
import 'package:project_citra/src/models/models.dart';
import 'package:project_citra/src/shared/shared.dart';
import 'package:project_citra/src/ui/widgets/widgets.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../services/services.dart';

part 'splash_screen.dart';

part 'start_page.dart';

part 'main_page.dart';

part 'login_page.dart';

part 'register_page.dart';

part 'home_page.dart';

part 'more_page.dart';

part 'detail_expert_page.dart';

part 'detail_chat_page.dart';

part 'list_service_page.dart';

part 'list_partner_page.dart';

part 'init_chat_page.dart';

part 'payment_method_page.dart';

part 'riwayat_page.dart';

part 'list_room_chat_page.dart';

part 'chatbot_page.dart';

part 'edit_profile_page.dart';

part 'about_citra_page.dart';
part 'forgot_password_page.dart';
part 'change_password_page.dart';
part 'client_page.dart';
part 'question_page.dart';
