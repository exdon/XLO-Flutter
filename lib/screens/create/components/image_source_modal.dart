import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceModal extends StatelessWidget {
  const ImageSourceModal({super.key, required this.onImageSelected});

  final Function(File) onImageSelected;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(onPressed: getFromCamera, child: Text('Câmera')),
            TextButton(onPressed: getFromGallery, child: Text('Galeria')),
          ],
        ),
      );
    } else {
      //IOS
      return CupertinoActionSheet(
        title: const Text('Selecionar foto para o anúncio'),
        message: const Text('Escolha a origem da foto'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop, //Fechando modal
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.red),
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
              onPressed: getFromCamera, child: const Text('Câmera')),
          CupertinoActionSheetAction(
              onPressed: getFromGallery, child: const Text('Galeria')),
        ],
      );
    }
  }

  Future<void> getFromCamera() async {
    //Pegar foto da câmera
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if(pickedFile == null) return;
    final image = File(pickedFile.path);
    imageSelected(image);
  }

  Future<void> getFromGallery() async {
    //Pegar foto da Galeria
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile == null) return;
    final image = File(pickedFile.path);
    imageSelected(image);
  }

  Future<void> imageSelected(File image) async {
    //Cortando a imagem
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio:
          //formato do corte
          const CropAspectRatio(ratioX: 1, ratioY: 1), //formato quadrado
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar Imagem',
          toolbarColor: Colors.purple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(
          title: 'Editar Imagem',
          cancelButtonTitle: 'Cancelar',
          doneButtonTitle: 'Concluir',
        )
      ],
    );

    if(croppedFile == null) return;
    //Passando a imagem cortada
    onImageSelected(File(croppedFile.path));
  }
}
