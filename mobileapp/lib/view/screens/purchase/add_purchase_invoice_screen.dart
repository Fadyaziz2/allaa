import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/purchase_controller.dart';
import 'package:invoicex/data/model/response/purchase_invoice_model.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_button.dart';

class AddPurchaseInvoiceScreen extends StatefulWidget {
  final String isUpdate;
  const AddPurchaseInvoiceScreen({super.key, required this.isUpdate});

  @override
  State<AddPurchaseInvoiceScreen> createState() => _AddPurchaseInvoiceScreenState();
}

class _AddPurchaseInvoiceScreenState extends State<AddPurchaseInvoiceScreen> {
  PurchaseInvoiceModel? model;

  @override
  void initState() {
    super.initState();
    model = Get.arguments as PurchaseInvoiceModel?;
    final c = Get.find<PurchaseController>();
    c.getSupplierOptions();
    c.getProductOptions();
    c.resetPurchaseForm(model: model);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PurchaseController>();
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isUpdate == '1' ? 'update_purchase_invoice_key'.tr : 'add_purchase_invoice_key'.tr,
        isBackButtonExist: true,
      ),
      body: GetBuilder<PurchaseController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              value: c.selectedSupplierId,
              decoration: InputDecoration(labelText: 'supplier_key'.tr, border: const OutlineInputBorder()),
              items: c.supplierOptions
                  .map((s) => DropdownMenuItem<int>(value: s.id, child: Text(s.name ?? '')))
                  .toList(),
              onChanged: (v) {
                c.selectedSupplierId = v;
              },
            ),
            const SizedBox(height: 10),
            TextField(controller: c.invoiceNumberController, decoration: InputDecoration(labelText: 'invoice_number_key'.tr)),
            const SizedBox(height: 10),
            TextField(controller: c.invoiceDateController, decoration: InputDecoration(labelText: 'date_key'.tr)),
            const SizedBox(height: 10),
            TextField(controller: c.discountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'discount_key'.tr)),
            const SizedBox(height: 10),
            TextField(controller: c.taxController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'tax_key'.tr)),
            const SizedBox(height: 10),
            TextField(controller: c.paidAmountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'paid_amount_key'.tr)),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('items_key'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: c.addInvoiceItem, icon: const Icon(Icons.add_circle_outline))
              ],
            ),
            ...List.generate(c.invoiceItems.length, (index) {
              final row = c.invoiceItems[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: row['product_id']!.text.isEmpty ? null : row['product_id']!.text,
                        decoration: InputDecoration(labelText: 'product_key'.tr),
                        items: c.productOptions
                            .map((p) => DropdownMenuItem<String>(
                                  value: p['id'].toString(),
                                  child: Text(p['name']),
                                ))
                            .toList(),
                        onChanged: (val) {
                          final selected = c.productOptions.firstWhere((p) => p['id'].toString() == val);
                          row['product_id']!.text = val ?? '';
                          row['product_name']!.text = selected['name'];
                          row['unit_price']!.text = selected['price'].toString();
                          c.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(controller: row['quantity'], keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'quantity_key'.tr)),
                      const SizedBox(height: 8),
                      TextField(controller: row['unit_price'], keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'unit_price_key'.tr)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(onPressed: () => c.removeInvoiceItem(index), icon: const Icon(Icons.delete_outline)),
                      )
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            CustomButton(
              buttonText: 'save_key'.tr,
              buttonTextWidget: c.actionLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).cardColor),
                      ),
                    )
                  : null,
              onPressed: () {
                if (!c.actionLoading) {
                  c.submitPurchaseInvoice(id: widget.isUpdate == '1' ? model?.id : null);
                }
              },
            )
          ],
        );
      }),
    );
  }
}
