
import 'dart:typed_data';

import 'package:chitragupta/models/Order.dart';
import 'package:chitragupta/models/Product.dart';
import 'package:chitragupta/models/customer.dart';
import 'package:chitragupta/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInvoice(Order order, Customer customer, List<Product> productsList ) async {
  final lorem = pw.LoremText();

  List<InvoiceProduct> products = List();
  var i=1;
  productsList.forEach((product) {
    products.add(InvoiceProduct("${i++}",product.product,product.invoiceAmount.toDouble(),product.deliveredQty));
  });
  final invoice = Invoice(
    invoiceNumber: '${order.orderId}',
    products: products,
    customerName: '${order.name}',
    customerAddress: '${customer.address}',
    paymentInfo:
    'Make all checks payable to Pureinfresh If you have any questions concerning this invoice, contact Nageswar at 8187828580, hello@pureinfresh.com',
    tax: 0.01,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey600,
    order: order
  );

  return await invoice.buildPdf(PdfPageFormat.a4);
}

class Invoice {
  Invoice({
    this.products,
    this.customerName,
    this.customerAddress,
    this.invoiceNumber,
    this.tax,
    this.paymentInfo,
    this.baseColor,
    this.accentColor,
    this.order
  });

  final List<InvoiceProduct> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;
  final Order order;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  PdfColor get _accentTextColor =>
      baseColor.luminance < 0.5 ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  PdfImage _logo;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    final font1 = await rootBundle.load('assets/roboto1.ttf');
    final font2 = await rootBundle.load('assets/roboto2.ttf');
    final font3 = await rootBundle.load('assets/roboto3.ttf');

    _logo = PdfImage.file(
      doc.document,
      bytes: (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
    );

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          PdfPageFormat.a4,
          font1 != null ? pw.Font.ttf(font1) : null,
          font2 != null ? pw.Font.ttf(font2) : null,
          font3 != null ? pw.Font.ttf(font3) : null,
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _summaryHeader(context),
          pw.SizedBox(height: 5),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius: 2,
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(invoiceNumber),
                          pw.Text('Invoice Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    //child: _logo != null ? pw.Image(_logo) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.grey,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.Stack(
          children: [
            pw.Positioned(
              bottom: 0,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 2,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [baseColor, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              bottom: 20,
              left: 0,
              child: pw.Container(
                height: 20,
                width: pageFormat.width / 4,
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [accentColor, PdfColors.white],
                  ),
                ),
              ),
            ),
            pw.Positioned(
              top: pageFormat.marginTop + 72,
              left: 0,
              right: 0,
              child: pw.Container(
                height: 3,
                color: baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10),
                child: pw.Text(
                  'Invoice From:',
                  style: pw.TextStyle(
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold ,
                    fontSize: 8,
                  ),
                ),
              ),

              pw.Container(
                margin: const pw.EdgeInsets.only(top: 5,bottom: 5),
                child: pw.RichText(
                    text: pw.TextSpan(
                        text: '${Repository.adminUser.name}\n',
                        style: pw.TextStyle(
                          color: _darkColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          const pw.TextSpan(
                            text: '\n',
                            style: pw.TextStyle(
                              fontSize: 5,
                            ),
                          ),
                          pw.TextSpan(
                            text: '${Repository.adminUser.address}',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ])),
              ),
              pw.Text("${Repository.adminUser.mobile}",
                  style: pw.TextStyle(fontSize: 8,
                      fontWeight: pw.FontWeight.normal)),
              pw.Padding(padding: pw.EdgeInsets.all(1),),
              pw.Text("${Repository.adminUser.email}",
                  style: pw.TextStyle(fontSize: 8,
                      fontWeight: pw.FontWeight.normal)),

              pw.Padding(padding: pw.EdgeInsets.all(3),),
            ]
          )
        ),
        pw.Padding(padding: pw.EdgeInsets.all(5)),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 10,),
                child: pw.Text(
                  'Invoice To:',
                  style: pw.TextStyle(
                    color: PdfColors.grey600,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 8,
                  ),
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 5,bottom: 5),
                child: pw.RichText(
                    text: pw.TextSpan(
                        text: '$customerName\n',
                        style: pw.TextStyle(
                          color: _darkColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: [
                          const pw.TextSpan(
                            text: '\n',
                            style: pw.TextStyle(
                              fontSize: 5,
                            ),
                          ),
                          pw.TextSpan(
                            text: customerAddress,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.normal,
                              fontSize: 10,
                            ),
                          ),
                        ])),
              ),
              pw.Padding(padding: pw.EdgeInsets.all(3),),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _summaryHeader(pw.Context context){
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
      children: [
        pw.Container(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Order Date',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.normal,
                  ),
                ),
                pw.Padding(padding: pw.EdgeInsets.all(1)),
                pw.Text(
                  '${_formatDate(order.createdDate)}',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontStyle: pw.FontStyle.normal,
                  ),
                )
              ]
          ),
        ),
        pw.Container(
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Delivered Date',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.normal,
                  ),
                ),
                pw.Padding(padding: pw.EdgeInsets.all(1)),
                pw.Text(
                  '${_formatDate(order.date)}',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontStyle: pw.FontStyle.normal,
                  ),
                )
              ]
          ),
        ),
        pw.Container(
          child: pw.Column(
              children: [
                pw.Text(
                  'Total Items',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.normal,
                  ),
                ),
                pw.Padding(padding: pw.EdgeInsets.all(1)),
                pw.Text(
                  '${products.length}',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  ),
                )
              ]
          ),
        ),
        pw.Container(
          child: pw.Column(
              children: [
                pw.Text(
                  'Total Amount',
                  style: pw.TextStyle(
                    fontSize: 7,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.normal,
                  ),
                ),
                pw.Padding(padding: pw.EdgeInsets.all(1)),
                pw.Text(
                  '${_formatCurrency(_grandTotal)}',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                  ),
                )
              ]
          ),
        ),
      ]
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                paymentInfo,
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.BoxBorder(
                    top: true,
                    color: accentColor,
                  ),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                "This is system generated invoice, no signature needed",
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SN#',
      'Item Description',
      'Quantity',
      //'Units'
      'Unit Price',
      'Total'
    ];

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: 2,
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        //5: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          color: accentColor,
          width: 0.01,
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
            (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
            (row) => List<String>.generate(
          tableHeaders.length,
              (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '₹ ${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMMd('en_US');
  return format.format(date);
}

class InvoiceProduct {
  const InvoiceProduct(
      this.SN,
      //this.units,
      this.productName,
      this.price,
      this.quantity,
      );

  final String SN;
  //final String units;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return SN;
      case 1:
        return productName;
      case 2:
        return quantity.toString();
//      case 3:
//        return units;
      case 3:
        return _formatCurrency(price);
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}
