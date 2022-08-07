import 'dart:convert';
import 'dart:io';

import 'package:project_citra/src/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'user_services.dart';
part 'citra_service_services.dart';
part 'citra_partner_services.dart';
part 'transaction_services.dart';
part 'pusher_message_services.dart';
part 'session_chat_services.dart';
part 'prefs_helper.dart';

String baseUrl = 'YOUR URL';

String apiUrl = baseUrl + 'api/';
String storageUrl = baseUrl + 'storage/';

String tokenPusher = "YOUR TOKEN PUSHER";

String beamId = "YOUR BEAM ID";
String beamsKeys = "YOUR BEAM KEYS";
