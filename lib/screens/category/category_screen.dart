import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:xlo_mobx/components/error_box.dart';
import 'package:xlo_mobx/stores/category_store.dart';

import '../../models/category.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, this.selected, this.showAll = true});

  final Category? selected;
  final bool showAll;

  final CategoryStore categoryStore = GetIt.I<CategoryStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Categorias',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.fromLTRB(32, 12, 32, 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          child: Observer(builder: (_) {
            if (categoryStore.error != null) {
              return ErrorBox(message: categoryStore.error);
            } else if (categoryStore.categoryList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final categories = showAll
                  ? categoryStore.allCategoryList
                  : categoryStore.categoryList;

              return ListView.separated(
                itemBuilder: (_, index) {
                  final category = categories[index];

                  return InkWell(
                    onTap: () {
                      //Sai da tela de Categorias com a categoria selecionada
                      Navigator.of(context).pop(category);
                    },
                    child: Container(
                      height: 50,
                      color: category.id == selected?.id
                          ? Colors.purple.withAlpha(50)
                          : null,
                      alignment: Alignment.center,
                      child: Text(
                        category.description!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: category.id == selected?.id
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return const Divider(height: 0.1, color: Colors.grey);
                },
                itemCount: categories.length,
              );
            }
          }),
        ),
      ),
    );
  }
}
