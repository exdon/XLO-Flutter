import 'dart:io';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/models/category.dart';
import 'package:xlo_mobx/models/user.dart';
import 'package:xlo_mobx/repositories/parse_errors.dart';
import 'package:xlo_mobx/repositories/table_keys.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

import '../models/ad.dart';
import 'package:path/path.dart' as path;

class AdRepository {
  // .:: Retorna uma lista de anúncios ::.
  Future<List<Ad>> getHomeAdList({
    required FilterStore filterStore,
    required String? search,
    required Category? category,
    required int? page,
  }) async {
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));

    try{
      //..: Adicionando filtros :..

      //trazendo dados do usuário vinculado ao anúncio
      queryBuilder.includeObject([keyAdOwner, keyAdCategory]);

      //filtro para páginar anúncios
      queryBuilder.setAmountToSkip(page! * 2);

      // qtd de anúncios que queremos
      queryBuilder.setLimit(2);

      // anúncios somente com status ativo
      queryBuilder.whereEqualTo(keyAdStatus, AdStatus.ACTIVE.index);

      if (search != null && search.trim().isNotEmpty) {
        //filtrando a busca
        queryBuilder.whereContains(keyAdTitle, search, caseSensitive: false);
      }

      if (category != null && category.id != '*') {
        //filtrando por categoria
        queryBuilder.whereEqualTo(
          keyAdCategory,
          (ParseObject(keyCategoryTable)..set(keyCategoryId, category.id))
              .toPointer(),
        );
      }

      switch (filterStore.orderBy) {
        case OrderBy.PRICE:
        //ordena de forma ascendente pela coluna de preço
          queryBuilder.orderByAscending(keyAdPrice);
          break;
        case OrderBy.DATE:
        default:
        //ordena do mais recente para o mais antigo pela data de criação
          queryBuilder.orderByDescending(keyAdCreatedAt);
          break;
      }

      if (filterStore.minPrice != null && filterStore.minPrice! > 0) {
        //filtrando pelo preço minimo
        queryBuilder.whereGreaterThanOrEqualsTo(keyAdPrice, filterStore.minPrice);
      }

      if (filterStore.maxPrice != null && filterStore.maxPrice! > 0) {
        //filtrando pelo preço máximo
        queryBuilder.whereLessThanOrEqualTo(keyAdPrice, filterStore.maxPrice);
      }

      if (filterStore.vendorType != null &&
          filterStore.vendorType > 0 &&
          filterStore.vendorType <
              (VENDOR_TYPE_PROFESSIONAL | VENDOR_TYPE_PARTICULAR)) {
        //fitrando pelo tipo de vendedor
        final userQuery = QueryBuilder<ParseUser>(ParseUser.forQuery());

        if (filterStore.vendorType == VENDOR_TYPE_PARTICULAR) {
          userQuery.whereEqualTo(keyUserType, UserType.PARTICULAR.index);
        }

        if (filterStore.vendorType == VENDOR_TYPE_PROFESSIONAL) {
          userQuery.whereEqualTo(keyUserType, UserType.PROFESSIONAL.index);
        }

        queryBuilder.whereMatchesQuery(keyAdOwner, userQuery);
      }

      //trazendo anúncios baseado nos filtros
      final response = await queryBuilder.query();

      if (response.success && response.results != null) {
        return response.results!.map((po) => Ad.fromParse(po)).toList();
      } else if (response.success && response.results == null) {
        return [];
      } else {
        return Future.error(
            ParseErrors.getDescription(response.error!.code) as Object);
      }
    } catch(e) {
      return Future.error('Falha de conexão');
    }
  }

  // .:: Salva um anúncio ::.
  Future<void> save(Ad ad) async {
    try {
      //retorna lista de imagens do Parse
      final parseImages = await saveImages(ad.images);

      //obtendo usuario atual
      final parseUser = await ParseUser.currentUser() as ParseUser;

      //criando objeto de anuncio
      final adObject = ParseObject(keyAdTable);

      //verificando se o anúncio já existe
      if (ad.id != null) adObject.objectId = ad.id;

      //setando as permissões (se pode ler/escrever)
      //dono pode escever, resto pode ler
      final parseAcl =
          ParseACL(owner: parseUser); //somente esse user pode escrever
      parseAcl.setPublicReadAccess(allowed: true); //qualquer um pode ler
      parseAcl.setPublicWriteAccess(allowed: false);
      adObject.setACL(parseAcl);

      //setando dados do anúncio
      adObject.set<String>(keyAdTitle, ad.title);
      adObject.set<String>(keyAdDescription, ad.description);
      adObject.set<bool>(keyAdHidePhone, ad.hidePhone);
      adObject.set<num>(keyAdPrice, ad.price);
      adObject.set<int>(keyAdStatus, ad.status.index);
      //converte em index ficando:
      //PENDING = 0, ACTIVE = 1, SOLID = 2, DELETED = 3
      adObject.set<String>(keyAdDistrict, ad.address.district);
      adObject.set<String?>(keyAdCity, ad.address.city.name);
      adObject.set<String?>(keyAdFederativeUnit, ad.address.uf.initials);
      adObject.set<String>(keyAdPostalCode, ad.address.cep);
      adObject.set<List<ParseFile>>(keyAdImages, parseImages);
      adObject.set<ParseUser>(keyAdOwner, parseUser);

      //criando relação com objeto anúncio e objeto categoria
      //para facilitar buscar anúncios de uma categoria
      adObject.set<ParseObject>(keyAdCategory,
          ParseObject(keyCategoryTable)..set(keyCategoryId, ad.category.id));

      //salvando objeto no parse
      final response = await adObject.save();

      if (!response.success) {
        return Future.error(
            ParseErrors.getDescription(response.error!.code) as Object);
      }
    } catch (e) {
      return Future.error('Falha ao salvar anúncio');
    }
  }

  // .:: Salva imagens no Parse Server e retorna uma lista de imagens ::.
  Future<List<ParseFile>> saveImages(List images) async {
    final parseImages = <ParseFile>[];

    try {
      for (final image in images) {
        if (image is String) {
          // URL da imagem no Parse - Edição
          final parseFile = ParseFile(File(path.basename(image)));
          parseFile.name = path.basename(image);
          parseFile.url = image;
          parseImages.add(parseFile);
        } else {
          // salvando nova imagem no Parse Server
          final parseFile = ParseFile(image, name: path.basename(image.path));
          //name - nome do arquivo
          final response = await parseFile.save();
          if (!response.success) {
            return Future.error(
                ParseErrors.getDescription(response.error!.code) as Object);
          }
          // adicionando a lista
          parseImages.add(parseFile);
        }
      }

      return parseImages;
    } catch (e) {
      return Future.error('Falha ao salvar imagens');
    }
  }

  // .:: Retorna uma lista de anúncios do usuário informado ::.
  Future<List<Ad>> getMyAds(User user) async {
    final currentUser = ParseUser('', '', '')..set(keyUserId, user.id);
    final queryBuilder = QueryBuilder<ParseObject>(ParseObject(keyAdTable));

    //qtd de anúncios que quero retornar
    queryBuilder.setLimit(100);

    //ordenar em ordem descrescente por ordem de criação
    queryBuilder.orderByDescending(keyAdCreatedAt);

    // buscando anúncios do usuário informado
    queryBuilder.whereEqualTo(keyAdOwner, currentUser.toPointer());

    //traz os dados do anúncio + os dados do usuário que criou
    queryBuilder.includeObject([keyAdCategory, keyAdOwner]);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.map((po) => Ad.fromParse(po)).toList();
    } else if (response.success && response.results == null) {
      return [];
    } else {
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Marca um anúncio como status vendido ::.
  Future<void> sold(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);

    //mudando status para concluído/vendido
    parseObject.set(keyAdStatus, AdStatus.SOLD.index);

    final response = await parseObject.save();
    if(!response.success) {
      return Future.error(
        ParseErrors.getDescription(response.error!.code) as Object);
    }
  }

  // .:: Exluir um anúncio ::.
  Future<void> delete(Ad ad) async {
    final parseObject = ParseObject(keyAdTable)..set(keyAdId, ad.id);

    //mudando status para deletado
    parseObject.set(keyAdStatus, AdStatus.DELETED.index);

    final response = await parseObject.save();
    if(!response.success) {
      return Future.error(
          ParseErrors.getDescription(response.error!.code) as Object);
    }
  }
}
