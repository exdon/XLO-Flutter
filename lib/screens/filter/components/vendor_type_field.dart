import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xlo_mobx/screens/filter/components/section_title.dart';
import 'package:xlo_mobx/stores/filter_store.dart';

class VendorTypeField extends StatelessWidget {
  const VendorTypeField({super.key, required this.filterStore});

  final FilterStore filterStore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionTitle(title: 'Tipo de anunciante'),
        Observer(builder: (_) {
          return Wrap(
            runSpacing: 4,
            children: [
              GestureDetector(
                onTap: () {
                  //lógica para ter os dois (particular e profissional) habilitados
                  // ou pelo menos um deles, onde ao deselecionar um, o outro é habilitado
                  if(filterStore.isTypeParticular) {
                    if(filterStore.isTypeProfessional) {
                      filterStore.resetVendorType(VENDOR_TYPE_PARTICULAR);
                    } else {
                      filterStore.setVendorType(VENDOR_TYPE_PROFESSIONAL);
                    }
                  } else {
                    //habilitando a opção particular
                    filterStore.setVendorType(VENDOR_TYPE_PARTICULAR);
                  }
                },
                child: Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: filterStore.isTypeParticular
                        ? Colors.purple
                        : Colors.transparent,
                    border: Border.all(
                      color: filterStore.isTypeParticular
                          ? Colors.purple
                          : Colors.grey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Particular',
                    style: TextStyle(
                      color: filterStore.isTypeParticular
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  //lógica para ter os dois (particular e profissional) habilitados
                  // ou pelo menos um deles, onde ao deselecionar um, o outro é habilitado
                  if(filterStore.isTypeProfessional) {
                    if(filterStore.isTypeParticular) {
                      filterStore.resetVendorType(VENDOR_TYPE_PROFESSIONAL);
                    } else {
                      filterStore.setVendorType(VENDOR_TYPE_PARTICULAR);
                    }
                  } else {
                    //habilitando a opção profissional
                    filterStore.setVendorType(VENDOR_TYPE_PROFESSIONAL);
                  }
                },
                child: Container(
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: filterStore.isTypeProfessional
                        ? Colors.purple
                        : Colors.transparent,
                    border: Border.all(
                      color: filterStore.isTypeProfessional
                          ? Colors.purple
                          : Colors.grey,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Profissional',
                    style: TextStyle(
                      color: filterStore.isTypeProfessional
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
