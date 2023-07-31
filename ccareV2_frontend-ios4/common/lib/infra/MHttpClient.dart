import '../infra/IhttpClient_contract.dart';
import 'package:http/http.dart';

class MHttpClient implements IHttpClient {
  final Client client;

  MHttpClient(this.client);
  @override
  Future<HttpResult> get(String url, {Map<String, String>? headers}) async {
    final response = await client.get(Uri.parse(url), headers: headers);
    return _parseRespone(response);
  }

  @override
  Future<HttpResult> post(String url, String body,
      {Map<String, String>? headers}) async {
    final response =
        await client.post(Uri.parse(url), body: body, headers: headers);
    return _parseRespone(response);
  }

  HttpResult _parseRespone(Response response) {
    return HttpResult(response.body,
        response.statusCode == 200 ? HttpStatus.Success : HttpStatus.Failure);
  }
}
