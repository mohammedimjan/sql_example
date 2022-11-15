import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:sqflite_example/models/product_models.dart';
import 'package:sqflite_example/services/db_service.dart';

class AddEditProductPage extends StatefulWidget {
  const AddEditProductPage({Key? key, this.models, this.isEditMode = false})
      : super(key: key);
  final ProductModels? models;
  final bool isEditMode;

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  late ProductModels models;
  List<dynamic> categories = [];
  late DBService dbService;
  @override
  void initState() {
    super.initState();
    dbService = DBService();
    models = ProductModels(productName: "", categoryId: -1);

    if (widget.isEditMode) {
      models = widget.models!;
    }
    categories.add({"id": 1, "name": "T shirt"});
    categories.add({"id": 2, "name": "shirt"});
    categories.add({"id": 3, "name": "Jeans"});
    categories.add({"id": 4, "name": "Trousers"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? 'Edit Product' : 'AddProduct'),
      ),
      body: Form(
        key: globalKey,
        child: _formUI(),
      ),
      bottomNavigationBar: SizedBox(
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FormHelper.submitButton("Save", () {
              if (validateAndSave()) {
                if (widget.isEditMode) {
                  dbService.updateProduct(models);
                  FormHelper.showSimpleAlertDialog(
                    context,
                    "SQFlite ",
                    "Data Edited Sucssfully",
                    "ok",
                    () {
                      Navigator.pop(context);
                    },
                  );
                } else {
                  dbService.addProduct(models);
                  FormHelper.showSimpleAlertDialog(
                    context,
                    "SQFlite ",
                    "Data Added Sucssfully",
                    "ok",
                    () {
                      Navigator.pop(context);
                    },
                  );
                }
              }
            },
                borderRadius: 10,
                btnColor: Colors.green,
                borderColor: Colors.green),
            FormHelper.submitButton("Cancel", () {},
                borderRadius: 10,
                btnColor: Colors.grey,
                borderColor: Colors.grey),
          ],
        ),
      ),
    );
  }

  _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productName",
              "Product Name",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                models.productName = onSaved.toString().trim();
              },
              initialValue: models.productName,
              showPrefixIcon: true,
              prefixIcon: const Icon(Icons.text_fields),
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              prefixIconPaddingLeft: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: FormHelper.inputFieldWidgetWithLabel(
                    context,
                    "productPrice",
                    "Product Price",
                    "",
                    (onValidate) {
                      if (onValidate.isEmpty) {
                        return "* Required";
                      }
                      return null;
                    },
                    (onSaved) {
                      models.productPrice =
                          double.parse(onSaved.toString().trim());
                    },
                    initialValue: models.productName,
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.currency_bitcoin),
                    borderRadius: 10,
                    contentPadding: 15,
                    fontSize: 14,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    prefixIconPaddingLeft: 10,
                    isNumeric: true,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: FormHelper.dropDownWidgetWithLabel(
                    context,
                    " ProductCategory",
                    "--Select--",
                    models.categoryId,
                    categories,
                    (onChanged) {
                      models.categoryId = int.parse(onChanged);
                    },
                    (onValidate) {},
                    borderRadius: 10,
                    labelFontSize: 14,
                    paddingLeft: 0,
                    paddingRight: 0,
                    hintFontSize: 14,
                    showPrefixIcon: true,
                    prefixIcon: const Icon(Icons.category),
                    prefixIconPaddingLeft: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            FormHelper.inputFieldWidgetWithLabel(
              context,
              "productDesc",
              "Product Description",
              "",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return "* Required";
                }
                return null;
              },
              (onSaved) {
                models.productDesc = onSaved.toString().trim();
              },
              initialValue: models.productDesc ?? "",
              borderRadius: 10,
              contentPadding: 15,
              fontSize: 14,
              labelFontSize: 14,
              paddingLeft: 0,
              paddingRight: 0,
              isMultiline: true,
              multilineRows: 5,
            ),
            _picPicker(
              models.productPic ?? "",
              (file) => {
                setState(() {
                  models.productPic = file.path;
                })
              },
            ),
          ],
        ),
      ),
    );
  }

  _picPicker(
    String fileName,
    Function onFilePicked,
  ) {
    Future<XFile?> _imagefile;
    ImagePicker _picker = ImagePicker();

    return Column(
      children: [
        fileName != ""
            ? Image.file(
                File(fileName),
                width: 300,
                height: 300,
              )
            : SizedBox(
                child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/495px-No-Image-Placeholder.svg.png?20200912122019",
                  width: 300,
                  height: 300,
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.image,
                  size: 35,
                ),
                onPressed: () {
                  _imagefile = _picker.pickImage(source: ImageSource.gallery);
                  _imagefile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            ),
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                padding: EdgeInsets.all(0),
                icon: const Icon(
                  Icons.camera,
                  size: 35,
                ),
                onPressed: () {
                  _imagefile = _picker.pickImage(source: ImageSource.camera);
                  _imagefile.then((file) async {
                    onFilePicked(file);
                  });
                },
              ),
            )
          ],
        )
      ],
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
