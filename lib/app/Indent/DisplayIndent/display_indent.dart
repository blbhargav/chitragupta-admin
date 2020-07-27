import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chitragupta/app/Indent/DisplayIndent/display_indent_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/product.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayIndent extends StatefulWidget {
  final Repository repository;
  final String orderID;
  DisplayIndent(Repository repository,String orderId)
      : repository = repository ?? Repository(),orderID=orderId;

  @override
  _DisplayIndentState createState() => _DisplayIndentState();
}

class _DisplayIndentState extends State<DisplayIndent>{
  DisplayIndentBloc _indentBloc;
  bool _loading=false;

  TextEditingController _productController = new TextEditingController();
  TextEditingController _purchaseOrderQtyController = new TextEditingController();
  TextEditingController _purchaseQtyController = new TextEditingController();

  List<Member> employeeList = new List();
  Member selectedEmployee;


  List<Category> categoryList = new List();
  Category selectedCategory;

  List<ProductModel> productList = new List();
  ProductModel selectedProduct;

  String _commonError = "";

  GlobalKey key = new GlobalKey<AutoCompleteTextFieldState<ProductModel>>();
  GlobalKey employeeKey = new GlobalKey<AutoCompleteTextFieldState<Member>>();
  GlobalKey categoryKey = new GlobalKey<AutoCompleteTextFieldState<Category>>();

  @override
  void initState() {
    _indentBloc=DisplayIndentBloc(repository: widget.repository,orderID: widget.orderID);
    super.initState();
    _indentBloc.add(FetchCategoriesEvent());
    _indentBloc.add(FetchProductsEvent());

  }
  @override
  void dispose() {
    _productController.dispose();
    _purchaseOrderQtyController.dispose();
    _purchaseQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) => _indentBloc,
          child: BlocListener<DisplayIndentBloc, DisplayIndentState>(
            listener: (context, state) {
              if(state is LoadCategoriesState){
                categoryList=state.categoryList;
//                categoryNames.clear();
//                categoryList.forEach((element) {
//                  categoryNames.add(element.name);
//                });
              }else if(state is LoadProductsState){
                productList=state.productList;
//                productNames.clear();
//                productList.forEach((element) {
//                  productNames.add(element.name);
//                });
              }else if(state is LoadTeamMembersState){
                employeeList=state.teamList;
              }
            },
            child: BlocBuilder<DisplayIndentBloc,DisplayIndentState>(
              cubit: _indentBloc,
              builder: (BuildContext context, DisplayIndentState state){
//                if(state is DisplayIndentInitial)
//                  return Center(child: CircularProgressIndicator(),);

                return ProgressHUD(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                            },
                            color: Colors.lightBlue[900],
                          ),
                          Spacer(),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Import Indent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              //_indentBloc.add(CreateIndentButtonClickedEvent());
                            },
                            color: Colors.lightBlue[900],
                          ),
                          Padding(padding: EdgeInsets.all(10),),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("+Add Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                             // _indentBloc.add(CreateIndentButtonClickedEvent());
                              showAlertDialog(context);
                            },
                            color: Colors.lightBlue[900],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.all(10),
                        color: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text("ID",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 1,
                            ),
                            Expanded(
                              child: Text("Product",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 4,
                            ),
                            Expanded(
                              child: Text("Purchase Order Qty",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 2,
                            ),
                            Expanded(
                              child: Text("Purchase Qty",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 2,
                            ),
                            Expanded(
                              child: Text("Employee",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 3,
                            ),
                            Expanded(
                              child: Center(
                                child: Text("Action",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              ),
                              flex: 2,
                            ),
//                              Expanded(
//                                child: InkWell(
//                                  child: Icon(Icons.delete,color: Colors.red,),
//                                ),
//                                flex: 1,
//                              ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  inAsyncCall: _loading,
                  opacity: 0.4,
                );
              }
            ),
          )
        )
    );
  }

  showAlertDialog(BuildContext contxt) {
    return showDialog(
        context: contxt,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 500.0,
              padding:
              EdgeInsets.only(top: 10, right: 15, bottom: 10, left: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Add Indent Product",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      InkWellMouseRegion(
                        child: Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                  Container(
                    child: AutoCompleteTextField<Category>(
                      decoration: new InputDecoration(
                          hintText: "Search Category:", suffixIcon: new Icon(Icons.search)),
                      itemSubmitted: (item) => setState(() => selectedCategory = item),
                      key: categoryKey,
                      suggestions: categoryList,
                      itemBuilder: (context, suggestion) => new Padding(
                          child: new ListTile(
                              title: new Text(suggestion.name),
                              trailing: new Text("${suggestion.name}")),
                          padding: EdgeInsets.all(8.0)),
                      itemSorter: (a, b) => a.name == b.name ? 0 : a.name.contains(b.name) ? -1 : 1,
                      itemFilter: (suggestion, input) =>
                          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                  ),

                  Container(
                    child: AutoCompleteTextField<ProductModel>(
                      decoration: new InputDecoration(
                          hintText: "Search Product:", suffixIcon: new Icon(Icons.search)),
                      itemSubmitted: (item) => setState(() => selectedProduct = item),
                      key: key,
                      suggestions: productList,
                      itemBuilder: (context, suggestion) => new Padding(
                          child: new ListTile(
                              title: new Text(suggestion.name),
                              trailing: new Text("${suggestion.category}")),
                          padding: EdgeInsets.all(8.0)),
                      itemSorter: (a, b) => a.name == b.name ? 0 : a.name.contains(b.name) ? -1 : 1,
                      itemFilter: (suggestion, input) =>
                          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                  ),

                  Container(
                    child: AutoCompleteTextField<Member>(
                      decoration: new InputDecoration(
                          hintText: "Search Employee:", suffixIcon: new Icon(Icons.search)),
                      itemSubmitted: (item) => setState(() => selectedEmployee = item),
                      key: employeeKey,
                      suggestions: employeeList,
                      itemBuilder: (context, suggestion) => new Padding(
                          child: new ListTile(
                              title: new Text(suggestion.name),
                              trailing: new Text("${suggestion.name}")),
                          padding: EdgeInsets.all(8.0)),
                      itemSorter: (a, b) => a.name == b.name ? 0 : a.name.contains(b.name) ? -1 : 1,
                      itemFilter: (suggestion, input) =>
                          suggestion.name.toLowerCase().startsWith(input.toLowerCase()),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                  ),

                  _commonError.isNotEmpty?Container(
                    child: Center(child: Text("$_commonError",style: TextStyle(color: Colors.red),),),
                  ):Container(),

                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.blue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        //addCategory();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                ],
              ),
            ),
          );
        });
  }
}