import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/wastage_controller.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/loading_indicator.dart';
import '../../base/nothing_to_show_here.dart';

class WastageScreen extends StatefulWidget {
  const WastageScreen({super.key});

  @override
  State<WastageScreen> createState() => _WastageScreenState();
}

class _WastageScreenState extends State<WastageScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WastageController>().getWastages();
    });
  }

  void _scrollListener() {
    final controller = Get.find<WastageController>();
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !controller.isPaginateLoading && controller.nextPageUrl != null) {
      controller.getWastages(isPaginate: true);
    }
  }

  Future<void> _showAddDialog() async {
    final controller = Get.find<WastageController>();
    await controller.initFormData();
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (_) => GetBuilder<WastageController>(builder: (c) {
        return AlertDialog(
          title: Text('add_wastage_key'.tr),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: c.selectedProductId,
                  decoration: InputDecoration(labelText: 'product_key'.tr),
                  items: c.products
                      .map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!)))
                      .toList(),
                  onChanged: (v) => c.selectedProductId = v,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: c.quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'quantity_key'.tr),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: c.noteController,
                  decoration: InputDecoration(labelText: 'note_key'.tr),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('cancel_key'.tr)),
            ElevatedButton(
              onPressed: c.isSubmitting
                  ? null
                  : () async {
                      final ok = await c.addWastage();
                      if (ok) Get.back();
                    },
              child: c.isSubmitting ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)) : Text('save_key'.tr),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBackButtonExist: true,
        title: 'all_wastages_key'.tr,
        actions: [IconButton(onPressed: _showAddDialog, icon: const Icon(Icons.add))],
      ),
      body: GetBuilder<WastageController>(builder: (controller) {
        if (controller.isLoading) return const Center(child: LoadingIndicator());
        if (controller.wastageList.isEmpty) return const NothingToShowHere();

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedCategoryId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'category_key'.tr),
                      items: [
                        DropdownMenuItem(value: '', child: Text('all_key'.tr)),
                        ...controller.categories.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!))),
                      ],
                      onChanged: (v) => controller.setFilterCategory((v == null || v.isEmpty) ? null : v),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: controller.selectedProductId,
                      isExpanded: true,
                      decoration: InputDecoration(labelText: 'product_key'.tr),
                      items: [
                        DropdownMenuItem(value: '', child: Text('all_key'.tr)),
                        ...controller.products.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!))),
                      ],
                      onChanged: (v) => controller.setFilterProduct((v == null || v.isEmpty) ? null : v),
                    ),
                  ),
                  IconButton(onPressed: () => controller.getWastages(), icon: const Icon(Icons.search)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                itemCount: controller.wastageList.length,
                itemBuilder: (_, i) {
                  final item = controller.wastageList[i];
                  return Card(
                    child: ListTile(
                      title: Text(item.productName ?? '-'),
                      subtitle: Text('${item.categoryName ?? '-'} • ${item.movementDate ?? '-'}'),
                      trailing: Text('-${item.quantity?.toStringAsFixed(2) ?? '0'}', style: poppinsMedium.copyWith(color: Theme.of(context).colorScheme.error)),
                    ),
                  );
                },
              ),
            ),
            if (controller.isPaginateLoading) const Padding(
              padding: EdgeInsets.all(8.0),
              child: LoadingIndicator(),
            )
          ],
        );
      }),
    );
  }
}
