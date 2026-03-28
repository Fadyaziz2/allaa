import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/purchase_controller.dart';
import 'package:invoicex/data/model/response/supplier_model.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/custom_button.dart';

class AddSupplierScreen extends StatefulWidget {
  final String isUpdate;
  const AddSupplierScreen({super.key, required this.isUpdate});

  @override
  State<AddSupplierScreen> createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  SupplierModel? supplier;

  @override
  void initState() {
    super.initState();
    supplier = Get.arguments as SupplierModel?;
    Get.find<PurchaseController>().resetSupplierForm(model: supplier);
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PurchaseController>();
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.isUpdate == '1' ? 'update_supplier_key'.tr : 'add_supplier_key'.tr,
        isBackButtonExist: true,
      ),
      body: GetBuilder<PurchaseController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(controller: c.supplierNameController, decoration: InputDecoration(labelText: 'name_key'.tr)),
            const SizedBox(height: 12),
            TextField(controller: c.supplierEmailController, decoration: InputDecoration(labelText: 'email_key'.tr)),
            const SizedBox(height: 12),
            TextField(controller: c.supplierPhoneController, decoration: InputDecoration(labelText: 'phone_key'.tr)),
            const SizedBox(height: 12),
            TextField(controller: c.supplierContactController, decoration: InputDecoration(labelText: 'contact_person_key'.tr)),
            const SizedBox(height: 12),
            TextField(controller: c.supplierAddressController, decoration: InputDecoration(labelText: 'address_key'.tr)),
            const SizedBox(height: 24),
            CustomButton(
              buttonText: 'save_key'.tr,
              buttonTextWidget: controller.actionLoading
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
                if (!controller.actionLoading) {
                  c.addSupplier(id: widget.isUpdate == '1' ? supplier?.id : null);
                }
              },
            )
          ],
        );
      }),
    );
  }
}
