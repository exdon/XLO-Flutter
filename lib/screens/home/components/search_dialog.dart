import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {
  SearchDialog({super.key, required this.currentSearch})
      : controller = TextEditingController(text: currentSearch);

  final String currentSearch;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 2,
          left: 2,
          right: 2,
          child: Card(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                //centraliza o texto digitado
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: InputBorder.none,
                prefixIcon: IconButton(
                  onPressed: Navigator.of(context).pop,
                  icon: const Icon(Icons.arrow_back),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  //limpa o campo de pesquisa
                  onPressed: controller.clear,
                ),
              ),
              //add lupa de pesquisa no teclado
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                //Retornando para tela anterior com o texto digitado
                Navigator.of(context).pop(text);
              },
              autofocus: true,
            ),
          ),
        ),
      ],
    );
  }
}
