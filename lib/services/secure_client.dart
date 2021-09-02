//@dart=2.9
import 'package:ccarev2_frontend/cache/ilocal_store.dart';
import 'package:common/common.dart';

class SecureClient implements IHttpClient {
  final IHttpClient client;
  final ILocalStore store;
  SecureClient(this.client, this.store);

  @override
  Future<HttpResult> get(String url, {Map<String, String> headers}) async {
    final token = await store.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token.value;
    return await client.get(url, headers: modifiedHeader);
  }

  @override
  Future<HttpResult> post(String url, String body,
      {Map<String, String> headers}) async {
    final token = await store.fetch();
    final modifiedHeader = headers ?? {};
    modifiedHeader['Authorization'] = token.value;
    modifiedHeader['Content-Type'] = "application/json";
    return await client.post(url, body, headers: modifiedHeader);
  }
}
