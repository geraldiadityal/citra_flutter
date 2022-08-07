part of 'services.dart';

class PusherMessageServices {
  static Future<ApiReturnValue<List<PusherMessage>>> fetchMessage({
    http.Client? client,
    required int sessionChatId,
  }) async {
    client ??= http.Client();
    String url = apiUrl + 'chats?session_chat_id=$sessionChatId';

    var response = await client.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${User.token}"
      },
    );

    if (response.statusCode != 200) {
      return ApiReturnValue(
        message: 'Error ${response.statusCode}, Please Try Again',
      );
    }
    var data = jsonDecode(response.body)['data'];

    List<PusherMessage> message =
        (data as Iterable).map((e) => PusherMessage.fromFetchJson(e)).toList();
    return ApiReturnValue(value: message);
  }

  static Future<void> sendMessage(
      {http.Client? client,
      required String message,
      required int userId,
      required int sessionChatId}) async {
    client ??= http.Client();

    String url = apiUrl + 'send/$sessionChatId';

    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.token}",
        },
        body: jsonEncode(<String, String>{
          'message': message,
          'to_user': userId.toString(),
        }));
  }

  static Future<void> sendNotification({
    http.Client? client,
    required int toUser,
    required String title,
    required String body,
  }) async {
    client ??= http.Client();
    String url =
        "https://$beamId.pushnotifications.pusher.com/publish_api/v1/instances/$beamId/publishes";

    await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${beamsKeys}",
        },
        body: jsonEncode(<String, dynamic>{
          'interests': ["user.$toUser"],
          'fcm': {
            "notification": {
              "title": title,
              "body": body,
            }
          }
        }));
  }
}
