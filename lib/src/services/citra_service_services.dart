part of 'services.dart';

class CitraServiceServices {
  static Future<ApiReturnValue<List<CitraService>>> getService(
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'services';

    try {
      var response = await client.get(
        Uri.parse(url),
      );

      if (response.statusCode != 200) {
        return ApiReturnValue(message: 'Failed to get Data');
      }
      var data = jsonDecode(response.body)['data'];

      List<CitraService> listService = (data['data'] as Iterable)
          .map((e) => CitraService.fromJson(e))
          .toList();

      return ApiReturnValue(value: listService);
    } catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  static Future<bool> createClient({
    http.Client? client,
    required int user_id,
    required int services_id,
    required String desc,
  }) async {
    client ??= http.Client();
    String url = apiUrl + 'clients';

    try {
      var response = await client.post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${User.token}"
          },
          body: jsonEncode(
            <String, dynamic>{
              'users_id': user_id,
              'services_id': services_id,
              'description': desc,
            },
          ));

      if (response.statusCode != 200) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<List<QuestionCitraService>?> getQuestion(
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'question';

    try {
      var response = await client.get(
        Uri.parse(url),
      );

      if (response.statusCode != 200) {
        return null;
      }
      var data = jsonDecode(response.body)['data'];

      List<QuestionCitraService> listQuestion = (data as Iterable)
          .map((e) => QuestionCitraService.fromJson(e))
          .toList();

      return listQuestion;
    } catch (e) {
      return null;
    }
  }
}
