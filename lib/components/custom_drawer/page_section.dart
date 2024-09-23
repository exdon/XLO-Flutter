import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/custom_drawer/page_tile.dart';
import 'package:xlo_mobx/screens/login/login_screen.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

import '../../stores/page_store.dart';

class PageSection extends StatelessWidget {
  PageSection({super.key});

  //Pegando a instância do PageStore registrada no GetIt
  final PageStore pageStore = GetIt.I<PageStore>();
  final UserManagerStore userManagerStore = GetIt.I<UserManagerStore>();

  @override
  Widget build(BuildContext context) {
    Future<void> verifyLoginAndSetPage(int page) async {
      if (userManagerStore.isLoggedIn) {
        pageStore.setPage(page);
      } else {
        //caso não esteja logado
        final result = await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        if(result != null && result) pageStore.setPage(page);
      }
    }

    return Column(
      children: [
        PageTile(
          label: 'Anúncios',
          iconData: Icons.list,
          onTap: () {
            //Setando o índice da página atual
            pageStore.setPage(0);
          },
          highlighted: pageStore.page == 0, //se está selecionado ou não
        ),
        PageTile(
          label: 'Inserir Anúncio',
          iconData: Icons.edit,
          onTap: () {
            //Verificando se o usuário esta logado e
            //Setando o índice da página atual
            verifyLoginAndSetPage(1);
          },
          highlighted: pageStore.page == 1, //se está selecionado ou não
        ),
        PageTile(
          label: 'Chat',
          iconData: Icons.chat,
          onTap: () {
            //Verificando se o usuário esta logado e
            //Setando o índice da página atual
            verifyLoginAndSetPage(2);
          },
          highlighted: pageStore.page == 2, //se está selecionado ou não
        ),
        PageTile(
          label: 'Favoritos',
          iconData: Icons.favorite,
          onTap: () {
            //Verificando se o usuário esta logado e
            //Setando o índice da página atual
            verifyLoginAndSetPage(3);
          },
          highlighted: pageStore.page == 3, //se está selecionado ou não
        ),
        PageTile(
          label: 'Minha Conta',
          iconData: Icons.person,
          onTap: () {
            //Verificando se o usuário esta logado e
            //Setando o índice da página atual
            verifyLoginAndSetPage(4);
          },
          highlighted: pageStore.page == 4, //se está selecionado ou não
        ),
      ],
    );
  }
}
