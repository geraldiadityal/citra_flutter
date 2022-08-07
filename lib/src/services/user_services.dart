part of 'services.dart';

class UserServices {
  static Future<ApiReturnValue<User>> signUp(User user, String password,
      {http.Client? client, File? pictureFile}) async {
    client ??= http.Client();
    String url = apiUrl + 'register';
    var response = await client.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'name': user.name,
          'email': user.email,
          'password': password,
          'company_name': user.companyName,
          'phone_number': user.phoneNumber,
        }));
    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Error!! Please Try Again');
    }
    var data = jsonDecode(response.body);
    User.token = data['data']['access_token'];
    User value = User.fromJson(data['data']['user']);

    if (pictureFile != null) {
      ApiReturnValue<String> result = await uploadProfilePicture(pictureFile);
      if (result.value != null) {
        value = value.copyWith(picturePath: result.value!);
      }
    }
    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<User>> updateProfile({
    http.Client? client,
    File? pictureFile,
    required String name,
    required String companyName,
    required String phoneNumber,
  }) async {
    client ??= http.Client();
    String url = apiUrl + 'user';
    var response = await client.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + User.token!,
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'company_name': companyName,
          'phone_number': phoneNumber,
        }));
    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Error!! Please Try Again');
    }
    var data = jsonDecode(response.body);

    User value = User.fromJson(data['data']);

    if (pictureFile != null) {
      ApiReturnValue<String> result = await uploadProfilePicture(pictureFile);
      if (result.value != null) {
        value = value.copyWith(picturePath: result.value!);
      }
    }
    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<String>> uploadProfilePicture(File pictureFile,
      {http.MultipartRequest? request}) async {
    String url = apiUrl + 'user/photo';
    var uri = Uri.parse(url);

    request ??= http.MultipartRequest("POST", uri)
      ..headers["Content-Type"] = "application/json"
      ..headers["Authorization"] = "Bearer ${User.token}";

    var multipartFile =
        await http.MultipartFile.fromPath('file', pictureFile.path);
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);

      String imagePath = data['data'][0];

      return ApiReturnValue(value: imagePath);
    } else {
      return ApiReturnValue(message: 'Uploading Profile Picture Failed');
    }
  }

  static Future<ApiReturnValue<User>> signIn(String email, String password,
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'login';
    var response = await client.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));
    var data = jsonDecode(response.body);
    if (response.statusCode != 200) {
      return ApiReturnValue(
          message:
              data['data']['message'] + " Error Code:${response.statusCode}");
    }

    User.token = 'Bearer ' + data['data']['access_token'];
    User value = User.fromJson(data['data']['user']);
    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<User>> getUser(String token,
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'user';
    var response = await client.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token,
      },
    );
    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Error!! Please Try Again');
    }
    var data = jsonDecode(response.body)['data'];

    User value = User.fromJson(data);
    return ApiReturnValue(value: value);
  }

  static Future<ApiReturnValue<bool>> logoutUser(String token,
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'logout';
    var response = await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token,
      },
    );

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Error!! Please Try Again');
    }
    var data = jsonDecode(response.body)['data'];

    return ApiReturnValue(value: data);
  }

  static Future<StatusPassword> forgotPasswordUser(String email,
      {http.Client? client}) async {
    client ??= http.Client();
    String url = apiUrl + 'forgot-password';
    var response = await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    var data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return StatusPassword(
          message: data['meta']['message'],
          data: data['data'][0],
          code: response.statusCode);
    }

    return StatusPassword(
        message: data['meta']['message'],
        data: data['data'],
        code: response.statusCode);
  }

  static Future<StatusPassword> changePassword({
    http.Client? client,
    required String token,
    required String currentPassword,
    required String newPassword,
    required String passConfirm,
  }) async {
    client ??= http.Client();
    String url = apiUrl + 'change-password';
    var response = await client.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + token,
      },
      body: jsonEncode(<String, String>{
        'current-password': currentPassword,
        'new-password': newPassword,
        'new-password-confirm': passConfirm,
      }),
    );
    var data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      return StatusPassword(
          message: data['meta']['message'],
          data: 'Failed',
          code: response.statusCode);
    }

    return StatusPassword(
        message: data['meta']['message'],
        data: 'Success',
        code: response.statusCode);
  }
}
