import 'package:flutter/material.dart';

import '../../../models/ad.dart';

class LocationPanel extends StatelessWidget {
  const LocationPanel({super.key, required this.ad});

  final Ad ad;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 18, bottom: 12),
          child: Text(
            'Localização',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CEP'),
                  SizedBox(height: 12),
                  Text('Município'),
                  SizedBox(height: 12),
                  Text('Bairro'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${ad.address.cep}'),
                    const SizedBox(height: 12),
                    Text('${ad.address.city.name}'),
                    const SizedBox(height: 12),
                    Text('${ad.address.district}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
