import 'dart:convert';
import 'dart:typed_data';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:chitragupta/app/Indent/DisplayIndent/display_indent_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/Member.dart';
import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/indent.dart';
import 'package:chitragupta/models/product.dart';
import 'package:chitragupta/repository.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class DisplayIndent extends StatefulWidget {
  final Repository repository;
  final Order order;
  Function() callback;
  DisplayIndent(Repository repository,Order order,Function function)
      : repository = repository ?? Repository(),order=order,callback=function;

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

  List<Product> indentList=List();

  List<int> _selectedFile;
  Uint8List _bytesData;
ScrollController _scrollController=ScrollController();

  @override
  void initState() {
    _indentBloc=DisplayIndentBloc(repository: widget.repository,order: widget.order);
    _indentBloc.add(FetchIndentProductsEvent());
    super.initState();
    _indentBloc.add(FetchCategoriesEvent());
    _indentBloc.add(FetchProductsEvent());
    _indentBloc.add(FetchTeamMembersEvent());

  }
  @override
  void dispose() {
    _productController.dispose();
    _purchaseOrderQtyController.dispose();
    _purchaseQtyController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) => _indentBloc,
          child: BlocListener<DisplayIndentBloc, DisplayIndentState>(
            listener: (context, state) {
              if(state is LoadIndentProductsState){
                indentList=state.indentProductList;
              }else if(state is LoadCategoriesState){
                categoryList=state.categoryList;
              }else if(state is LoadProductsState){
                productList=state.productList;
              }else if(state is LoadTeamMembersState){
                employeeList=state.teamList;
              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }else if(state is AddingSuccessState){
                _indentBloc.add(FetchIndentProductsEvent());
              }else if(state is ShowSpreadSheetImportState){
                importProgressDialog();
              }else if(state is HideSpreadSheetImportState){
                Navigator.pop(context);
                _indentBloc.add(FetchIndentProductsEvent());
              }else if(state is RefreshState){
                _indentBloc.add(FetchIndentProductsEvent());
              }
            },
            child: BlocBuilder<DisplayIndentBloc,DisplayIndentState>(
              cubit: _indentBloc,
              builder: (BuildContext context, DisplayIndentState state){
                if(state is DisplayIndentInitial)
                  return Center(child: CircularProgressIndicator(),);

                return ProgressHUD(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Back",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              widget.callback();
                            },
                            color: Colors.lightBlue[900],
                          ),
                          Spacer(),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("Import Indent",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                              //_indentBloc.add(CreateIndentButtonClickedEvent());
                              importExcelData();
                            },
                            color: Colors.lightBlue[900],
                          ),
                          Padding(padding: EdgeInsets.all(10),),
                          RaisedButton(
                            hoverColor: Colors.red,
                            child: Text("+Add Product",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            onPressed: () {
                             // _indentBloc.add(CreateIndentButtonClickedEvent());
                              resetForm();
                              showAddIndentAlertDialog(context);
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
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Text("Product",textAlign:TextAlign.start ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 4,
                            ),
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Text("Purchase Order Qty",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 2,
                            ),
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Text("Purchase Qty",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 2,
                            ),
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Text("Employee",textAlign:TextAlign.start ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              flex: 3,
                            ),
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Center(
                                child: Text("Action",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                      ),

                      (indentList.length > 0)
                          ? Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 3,left: 2,right: 2),
                          padding: EdgeInsets.all(5),
                          child: Scrollbar(
                            isAlwaysShown: true,
                            controller: _scrollController,
                            child: ListView.separated(
                              shrinkWrap: true,
                              controller: _scrollController,
                              separatorBuilder: (BuildContext context, int index) {
                                return Padding(
                                  child: Divider(thickness: 1,),
                                  padding: EdgeInsets.only(top: 5, bottom: 5),
                                );
                              },
                              itemCount: indentList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Product indentProduct=indentList[index];
                                var format = DateFormat('dd-MMM-yyy hh:mm a');
//                              var createdDate=format.format(order.createdDate);
//                              var orderDate=format.format(order.date);
                                return InkWellMouseRegion(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15,bottom: 15,left: 5),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text("${index+1}",textAlign:TextAlign.center ,
                                            style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.w400),),
                                          flex: 1,
                                        ),
                                        Padding(padding: EdgeInsets.all(5),),
                                        Expanded(
                                          child: Text("${indentProduct.product}",textAlign:TextAlign.start ,
                                            style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.w400),),
                                          flex: 4,
                                        ),
                                        Padding(padding: EdgeInsets.all(5),),
                                        Expanded(
                                          child: Text("${indentProduct.purchaseOrderQty}",textAlign:TextAlign.center ,
                                            style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.w400),),
                                          flex: 2,
                                        ),
                                        Padding(padding: EdgeInsets.all(5),),
                                        Expanded(
                                          child: Text("${indentProduct.purchaseQty}",textAlign:TextAlign.center ,
                                            style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.w400),),
                                          flex: 2,
                                        ),
                                        Padding(padding: EdgeInsets.all(5),),
                                        Expanded(
                                          child: (indentProduct.employee!=null)?Text("${indentProduct.employee}",
                                            textAlign:TextAlign.start,
                                            style: TextStyle(color: Colors.black,fontSize:16,fontWeight: FontWeight.w400),
                                          ):Container(
                                            child: DropdownSearch<Member>(
                                              items: employeeList,
                                              itemAsString: (Member p) => p.name,
                                              maxHeight: 300,
                                              isFilteredOnline: false,
                                              //onFind: (String filter) => getData(filter),
                                              label: "Select Employee",
                                              onChanged: (val){
                                                indentProduct.employee=val.name;
                                                indentProduct.employeeId=val.uid;
                                                _indentBloc.add(UpdateIndentProductsEvent(product: indentProduct));
                                              },
                                              showSearchBox: true,
                                            ),
                                            padding: EdgeInsets.only(left: 5,right: 5),
                                          ),
                                          flex: 3,
                                        ),
//                                      Expanded(
//                                        child: Center(
//                                          child: Text("Action",textAlign:TextAlign.center ,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
//                                        ),
//                                        flex: 2,
//                                      ),
                                        Padding(padding: EdgeInsets.all(5),),
                                        Expanded(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWellMouseRegion(
                                                child: Icon(Icons.edit,color: Colors.black,),
                                                onTap: (){
                                                  resetForm();
                                                  showEditIndentAlertDialog(context,indentProduct);
                                                },
                                              ),
                                              InkWellMouseRegion(
                                                child: Icon(Icons.delete,color: Colors.red,),
                                                onTap: (){
                                                  showDeleteProductDialog(context,indentProduct);
                                                },
                                              )
                                            ],
                                          ),
                                          flex: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: (){
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      )
                          : Expanded(
                        child: Center(
                          child: Text("No Active Orders Found"),
                        ),

                      )

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

  resetForm(){
    selectedEmployee=null;
    selectedProduct=null;
    selectedCategory=null;
    _purchaseQtyController.text="";
    _purchaseOrderQtyController.text="";
    _commonError="";
  }

  showEditIndentAlertDialog(BuildContext contxt, Product indent) {


    if(indent.employee!=null){
      employeeList.forEach((employee) {
        if(employee.uid==indent.employeeId){
          selectedEmployee=employee;
        }
      });
    }


    if(indent.purchaseQty!=null){
      _purchaseQtyController.text="${indent.purchaseQty}";
    }

    if(indent.purchaseOrderQty!=null){
      _purchaseOrderQtyController.text="${indent.purchaseOrderQty}";
    }


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
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Edit ${indent.product}",
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
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _purchaseOrderQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        fillColor: Colors.white, filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        //hintText: 'Reason for pending',
                        //helperText: 'Keep it short, this is just a demo.',
                        labelText: 'Purchase Order Quantity',
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _purchaseQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        fillColor: Colors.white, filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        //hintText: 'Reason for pending',
                        //helperText: 'Keep it short, this is just a demo.',
                        labelText: 'Purchase Quantity',
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: DropdownSearch<Member>(
                      items: employeeList,
                      itemAsString: (Member p) => p.name,
                      maxHeight: 300,
                      isFilteredOnline: false,
                      selectedItem: selectedEmployee,
                      //onFind: (String filter) => getData(filter),
                      label: "Select Employee",
                      onChanged: (val){
                        selectedEmployee=val;
                      },
                      showSearchBox: true,
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  _commonError.isNotEmpty?Container(
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text("$_commonError",style: TextStyle(color: Colors.red),),),
                  ):Container(padding: EdgeInsets.all(10),),

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
                        if(_purchaseOrderQtyController.text.isNotEmpty && _purchaseQtyController.text.isNotEmpty && selectedEmployee!=null){
                          Navigator.pop(contxt);

                          indent.employee=selectedEmployee.name;
                          indent.employeeId=selectedEmployee.uid;
                          indent.purchaseOrderQty=int.parse(_purchaseOrderQtyController.text);
                          indent.purchaseQty=int.parse(_purchaseQtyController.text);
                          _indentBloc.add(UpdateIndentProductsEvent(product: indent));
                        }
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
  void addProduct() {
    _commonError="";
    if(selectedProduct==null){
      _commonError="Please select product";
      showAddIndentAlertDialog(context);
      return;
    }

    if(selectedEmployee==null){
      _commonError="Please select employee";
      showAddIndentAlertDialog(context);
      return;
    }
    if(_purchaseOrderQtyController.text.isEmpty){
      _commonError="Please select this field";
      showAddIndentAlertDialog(context);
      return;
    }

    if(_purchaseQtyController.text.isEmpty){
      _commonError="Please select this field";
      showAddIndentAlertDialog(context);
      return;
    }

    Product indent=Product();
    indent.orderId=widget.order.orderId;
    indent.category=selectedProduct.category;
    indent.categoryId=selectedProduct.categoryId;
    indent.product=selectedProduct.name;
    indent.productId=selectedProduct.id;
    indent.purchaseOrderQty=int.parse(_purchaseOrderQtyController.text);
    indent.purchaseQty=int.parse(_purchaseQtyController.text);
    indent.employee=selectedEmployee.name;
    indent.employeeId=selectedEmployee.uid;
    _indentBloc.add(AddIndentProductEvent(indent: indent));
  }

  void updateProduct(){

  }

  showAddIndentAlertDialog(BuildContext contxt) {
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
                    child: DropdownSearch<Category>(
                      items: categoryList,
                      itemAsString: (Category p) => p.name,
                      maxHeight: 300,
                      isFilteredOnline: false,
                      //onFind: (String filter) => getData(filter),
                      label: "Select Category",
                      onChanged: (val){
                        selectedCategory=val;
                      },
                      showSearchBox: true,
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: DropdownSearch<ProductModel>(
                      items: productList,
                      itemAsString: (ProductModel p) => p.name,
                      maxHeight: 300,
                      isFilteredOnline: false,
                      //onFind: (String filter) => getData(filter),
                      label: "Select Product",
                      onChanged: (val){
                        selectedProduct=val;
                      },
                      showSearchBox: true,
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _purchaseOrderQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        fillColor: Colors.white, filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        //hintText: 'Reason for pending',
                        //helperText: 'Keep it short, this is just a demo.',
                        labelText: 'Purchase Order Quantity',
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      controller: _purchaseQtyController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      decoration: new InputDecoration(
                        fillColor: Colors.white, filled: true,
                        border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black26),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        //hintText: 'Reason for pending',
                        //helperText: 'Keep it short, this is just a demo.',
                        labelText: 'Purchase Quantity',
                      ),
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  Container(
                    child: DropdownSearch<Member>(
                      items: employeeList,
                      itemAsString: (Member p) => p.name,
                      maxHeight: 300,
                      isFilteredOnline: false,
                      //onFind: (String filter) => getData(filter),
                      label: "Select Employee",
                      onChanged: (val){
                        selectedEmployee=val;
                      },
                      showSearchBox: true,
                    ),
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                  ),

                  _commonError.isNotEmpty?Container(
                    padding: EdgeInsets.all(10),
                    child: Center(child: Text("$_commonError",style: TextStyle(color: Colors.red),),),
                  ):Container(padding: EdgeInsets.all(10),),

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
                        addProduct();
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

  void importExcelData() {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.accept = '.xlsx';
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files[0];
      final reader = new html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result);
      });

    });
  }

  void _handleResult(Object result) {
    _bytesData = Base64Decoder().convert(result.toString().split(",").last);
   _selectedFile = _bytesData;
    var decoder = SpreadsheetDecoder.decodeBytes(_bytesData);

//    for (var table in decoder.tables.keys) {
//      print("BLB ${table}");
//      if()
//    }
    var table = decoder.tables['Sheet1'];
    if(table!=null){
     _indentBloc.add(ImportFromExcelEvent(table));
    }else{
      showExcelFormatError();
    }
   

  }

  void showExcelFormatError() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Wrong Spread Sheet Format",style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text("Please make sure have saved spreadsheet in '.xlsx' format. Tab/Page name should be 'Sheet1'. "
                      "Containing 4 colums 'Description' or 'Product', 'Purchase Order Qty', 'Purchase Qty' and 'Employee' respectively. "),
                ),
                RaisedButton(
                  child: new Text("Ok",style: TextStyle(fontSize: 20,color: Colors.white),),
                  color: Colors.lightBlue[900],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(padding: EdgeInsets.all(10),),
              ],
            ),
          );
        });
  }

  void importProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Importing from Spread sheet...",style: TextStyle(fontSize: 25),textAlign: TextAlign.center,),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text("Please don't close or navigate.",style: TextStyle(color: Colors.black54),),
                ),

                Padding(padding: EdgeInsets.all(10),),
              ],
            ),
          );
        });
  }

  showDeleteProductDialog(BuildContext contxt, Product indent) {
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
                            "Delete Product?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.lightBlue[900]),
                          ),
                        ),
                      ),
                      HandCursor(
                        child: GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30, bottom: 30),
                    padding: EdgeInsets.only(left: 10, right: 10,bottom: 10,top: 10),
                    child: Text("Are you sure you want to delete ${indent.product} ?"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    // height: double.infinity,
                    child: RaisedButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                      color: Colors.lightBlue[900],
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      onPressed: () {
                        Navigator.pop(contxt);
                        _indentBloc.add(DeleteIndentProductsEvent(product: indent));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  HandCursor(
                    child: InkWell(
                      child: Container(
                        child: Text("Cancel"),
                        margin: EdgeInsets.only(top: 10,bottom: 5),
                        padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                      ),
                      onTap: (){
                        Navigator.pop(contxt);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}