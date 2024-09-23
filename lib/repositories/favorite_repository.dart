import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';

import '../models/ad.dart';

class FavoriteRepository {
  // .:: Retorna os anúncios favoritos do usuário salvos ::.
  Future<List<Ad>> getFavorites(User user) async {
    final queryBuilder =
        QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));

    // trazendo os anúncios do usuário
    queryBuilder.whereEqualTo(keyFavoritesOwner, user.id!);
    //trazendo os dados do anúncio e do dono do anúncio
    queryBuilder.includeObject([keyFavoritesAd, 'ad.owner']);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!
          .map((po) => Ad.fromParse(po.get(keyFavoritesAd)))
          .toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Salva anúncios favoritos do usuário ::.
  Future<void> save({required Ad ad, required User user}) async {
    final favoritesObject = ParseObject(keyFavoritesTable);

    //setando usuário que está favoritindo o anúncio
    favoritesObject.set<String>(keyFavoritesOwner, user.id!);

    //Criando relação entre a tabela de favoritos com a tabela de anúncios
    favoritesObject.set<ParseObject>(
        keyFavoritesAd, ParseObject(keyAdTable)..set(keyAdId, ad.id));

    final response = await favoritesObject.save();

    if (!response.success) {
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Remove anúncios favoritos do usuário ::.
  Future<void> delete({required Ad ad, required User user}) async {
    try {
      final queryBuilder =
          QueryBuilder<ParseObject>(ParseObject(keyFavoritesTable));

      // trazendo os anúncios do usuário
      queryBuilder.whereEqualTo(keyFavoritesOwner, user.id!);

      // pegando o anúncio que deseja remover
      queryBuilder.whereEqualTo(
          keyFavoritesAd, ParseObject(keyAdTable)..set(keyAdId, ad.id));

      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        for (final f in response.results as List<ParseObject>) {
          await f.delete();
        }
      }
    } catch (e) {
      return Future.error('Falha ao deletar favorito! erro: $e');
    }
  }
}
