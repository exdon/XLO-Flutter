import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/custom_drawer/custom_drawer.dart';
import 'package:xlo_mobx/components/empty_card.dart';
import 'package:xlo_mobx/stores/home_store.dart';

import '../filter/components/create_ad_button.dart';
import 'components/ad_tile.dart';
import 'components/search_dialog.dart';
import 'components/top_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeStore homeStore = GetIt.I<HomeStore>();

  final ScrollController scrollController = ScrollController();

  openSearch(BuildContext context) async {
    //abre campo de pesquisa e retorna conteúdo digitado
    final search = await showDialog(
        context: context,
        builder: (_) => SearchDialog(
              //setando o conteúdo pesquisado atual
              currentSearch: homeStore.search,
            ));
    //setando o conteúdo pesquisado
    if (search != null) homeStore.setSearch(search);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: Observer(
            builder: (_) {
              if (homeStore.search.isEmpty) return Container();
              return GestureDetector(
                //para permitir editar o texto digitado
                onTap: () => openSearch(context),
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    //para permitir clicar em todo o conteudo e não somente no texto
                    return SizedBox(
                      width: constraints.biggest.width, //maior largura
                      child: Text(
                        homeStore.search,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          backgroundColor: Colors.purple,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Observer(builder: (_) {
              if (homeStore.search.isEmpty) {
                return IconButton(
                  onPressed: () {
                    openSearch(context);
                  },
                  icon: const Icon(Icons.search),
                );
              }
              return IconButton(
                onPressed: () {
                  //limpa o conteúdo pesquisado
                  homeStore.setSearch('');
                },
                icon: const Icon(Icons.close),
              );
            }),
          ],
        ),
        body: Column(
          children: [
            TopBar(),
            Expanded(
              child: Stack(
                children: [
                  Observer(builder: (_) {
                    if (homeStore.error != null) {
                      //Exibindo erro ao exibir anúncios
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.white,
                            size: 100,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ocorreu um erro!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      );
                    }
                    if (homeStore.showProgress) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    }
                    if (homeStore.adList.isEmpty) {
                      return const EmptyCard(
                          text: 'Nenhum anúncio encontrado!');
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemBuilder: (_, index) {
                        if (index < homeStore.adList.length) {
                          return AdTile(ad: homeStore.adList[index]);
                        }
                        homeStore.loadNextPage();
                        return const SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.purple),
                          ),
                        );
                      },
                      itemCount: homeStore.itemCount,
                    );
                  }),
                  Positioned(
                    bottom: -50,
                    left: 0,
                    right: 0,
                    child: CreateAdButton(scrollController: scrollController),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
