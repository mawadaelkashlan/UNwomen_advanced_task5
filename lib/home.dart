import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products =[];
  bool isLoading = false;
  @override
  void initState() {
    initList();
    super.initState();
  }

  void initList()async{
    setState(() {
      isLoading = true;
    });
    var result = await rootBundle.loadString('assets/products.json');
    var response = jsonDecode(result);
    if (response['success']) {
      products = response['data'];
    } else{
      print('Error : ${response['status_code'] ?? 'Unknown error'}');
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products',)),
      body:
          isLoading? const Center(child: CircularProgressIndicator(),):
      ListView(
        children: products.map((e)=> ListTile(
          leading: Container(
              height: 100,
              width: 100,
              child: Image.network(e['image'])),
          title:Text(e['name'] , style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),) ,
          subtitle: Text(e['description']),
        )).toList(),
      ) ,
    );
  }
}
