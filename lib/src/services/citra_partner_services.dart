part of 'services.dart';

class CitraPartnerServices {
  static Future<ApiReturnValue<List<CitraPartner>>> getPartner(
      {http.Client? client}) async {
    client ??= http.Client();

    String url = apiUrl + 'partners';
    try {
      var response = await client.get(Uri.parse(url));

      if (response.statusCode != 200) {
        return ApiReturnValue(message: 'Failed to get Data');
      }
      var data = jsonDecode(response.body)['data']['data'];

      List<CitraPartner> listPartner =
          (data as Iterable).map((e) => CitraPartner.fromJson(e)).toList();
      return ApiReturnValue(value: listPartner);
    } catch (e) {
      return ApiReturnValue(message: e.toString());
    }
  }

  static Future<ApiReturnValue<List<CitraPartner>>> getPartnerByService(int id,
      {http.Client? client}) async {
    client ??= http.Client();

    String url = apiUrl + 'partners?service_id=$id';
    var response = await client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Failed to get Data');
    }
    var data = jsonDecode(response.body)['data'];

    List<CitraPartner> listPartner =
        (data[1] as Iterable).map((e) => CitraPartner.fromJson(e)).toList();

    return ApiReturnValue(value: listPartner);
  }
}
