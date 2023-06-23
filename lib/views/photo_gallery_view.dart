// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/bloc/app_bloc.dart';
import 'package:note_app/views/main_popup_menu_button.dart';
import 'package:note_app/views/storage_images_view.dart';

class PhotoGalleryView extends HookWidget {
  const PhotoGalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Photo gallery',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              }
              context.read<AppBloc>().add(
                    AppEventUploadImage(
                      filPathUpload: image.path,
                    ),
                  );
            },
            icon: const Icon(Icons.upload_rounded),
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(8.0),
        crossAxisSpacing: 20.0,
        mainAxisSpacing: 20.0,
        crossAxisCount: 2,
        children: images
            .map(
              (img) => StorageImageView(
                image: img,
              ),
            )
            .toList(),
      ),
    );
  }
}
