import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PriceField extends StatelessWidget {
  const PriceField({super.key, required this.label, required this.onChanged, required this.initialValue});

  final String label;
  final void Function(int) onChanged;
  final int? initialValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextFormField(
        decoration: InputDecoration(
          prefixText: 'R\$ ',
          border: const OutlineInputBorder(),
          isDense: true,
          labelText: label,
        ),
        inputFormatters: [
          //permite apenas números
          FilteringTextInputFormatter.digitsOnly,
          //formata o valor para real
          RealInputFormatter(),
        ],
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 16),
        onChanged: (text) {
          onChanged(int.tryParse(text.replaceAll('.', '')) ?? 0);
        },
        initialValue: initialValue?.toString(),
      ),
    );
  }
}
