part of 'services.dart';

class SessionChatServices {
  static Future<ApiReturnValue<List<SessionChat>>> getSessionRoomChat(
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'session';

    var response = await client.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${User.token}"
      },
    );

    if (response.statusCode != 200) {
      return ApiReturnValue(
          message: 'Error ${response.statusCode}, ${response.body}');
    }
    var data = jsonDecode(response.body);

    List<SessionChat> sessions =
        (data['data'] as Iterable).map((e) => SessionChat.fromJson(e)).toList();

    return ApiReturnValue(value: sessions);
  }

  static Future<bool> endSessionChat({
    http.Client? client,
    required int sessionId,
  }) async {
    client ??= http.Client();
    String url = apiUrl + 'session';

    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.token}"
        },
        body: jsonEncode(
          <String, dynamic>{
            'id': sessionId,
          },
        ));

    if (response.statusCode != 200) {
      return false;
    }
    return true;
  }
}
