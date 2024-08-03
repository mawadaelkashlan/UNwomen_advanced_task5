import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = false;
  List<ValueNotifier<int>> productCounters = [];

  @override
  void initState() {
    initList();
    super.initState();
  }

  void initList() async {
    setState(() {
      isLoading = true;
    });
    var result = await rootBundle.loadString('assets/products.json');
    var response = jsonDecode(result);
    if (response['success']) {
      products = response['data'];
      // Initialize counters for each product
      productCounters =
          List.generate(products.length, (index) => ValueNotifier(0));
    } else {
      print('Error : ${response['status_code'] ?? 'Unknown error'}');
    }
    setState(() {
      isLoading = false;
    });
  }

  int getTotalItems() {
    return productCounters.fold(0, (sum, counter) => sum + counter.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: ValueNotifier(getTotalItems()),
          builder: (context, value, child) {
            return Text('Products - Total Items: $value');
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var e = products[index];
                return ListTile(
                  leading: Container(
                    height: 100,
                    width: 100,
                    child: Image.network(e['image']),
                  ),
                  title: Text(
                    e['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(e['description']),
                  trailing: ValueListenableBuilder<int>(
                    valueListenable: productCounters[index],
                    builder: (context, count, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              if (count > 0) {
                                productCounters[index].value--;
                              }
                            },
                          ),
                          Text('$count'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              productCounters[index].value++;
                            },
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
