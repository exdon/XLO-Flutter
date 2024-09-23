import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/category/category_screen.dart';
import 'package:xlo_mobx/stores/create_store.dart';

class CategoryField extends StatelessWidget {
  const CategoryField({super.key, required this.createStore});

  final CreateStore createStore;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(
        children: [
          ListTile(
            //quando tiver categoria selecionada, o title fica menor
            title: createStore.category == null
                ? const Text(
                    'Categoria *',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  )
                : const Text(
                    'Categoria *',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
            subtitle: createStore.category == null
                ? null
                : Text(
                    '${createStore.category?.description}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
            trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            onTap: () async {
              //Abrindo tela de Categorias e recuperando a categoria
              final categorySelected = await showDialog(
                context: context,
                barrierColor: Colors.purple,
                builder: (_) => CategoryScreen(
                  showAll: false,
                  selected: createStore.category,
                ),
              );
              if (categorySelected != null) {
                createStore.setCategory(categorySelected);
              }
            },
          ),
          if (createStore.categoryError != null)
            Container(
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.red)),
              ),
              padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
              child: Text(
                createStore.categoryError!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[500]!)),
              ),
            )
        ],
      );
    });
  }
}
