import 'package:chitragupta/app/Home/home_bloc.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chitragupta/app/product/product_bloc.dart';

class ProductsPage extends StatefulWidget {
  final Repository repository;
  ProductsPage(this.repository);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}
class _ProductsPageState extends State<ProductsPage> {
  bool _loading = false;
  ProductBloc _bloc;
  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => _bloc,
            child: BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {

                },
                child: BlocBuilder<ProductBloc, ProductState>(
                    cubit: _bloc,
                    builder: (BuildContext context, ProductState state) {
                      return Container();
                    }
                )
            )
        )
    );
  }

}