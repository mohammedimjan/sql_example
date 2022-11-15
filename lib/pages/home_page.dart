import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/list_helper.dart';
import 'package:sqflite_example/services/db_service.dart';

import '../models/product_models.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DBService dbService = DBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: const Text("Flutter SQFLite Crud"),
      ),
      body: _fetchData(),
    );
  }

  _fetchData() {
    return FutureBuilder<List<ProductModels>>(
      future: dbService.getProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModels>> products) {
        if (products.hasData) {
          return _buildDataTable(products.data!);
        } else {
          return const Center(child: Text("No data"));
        }
      },
    );
  }

  _buildDataTable(List<ProductModels> models) {
    return ListUtils.buildDataTable(
        context,
        ['Product Name', 'Price', ''],
        ["productName", "productPrice", ""],
        false,
        0,
        models,
        (ProductModels) {},
        (ProductModels) {},
        headingRowColor: Colors.orangeAccent,
        isScrollable: true,
        columnTextFontSize: 15,
        columnTextBold: false,
        columnSpacing: 50,
        onSort: (columIndex, columnName, asc) {});
  }
}
