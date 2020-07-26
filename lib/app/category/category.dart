import 'package:chitragupta/app/category/category_bloc.dart';
import 'package:chitragupta/extension/hover_extensions.dart';
import 'package:chitragupta/extension/progress.dart';
import 'package:chitragupta/models/City.dart';
import 'package:chitragupta/models/category.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CategoriesPage extends StatefulWidget {
  final Repository repository;
  CategoriesPage(this.repository);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}
class _CategoriesPageState extends State<CategoriesPage> {
  bool _loading = false;
  CategoryBloc _bloc;
  List<City> cityList = new List();
  List<String> cityNames = new List();
  String selectedCity="Select City";

  TextEditingController _nameController = new TextEditingController();

  var title="Add Category",_commonError = "";
  var editCategoryID="";

  List<Category> categoryList = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
          create: (_) => _bloc,
          child: BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if(state is LoadCitiesState){
                cityList=state.cityList;
                cityNames.clear();
                cityList.forEach((element) {
                  cityNames.add(element.city);
                });
              }else if(state is ShowProgressState){
                _loading=true;
              }else if(state is HideProgressState){
                _loading=false;
              }

            },
            child: BlocBuilder<CategoryBloc, CategoryState>(
              cubit: _bloc,
              builder: (BuildContext context, CategoryState state) {
                return ProgressHUD(
                  child: Column(
                    children: [
//                  Align(child: Text("Indents",style: TextStyle(color: Colors.lightBlue[900],fontSize: 25,fontWeight: FontWeight.w700),),
//                    alignment: Alignment.center,),

                      Align(
                        child: RaisedButton(
                          hoverColor: Colors.red,
                          child: Text(
                            "+Add Category",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          onPressed: () {
                            title="Add Customer";
                            //resetForm();
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
                            Padding(padding: EdgeInsets.all(5),),
                            Expanded(
                              child: Text(
                                "City",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              flex: 1,
                            ),
                            Padding(padding: EdgeInsets.all(5),),
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

                      (categoryList.length>0)?Container(
                        margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              child: Divider(thickness: 1,),
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                            );
                          },
                          itemCount: categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Category category=categoryList[index];
                            var date = new DateTime.fromMillisecondsSinceEpoch(category.createdDate );
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
                                        "${category.id}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      flex: 1,
                                    ),
                                    Padding(padding: EdgeInsets.all(5),),
                                    Expanded(
                                      child: Text(
                                        "${category.name}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      flex: 2,
                                    ),
                                    Padding(padding: EdgeInsets.all(5),),
                                    Expanded(
                                      child: Text(
                                        "${category.city}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      flex: 1,
                                    ),
                                    Padding(padding: EdgeInsets.all(5),),
                                    Expanded(
                                      child: Text(
                                        "$createdDate",
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

  showAlertDialog(BuildContext contxt,Category customer) {
    if(customer!=null){
      _nameController.text=customer.name;
      selectedCity=customer.city;
      title="Edit Customer";
      customer=null;
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

                  Container(
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
                    padding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 0),
                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),
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
                        addCategory();
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
  void addCategory() {
    var error="Please enter this field";
    _commonError = "";
    if(_nameController.text.isEmpty){
      _commonError="Please enter category name";
      showAlertDialog(context,null);
      return;
    }

    if(selectedCity=="Select City"){
      _commonError=error;
      showAlertDialog(context,null);
      return;
    }
    var index=cityNames.indexWhere((note) => note.startsWith(selectedCity));
    City city=cityList[index];
    if(title.contains("Edit")){
      _bloc.add(EditCategoryEvent(
          name: _nameController.text,
          city: city.city,
          state: city.state,
          cityID: city.cityID,
          id: editCategoryID
      ));
    }else{
      _bloc.add(AddCategoryEvent(
          name: _nameController.text,
          city: city.city,
          state: city.state,
          cityID: city.cityID
      ));
    }
      
  }

}