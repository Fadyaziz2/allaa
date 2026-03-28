import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/purchase_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';

class PurchaseInvoicesScreen extends StatefulWidget {
  const PurchaseInvoicesScreen({super.key});

  @override
  State<PurchaseInvoicesScreen> createState() => _PurchaseInvoicesScreenState();
}

class _PurchaseInvoicesScreenState extends State<PurchaseInvoicesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final c = Get.find<PurchaseController>();
      c.getSupplierOptions();
      c.getPurchaseInvoices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'purchase_invoices_key'.tr,
        isBackButtonExist: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RouteHelper.getAddPurchaseInvoiceRoute('0')),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: GetBuilder<PurchaseController>(builder: (c) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: DropdownButtonFormField<String>(
                value: c.selectedSupplierFilterId,
                decoration: InputDecoration(labelText: 'filter_by_supplier_key'.tr, border: const OutlineInputBorder()),
                items: [
                  DropdownMenuItem(value: null, child: Text('all_key'.tr)),
                  ...c.supplierOptions.map((s) => DropdownMenuItem(value: s.id.toString(), child: Text(s.name ?? ''))),
                ],
                onChanged: (val) {
                  c.selectedSupplierFilterId = val;
                  c.getPurchaseInvoices();
                },
              ),
            ),
            Expanded(
              child: c.purchaseLoading
                  ? const Center(child: LoadingIndicator())
                  : ListView.builder(
                      itemCount: c.purchaseInvoices.length,
                      itemBuilder: (context, index) {
                        final item = c.purchaseInvoices[index];
                        return ListTile(
                          title: Text('${item.invoiceNumber} - ${item.supplierName ?? ''}'),
                          subtitle: Text('${'paid_amount_key'.tr}: ${item.paidAmount ?? 0} | ${'due_amount_key'.tr}: ${item.dueAmount ?? 0}'),
                          trailing: PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'edit') {
                                Get.toNamed(RouteHelper.getAddPurchaseInvoiceRoute('1'), arguments: item);
                              } else if (val == 'delete' && item.id != null) {
                                c.deletePurchaseInvoice(item.id!);
                              } else if (val == 'pay' && item.id != null) {
                                _showPaymentDialog(c, item.id!);
                              }
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'edit', child: Text('edit_key'.tr)),
                              PopupMenuItem(value: 'delete', child: Text('delete_key'.tr)),
                              PopupMenuItem(value: 'pay', child: Text('pay_due_key'.tr)),
                            ],
                          ),
                        );
                      },
                    ),
            )
          ],
        );
      }),
    );
  }

  void _showPaymentDialog(PurchaseController c, int id) {
    c.paymentAmountController.text = '';
    c.paymentDateController.text = DateTime.now().toString().split(' ').first;
    Get.dialog(AlertDialog(
      title: Text('pay_due_key'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: c.paymentAmountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'amount_key'.tr)),
          const SizedBox(height: 8),
          TextField(controller: c.paymentDateController, decoration: InputDecoration(labelText: 'date_key'.tr)),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel_key'.tr)),
        TextButton(onPressed: () => c.payPurchaseDue(id), child: Text('save_key'.tr)),
      ],
    ));
  }
}
