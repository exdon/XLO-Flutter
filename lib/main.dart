import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:xlo_mobx/screens/base/base_screen.dart';
import 'package:xlo_mobx/stores/category_store.dart';
import 'package:xlo_mobx/stores/connectivity_store.dart';
import 'package:xlo_mobx/stores/favorite_store.dart';
import 'package:xlo_mobx/stores/home_store.dart';
import 'package:xlo_mobx/stores/page_store.dart';
import 'package:xlo_mobx/stores/user_manager_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeParse();
  setupLocators();
  runApp(const MyApp());
}

void setupLocators() {
  //Registrando o PageStore como Singleton
  //para que não possa existir mais de uma instância do PageStore na aplicação
  GetIt.I.registerSingleton(ConnectivityStore());
  GetIt.I.registerSingleton(PageStore());
  GetIt.I.registerSingleton(HomeStore());
  //GetIt - Com ele você pode adicionar um objeto
  // e depois recuperar esse objeto adicionado em qualquer lugar da sua aplicação.
  GetIt.I.registerSingleton(UserManagerStore());
  GetIt.I.registerSingleton(CategoryStore());
  GetIt.I.registerSingleton(FavoriteStore());
}

Future<void> initializeParse() async {
  // .:: Inicializando o Parse Server ::.
  await Parse().initialize(
    'e8qQ7faFo14EgowkVkxoJo9p3ZhS68Qei98J75Nb',
    'https://parseapi.back4app.com/',
    clientKey: 'bVvF8RvhCEOw2AMtG5K5IV5r5O9VpB4ssw5Zy7CN',
    autoSendSessionId: true, //identificação do usuário
    debug: true, //mostrará tudo que é feito no console
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XLO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.purple,
      ),
      supportedLocales: const [
        //quais linguas o app suporta
        Locale('pt', 'BR')
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: BaseScreen(),
    );
  }
}

// .:: --- Explicação do Parse --- ::.

// // .:: Inicializando o Parse Server ::.
// await Parse().initialize(
//     'e8qQ7faFo14EgowkVkxoJo9p3ZhS68Qei98J75Nb',
//     'https://parseapi.back4app.com/',
//   clientKey: 'bVvF8RvhCEOw2AMtG5K5IV5r5O9VpB4ssw5Zy7CN',
//   autoSendSessionId: true, //identificação do usuário
//   debug: true, //mostrará tudo que é feito no console
// );

// .:: Criando um objeto ::.
//ParseObject é uma linha de uma tabela (Class)
// ParseObject(nome da tabela)
// final category = ParseObject('Categories')
// //setando dados dentro da tabela
// // set<Tipo do Objeto>(Coluna, valor da coluna)
// ..set<String>('Title', 'Meias')
// //inserindo mais dados
// ..set<int>('Position', 1);
//
//
// //Enviando objeto criado para o Parse Server
// // e pegando o resultado (se foi sucesso ou não)
// final response = await category.save();
//
// //imprimindo o resultado de sucesso
// print(response.success);

// // .:: Atualizando informações de um objeto existente ::.
// final category = ParseObject('Categories')
// //especificando o id do objeto a ser alterado
// ..objectId = '1s18ghlNly'
// //alterando o dado
// ..set<int>('Position', 3);
//
// // Salvando o novo dado no Parse Server
// final response = await category.save();
//
// //imprimindo o resultado
// print(response.success);

// // .:: Removendo um objeto ::.
// final category = ParseObject('Categories')
// //especificando o id do objeto a ser removido
// ..objectId = '1s18ghlNly';
//
// //Removendo objeto no Parse Server
// category.delete();

//.:: Lendo informações de um objeto ::.
// .getObject(id do objeto)
// final response = await ParseObject('Categories').getObject('l948CTHBsN');
// if(response.success) {
//   // Caso tenha encontrado o objeto, imprime o objeto
//   print(response.result);
// }

// .:: lendo todas as categorias ::.
// final response = await ParseObject('Categories').getAll();
// if(response.success) {
//   // imprimindo cada um dos objetos
//   for(final object in response.result) {
//     print(object);
//   }
// }

// .:: Retornando dados específicos ::.

// final query = QueryBuilder(ParseObject('Categories'));

// paramêtros de busca
// apenas as categorias que posição seja igual a 2
//.whereEqualTo(Coluna, condição(valor))
// query.whereEqualTo('Position', 2); //onde position é igual a 2

//categorias que tenham a palavra Blusa no título
// query.whereContains('Title', 'Blusa');

//.:: Concatenando queries ::.
//trazer somentes categorias que tenham a palavra Blusa no título
// e que a posição seja igual a 2
// query.whereContains('Title', 'Blusa');
// query.whereEqualTo('Position', 2);

// .:: Executando query ::.
// final response = await query.query();

// if(response.success) {
//   //imprimindo resultado da query
//   print(response.result);
// }
