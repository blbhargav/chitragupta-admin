import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/models/product.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chitragupta/app/product/product_bloc.dart';
import 'package:intl/intl.dart';

class ProductsPage extends StatefulWidget {
  final Repository repository;
  ProductsPage(this.repository);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}
class _ProductsPageState extends State<ProductsPage> {
  bool _loading = false,showCity=false;
  ProductBloc _bloc;
  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";

  List<Category> categoryList = new List();
  List<String> categoryNames = new List();
  String selectedCategory="Select Category";

  List<ProductModel> productsList=List();

  TextEditingController _nameController = new TextEditingController();

  var title="Add Category",_commonError = "";
  var editCategoryID="";



  @override
  void initState() {
    _bloc=ProductBloc(repository: widget.repository);
    _bloc.add(FetchProductsEvent());
    _bloc.add(ProductInitEvent());
    _bloc.add(FetchCategoriesEvent());
    _bloc.add(FetchCitiesEvent());
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
            create: (_) => _bloc,
            child: BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if(state is ProductInitial){
                    showCity=state.showCity;
                  }else if(state is LoadCitiesState){
                    cityList=state.cityList;
                    cityNames.clear();
                    cityList.forEach((element) {
                      cityNames.add(element.city);
                    });
                  }else if(state is LoadCategoriesState){
                    categoryList=state.categoryList;
                    categoryNames.clear();
                    categoryList.forEach((element) {
                      categoryNames.add(element.name);
                    });
                  }else if(state is ShowProgressState){
                    _loading=true;
                  }else if(state is HideProgressState){
                    _loading=false;
                  }else if(state is LoadProductsState){
                    productsList=state.productList;
                  }else if(state is AddingSuccessState){
                    _bloc.add(FetchProductsEvent());
                  }
                },
                child: BlocBuilder<ProductBloc, ProductState>(
                    cubit: _bloc,
                    builder: (BuildContext context, ProductState state) {
                      return ProgressHUD(
                        child: Column(
                          children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                            Align(
                              child: RaisedButton(
                                hoverColor: Colors.red,
                                child: Text(
                                  "+Add Product",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                ),
                                onPressed: () {
                                  title="Add Product";
                                  resetForm();
                                  showAlertDialog(context,null);
                                },
                                color: Colors.lightBlue[900],
                              ),
                              alignment: Alignment.topRight,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              color: Colors.black,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "ID",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    flex: 1,
                                  ),
                                  Padding(padding: EdgeInsets.all(5),),
                                  Expanded(
                                    child: Text(
                                      "Category",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    flex: 2,
                                  ),
                                  showCity?Expanded(
                                    child: Container(
                                      child: Text(
                                        "City",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      padding: EdgeInsets.only(left: 10,right: 10),
                                    ),
                                    flex: 1,
                                  ):Container(),
                                  Expanded(
                                    child: Text(
                                      "Created Date",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    flex: 2,
                                  ),
                                  Padding(padding: EdgeInsets.all(5),),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Action",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),

                            (productsList.length>0)?Container(
                              margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                              child: ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    child: Divider(thickness: 1,),
                                    padding: EdgeInsets.only(top: 5, bottom: 5),
                                  );
                                },
                                itemCount: productsList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  ProductModel product=productsList[index];
                                  var date = new DateTime.fromMillisecondsSinceEpoch(product.createdDate );
                                  var format = DateFormat('dd-MMM-yyy hh:mm a');
                                  var createdDate=format.format(date);
                                  return InkWellMouseRegion(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 10,bottom: 10,left: 5,right: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${product.id}",
                                              style: TextStyle(
                                                  color: Colors.black,fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            flex: 1,
                                          ),
                                          Padding(padding: EdgeInsets.all(5),),
                                          Expanded(
                                            child: Text(
                                              "${product.name}",
                                              style: TextStyle(
                                                  color: Colors.black,fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            flex: 2,
                                          ),
                                          showCity?Expanded(
                                            child: Container(
                                              child: Text(
                                                "${product.city}",
                                                style: TextStyle(
                                                    color: Colors.black,fontSize: 16,
                                                    fontWeight: FontWeight.w400),
                                              ),
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                            ),
                                            flex: 1,
                                          ):Container(),
                                          Expanded(
                                            child: Text(
                                              "$createdDate",
                                              style: TextStyle(
                                                  color: Colors.black,fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            flex: 2,
                                          ),
                                          Padding(padding: EdgeInsets.all(5),),
                                          Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
//                                          InkWellMouseRegion(
//                                            child: Icon(Icons.edit,color: Colors.black,),
//                                            onTap: (){
//                                              showAlertDialog(context,customer);
//                                              editCustomerID=customer.customerID;
//                                            },
//                                          ),
//                                          Padding(padding: EdgeInsets.all(10),),
                                                InkWellMouseRegion(
                                                  child: Icon(Icons.delete,color: Colors.red,),
                                                  onTap: (){
                                                    showDeleteProductDialog(context,product);
                                                  },
                                                )
                                              ],
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: (){

                                    },
                                  );
                                },
                              ),
                            ):Expanded(
                              child: Center(child: Text("No Data Found"),),
                            )


                          ],
                        ),
                        inAsyncCall: _loading,
                        opacity: 0.4,
                      );
                    }
                )
            )
        )
    );
  }

  showAlertDialog(BuildContext contxt,ProductModel product) {
    if(product!=null){
      _nameController.text=product.name;
      selectedCity=product.city;
      title="Edit Product";
      product=null;
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
                            "$title",
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
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: categoryNames.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedCategory=="Select Category"?Text("$selectedCategory"):Text("$selectedCategory",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedCategory=_val;
                          Navigator.pop(contxt);
                          showAlertDialog(contxt,null);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5,top: 10),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: new TextField(
                      controller: this._nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.business_center),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),

                  showCity?Container(
                    child: HandCursor(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: Container(color: Colors.pinkAccent,height: 1,width: double.maxFinite,),
                        items: cityNames.map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        hint: selectedCity=="Select City"?Text("$selectedCity"):Text("$selectedCity",style: TextStyle(color: Colors.black),),
                        onChanged: (_val) {
                          selectedCity=_val;
                          Navigator.pop(contxt);
                          showAlertDialog(contxt,null);
                        },
                      ),
                    ),
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 10),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5,top: 10),
                  ):Container(),

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
                        addProduct(product);
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
  void addProduct(ProductModel product) {
    var error="Please enter this field";
    _commonError = "";

    if(selectedCategory=="Select Category"){
      _commonError="Please select category";
      showAlertDialog(context,null);
      return;
    }

    if(_nameController.text.isEmpty){
      _commonError="Please enter category name";
      showAlertDialog(context,null);
      return;
    }
    var categoryIndex=categoryNames.indexWhere((note) => note.startsWith(selectedCategory));
    Category category=categoryList[categoryIndex];

    if(showCity){
      //validation for SuperAdmin
      if(selectedCity=="Select City"){
        _commonError="Please select city";
        showAlertDialog(context,null);
        return;
      }
      var index=cityNames.indexWhere((note) => note.startsWith(selectedCity));
      City city=cityList[index];

      _bloc.add(AddProductEvent(
          name: _nameController.text,
          city: city.city,
          state: city.state,
          cityID: city.cityID,
          category: category.name,
          categoryId: category.id
      ));
    }else {
      _bloc.add(AddProductEvent(
          name: _nameController.text,
          city: Repository.user.city,
          state: Repository.user.state,
          cityID: Repository.user.cityID,
          category: category.name,
          categoryId: category.id
      ));
    }

  }

  showDeleteProductDialog(BuildContext contxt, ProductModel product) {
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
                            "Delete Category?",
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
                    child: Text("Are you sure you want to delete ${product.name} ?"),
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

  void resetForm() {
    _nameController.text="";
    selectedCity="Select City";
    selectedCategory="Select Category";
  }


}