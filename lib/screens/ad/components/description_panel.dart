import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../models/ad.dart';

class DescriptionPanel extends StatelessWidget {
  const DescriptionPanel({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18),
          child: Text(
            'Descrição',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: ReadMoreText(
            ad.description,
            trimLines: 3,
            //qtd de linhas que quero exibir
            trimMode: TrimMode.Line,
            //irá cortar na qtd informada acima
            trimCollapsedText: 'Ver descrição completa',
            trimExpandedText: '...menos',
            colorClickableText: Colors.purple,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
