part of 'services.dart';

class TransactionServices {
  static Future<ApiReturnValue<List<Transaction>>> getTransactions(
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'transaction';

    var response = await client.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${User.token}"
      },
    );

    if (response.statusCode != 200) {
      return ApiReturnValue(
          message: 'Error ${response.statusCode}, Please try again');
    }
    var data = jsonDecode(response.body);

    List<Transaction> transactions =
        (data['data'] as Iterable).map((e) => Transaction.fromJson(e)).toList();

    return ApiReturnValue(value: transactions);
  }

  static Future<ApiReturnValue<List<Transaction>>> getTransactionsByStatus(
      {http.Client? client,
      required String transactionStatus,
      int? partnerId}) async {
    client ??= http.Client();
    String url = apiUrl +
        'transaction?status=$transactionStatus' +
        ((partnerId) != null ? "&partner_id=$partnerId" : "");

    var response = await client.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${User.token}"
      },
    );

    if (response.statusCode != 200) {
      return ApiReturnValue(
          message: 'Error ${response.statusCode}, Please try again');
    }
    var data = jsonDecode(response.body)['data'];

    List<Transaction> transactions =
        (data as Iterable).map((e) => Transaction.fromJson(e)).toList();

    return ApiReturnValue(value: transactions);
  }

  static Future<ApiReturnValue<Transaction>> submitTransaction(
      CitraPartner partner, User user,
      {http.Client? client}) async {
    client ??= http.Client();

    String url = apiUrl + 'checkout';

    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.token}"
        },
        body: jsonEncode(
          <String, dynamic>{
            'partner_id': partner.id,
            'user_id': user.id,
            'total': partner.price,
            'status': "UNPAID",
          },
        ));

    if (response.statusCode != 200) {
      return ApiReturnValue(message: jsonDecode(response.body)['data']);
    }
    var data = jsonDecode(response.body);
    Transaction value = Transaction.fromJson(data['data']);

    return ApiReturnValue(value: value);
  }
}
