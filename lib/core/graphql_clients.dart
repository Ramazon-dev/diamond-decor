import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final box = GetStorage();
final HttpLink httpLink = HttpLink(
  'https://crm.softcity.uz/graphql/',
);

ValueNotifier<GraphQLClient> clientAll = ValueNotifier(
  GraphQLClient(
    cache: GraphQLCache(
      store: InMemoryStore(),
    ),
    link: AuthLink(getToken: () async {
      String token = box.read("token");
      return "Bearer $token";
    }).concat(httpLink),
  ),
);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(
      store: InMemoryStore(),
    ),
  ),
);
