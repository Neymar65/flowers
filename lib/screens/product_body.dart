import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/category_body.dart';

import 'package:http/http.dart' as http;

class ProductBody extends StatefulWidget {
  final int? id;
  const ProductBody({super.key, this.id});

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {
  Future<ProductModel> getProduct() async {
    final uri = Uri.parse('https://fakestoreapi.com/products/${widget.id}');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final product = ProductModel.fromJson(responseBody);
        return product;
      } else {
        throw Exception('status code is not equal to 200');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('status code is not equal to 200');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.hasData) {
              final product = snapshot.data;
              return Text(product?.title ?? '');
            }

            return const SizedBox();
          }),
    );
  }
}
