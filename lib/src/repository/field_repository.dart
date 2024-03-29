import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/field.dart';

Future<Stream<Field>> getFields() async {
  final String url = '${GlobalConfiguration().getValue('api_base_url')}fields?orderBy=updated_at&sortedBy=desc&onlyWithProducts=true';
print(Uri.parse(url));
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Field.fromJSON(data);
  });
}
