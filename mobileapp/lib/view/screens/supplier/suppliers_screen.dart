import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoicex/controller/purchase_controller.dart';
import 'package:invoicex/helper/route_helper.dart';
import 'package:invoicex/view/base/custom_app_bar.dart';
import 'package:invoicex/view/base/loading_indicator.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Get.find<PurchaseController>().getSuppliers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'suppliers_key'.tr,
        isBackButtonExist: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(RouteHelper.getAddSupplierRoute('0')),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: GetBuilder<PurchaseController>(builder: (controller) {
        if (controller.suppliersLoading) {
          return const Center(child: LoadingIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: (value) => controller.getSuppliers(search: value),
                decoration: InputDecoration(
                  hintText: 'search_key'.tr,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.suppliers.length,
                itemBuilder: (context, index) {
                  final item = controller.suppliers[index];
                  return ListTile(
                    title: Text(item.name ?? '-'),
                    subtitle: Text(
                      '${'paid_amount_key'.tr}: ${item.totalPaid ?? 0} | ${'due_amount_key'.tr}: ${item.totalDue ?? 0}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (val) {
                        if (val == 'edit') {
                          Get.toNamed(RouteHelper.getAddSupplierRoute('1'), arguments: item);
                        } else if (val == 'delete' && item.id != null) {
                          controller.deleteSupplier(item.id!);
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(value: 'edit', child: Text('edit_key'.tr)),
                        PopupMenuItem(value: 'delete', child: Text('delete_key'.tr)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
