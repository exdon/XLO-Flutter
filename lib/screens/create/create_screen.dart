import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:xlo_mobx/components/error_box.dart';
import 'package:xlo_mobx/models/ad.dart';
import 'package:xlo_mobx/screens/myads/my_ads_screen.dart';
import 'package:xlo_mobx/stores/create_store.dart';

import '../../components/custom_drawer/custom_drawer.dart';
import '../../stores/page_store.dart';
import 'components/category_field.dart';
import 'components/cep_field.dart';
import 'components/hide_phone_field.dart';
import 'components/images_field.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key, this.ad});

  final Ad? ad;

  @override
  State<CreateScreen> createState() => _CreateScreenState(ad);
}

class _CreateScreenState extends State<CreateScreen> {
  _CreateScreenState(Ad? ad)
      : editing = ad != null,
        createStore = CreateStore(ad);

  late CreateStore createStore;
  bool editing;

  @override
  void initState() {
    super.initState();

    when((_) => createStore.savedAd, () {
      //quando savedAd for verdade
      // aqui será chamado

      if (editing) {
        //Voltando para página de anúncios ativos
        Navigator.of(context).pop(true);
      } else {
        //Mudando de página para página de anúncios
        GetIt.I<PageStore>().setPage(0);
        //Navegando até a pagina de meus anúncios pendentes
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const MyAdsScreen(initialPage: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.grey,
      fontSize: 18,
    );

    const contentPadding = EdgeInsets.fromLTRB(16, 10, 12, 10);

    return Scaffold(
      drawer: editing ? null : const CustomDrawer(),
      appBar: AppBar(
        title: Text(
          editing ? 'Editar Anúncio' : 'Criar Anúncio',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            child: Observer(builder: (_) {
              if (createStore.loading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Salvando Anúncio',
                        style: TextStyle(fontSize: 18, color: Colors.purple),
                      ),
                      SizedBox(height: 16),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.purple),
                      ),
                    ],
                  ),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ImagesField(createStore: createStore),
                    Observer(builder: (_) {
                      return TextFormField(
                        initialValue: createStore.title,
                        onChanged: createStore.setTitle,
                        decoration: InputDecoration(
                          labelText: 'Título *',
                          labelStyle: labelStyle,
                          contentPadding: contentPadding,
                          errorText: createStore.titleError,
                        ),
                      );
                    }),
                    Observer(builder: (_) {
                      return TextFormField(
                        initialValue: createStore.description,
                        onChanged: createStore.setDescription,
                        decoration: InputDecoration(
                          labelText: 'Descrição *',
                          labelStyle: labelStyle,
                          contentPadding: contentPadding,
                          errorText: createStore.descriptionError,
                        ),
                        maxLines: null, //permite várias linhas
                      );
                    }),
                    CategoryField(createStore: createStore),
                    CepField(createStore: createStore),
                    Observer(builder: (_) {
                      return TextFormField(
                        initialValue: createStore.priceText,
                        onChanged: createStore.setPrice,
                        decoration: InputDecoration(
                          labelText: 'Preço *',
                          labelStyle: labelStyle,
                          contentPadding: contentPadding,
                          prefixText: 'R\$ ',
                          errorText: createStore.priceError,
                        ),
                        keyboardType: TextInputType.number,
                        //Formatando o campo de preço
                        inputFormatters: [
                          //só permite digitos
                          FilteringTextInputFormatter.digitsOnly,
                          // Formata valor para reais com centavos
                          CentavosInputFormatter(),
                        ],
                      );
                    }),
                    HidePhoneField(createStore: createStore),
                    Observer(builder: (_) {
                      return ErrorBox(message: createStore.error);
                    }),
                    Observer(builder: (_) {
                      return SizedBox(
                        height: 50,
                        child: GestureDetector(
                          //mostrar os erros do form
                          onTap: createStore.invalidSendPressed,
                          child: ElevatedButton(
                            onPressed: createStore.sendPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              disabledBackgroundColor:
                                  Colors.orange.withAlpha(120),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(0), // <-- Radius
                              ),
                            ),
                            child: const Text(
                              'Enviar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
