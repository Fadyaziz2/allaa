

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
 import 'package:get/get.dart';
   import '../../../controller/invoice_controller.dart';
 import '../../base/custom_app_bar.dart';
import '../../base/loading_indicator.dart';
class InvoiceDetailsScreen extends StatefulWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  State<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {



  @override
  Widget build(BuildContext context) {
    Get.find<InvoiceController>().viewFile();
    return Scaffold(

      appBar: CustomAppBar(
        title: "Invoice Details",
        isBackButtonExist: true,
        actions: [

          IconButton(
            onPressed: () {
              Get.find<InvoiceController>().shareFilePdf();
            },
            icon: Icon(Icons.share,

            ),
          ),

        ],

      ),
        body:  GetBuilder<InvoiceController>(
        builder: (invoiceController) {
      return invoiceController.isPdfLoading
          ? Center(child: LoadingIndicator())
          : invoiceController.localFilePath != null
          ? PDFView(

        filePath: invoiceController.localFilePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
      )
          : Center(child: Text('Failed to load PDF'));
    },
    )
    );
  }

}

