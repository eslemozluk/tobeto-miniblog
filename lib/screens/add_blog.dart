import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  XFile? selectedImage;

  String title = '';
  String content = '';
  String author = '';

//image pickerı kullanmak için _picker oluşturmalıyız.
//pickımage asenkrondur bu durumu await edip senkron haline getirmeliyiz.
  openImagePicker() async {
    XFile? selectedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = selectedFile;
    });
  }

  submitForm() async {
    Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");
    var request = http.MultipartRequest("POST", url);

    if (selectedImage != null) {
      request.files
          .add(await http.MultipartFile.fromPath("File", selectedImage!.path));
    }

    request.fields['Title'] = title;
    request.fields['Content'] = content;
    request.fields['Author'] = author;

    final response = await request.send();

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    }
  }

//kullanıcının seçtiği dosyayı hafızada tutmak için xfile değişkene ata
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Blog Ekle"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
            key: _formkey,
            child: ListView(
              children: [
                if (selectedImage != null)
                  Image.file(
                    File(selectedImage!.path),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ElevatedButton(
                    onPressed: () {
                      openImagePicker();
                    },
                    child: const Text("resim seç")),
                TextFormField(
                    decoration:
                        const InputDecoration(label: Text("Blog Başlığı")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen Başlık Giriniz";
                      }
                      return null;
                    },
                    onSaved: (newValue) => title = newValue!),
                TextFormField(
                    maxLines: 5,
                    decoration:
                        const InputDecoration(label: Text("Blog içeriği")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lütfen İçerik Giriniz";
                      }
                      return null;
                    },
                    onSaved: (newValue) => content = newValue!),
                TextFormField(
                    decoration: const InputDecoration(label: Text(" Ad Soyad")),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "lütfen Ad Soyad Giriniz.";
                      }
                      return null;
                    },
                    onSaved: (newValue) => author = newValue!),
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        if (selectedImage == null) {
                          return;
                        }
                        _formkey.currentState!.save();
                        submitForm();
                      }
                    },
                    child: const Text("Gönder")),
              ],
            )),
      ),
    );
  }
}
