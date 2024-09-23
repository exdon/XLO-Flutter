import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/screens/account/account_screen.dart';
import 'package:xlo_mobx/screens/create/create_screen.dart';
import 'package:xlo_mobx/screens/favorites/favorites_screen.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';

import '../../stores/page_store.dart';
import '../home/home_screen.dart';
import '../offline/offline_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  //Pegando a instância do PageStore registrada no GetIt
  final PageStore pageStore = GetIt.I<PageStore>();

  final ConnectivityStore connectivityStore = GetIt.I<ConnectivityStore>();

  @override
  void initState() {
    super.initState();

    //reaction precisamos informar duas funções
    // 1º serve para monitorar algum valor
    //2º é o efeito/ação que ela irá fazer, recebendo como param o valor monitorado na 1º função
    reaction((_) => pageStore.page, (page) {
      // toda vez que o page(pagina) for alterada
      //essa função aqui será chamada recebendo o valor atual (page)

      //mudando para página recebida
      pageController.jumpToPage(page);
    });
    //reaction ao contrário do autorun, não executa inicialmente
    //ele espera ter uma troca de valor/estado para ser executada
    // no caso, quando tiver uma troca no valor monitorado

    autorun((_) {
      if (!connectivityStore.connected) {
        Future.delayed(const Duration(milliseconds: 50)).then((value) {
          showDialog(context: context, builder: (_) => const OfflineScreen());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        // não permite arrastar para mudar de tela
        children: [
          const HomeScreen(),
          const CreateScreen(),
          Container(color: Colors.yellow),
          FavoritesScreen(),
          const AccountScreen(),
        ],
      ),
    );
  }
}
