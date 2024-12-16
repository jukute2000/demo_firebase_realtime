import 'package:demo_firebase_realtime/controller/author/home_controller.dart';
import 'package:demo_firebase_realtime/models/item_model.dart';
import 'package:demo_firebase_realtime/models/type_item_model.dart';
import 'package:demo_firebase_realtime/untils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHomeView extends StatelessWidget {
  const AuthHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AuthorHomeController controller = Get.put(AuthorHomeController());
    final size = MediaQuery.of(context).size;
    List<Widget> body = [
      HomeWidget(size: size, controller: controller),
      OrderWidget(controller: controller, size: size),
      TypeProductWidget(controller: controller, size: size),
    ];
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        leading: Obx(
          () => controller.selectPage.value == 0
              ? PopupMenuButton(
                  color: Colors.white,
                  onSelected: (value) {
                    controller.getItemDataByIdType(value);
                  },
                  icon: Image(
                    image: const AssetImage("assets/images/arrange.png"),
                    fit: BoxFit.cover,
                    height: size.width * 0.06,
                    width: size.width * 0.06,
                  ),
                  itemBuilder: (context) => List.generate(
                    controller.types.length,
                    (index) {
                      TypeItem type = controller.types[index];
                      return PopupMenuItem(
                        value: type.idType,
                        child: ListTile(
                          title: Text(type.nameType),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.logout();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: Colors.grey),
              )
            : body[controller.selectPage.value],
      ),
      bottomNavigationBar: Obx(
        () => controller.isLoading.value
            ? const SizedBox()
            : BottomNavigationBar(
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                currentIndex: controller.selectPage.value,
                onTap: (value) {
                  controller.choosePage(value);
                },
                items: const [
                    BottomNavigationBarItem(
                      label: "Home",
                      icon: Icon(
                        Icons.home,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "Order",
                      icon: Icon(
                        Icons.description_outlined,
                      ),
                    ),
                    BottomNavigationBarItem(
                      label: "Type Product",
                      icon: Icon(
                        Icons.type_specimen_outlined,
                      ),
                    ),
                  ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Obx(
        () => controller.isLoading.value
            ? const SizedBox()
            : controller.selectPage.value == 1
                ? const SizedBox()
                : FloatingActionButton(
                    heroTag: 'movePageAddItem',
                    onPressed: () {
                      controller.addButton(controller.selectPage.value);
                    },
                    shape: const CircleBorder(),
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black,
                    ),
                  ),
      ),
    );
  }
}

class TypeProductWidget extends StatelessWidget {
  const TypeProductWidget(
      {super.key, required this.controller, required this.size});
  final AuthorHomeController controller;
  final Size size;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          controller.isTypeProductNull.value
              ? const Center(
                  child: Text("Not type product"),
                )
              : Visibility(
                  visible: controller.isLoading.value,
                  replacement: RefreshIndicator(
                    onRefresh: () => controller.getTypeData(),
                    child: Padding(
                        padding: AppTheme.padding16px,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.types.length,
                          itemBuilder: (context, index) {
                            TypeItem type = controller.types[index];
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: Stack(
                                children: [
                                  ListTile(
                                    title: Text(type.nameType),
                                    subtitle: Text(controller
                                        .statusTypeData[type.status]!),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.editButton(
                                            type.idType,
                                            type.nameType,
                                            type.status,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          if (controller.isAddType.value || controller.isEditType.value)
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: AppTheme.padding8px,
                height: size.height * 0.4,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.canelAddOrEditType();
                      },
                      icon: const Icon(
                        Icons.cancel_outlined,
                      ),
                    ),
                    Center(
                      child: Text(
                        controller.isEditType.value
                            ? "Edit Type Product"
                            : "Add Type Product",
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextField(
                      controller: controller.type,
                      cursorColor: Colors.grey,
                      maxLength: 50,
                      decoration: InputDecoration(
                        labelText: "Type",
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          borderRadius: BorderRadius.circular(10),
                          isExpanded: true,
                          value: controller.statusTypeSelect.value,
                          hint: const Text("Status :"),
                          dropdownColor: Colors.white,
                          items: List.generate(
                            controller.statusTypeData.length,
                            (index) => DropdownMenuItem(
                                value: index,
                                child: Text(controller.statusTypeData[index]!)),
                          ),
                          onChanged: (value) {
                            controller.statusTypeSelect.value = value!;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.isAddType.value) {
                            controller.addType();
                          } else {
                            controller.editType();
                          }
                        },
                        style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(AppTheme.primaryColor),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class OrderWidget extends StatelessWidget {
  const OrderWidget({
    super.key,
    required this.controller,
    required this.size,
  });

  final AuthorHomeController controller;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Visibility(
          visible: controller.isLoading.value,
          replacement: RefreshIndicator(
            onRefresh: () => controller.getAllOrder(),
            child: controller.isOrdersNull.value
                ? const Center(
                    child: Text("Non Order"),
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              width: size.width,
                              child: TextField(
                                cursorColor: Colors.green,
                                controller: controller.searchOrder,
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  labelStyle:
                                      const TextStyle(color: Colors.black),
                                  suffixIcon: IconButton(
                                    onPressed: controller.getOrderBySearch,
                                    icon: const Icon(Icons.search,
                                        color: Colors.black),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await controller.getOrderByDate(
                                context,
                                size.width * 0.8,
                                size.width * 0.8,
                              );
                            },
                            icon: const Icon(
                              Icons.date_range,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: controller.isOrderSearchNull.value &&
                                controller.isSearchOrder.value
                            ? const Center(
                                child: Text(
                                  "No orders found.",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            : ListView.builder(
                                itemCount: controller.orders.length,
                                itemBuilder: (context, indexOrder) {
                                  final order = controller.orders[indexOrder];
                                  int totalAllPrice = 0;
                                  int totalAllProduct = 0;
                                  return Container(
                                    margin: const EdgeInsets.all(16.0),
                                    padding: const EdgeInsets.all(16.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            "Order Information",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.grey),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Id order:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " ${order.idOrder}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              const TextSpan(
                                                text: "Date:",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " ${order.date}",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        const Text(
                                          "Product:",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const Divider(color: Colors.grey),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                              controller
                                                  .itemOrder[indexOrder].length,
                                              (indexItem) {
                                                final item = controller
                                                        .itemOrder[indexOrder]
                                                    [indexItem];
                                                final cart =
                                                    order.carts[indexItem];
                                                totalAllProduct +=
                                                    cart.quantity;
                                                totalAllPrice +=
                                                    cart.totalPrice;
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 16),
                                                  width: size.width * 0.7,
                                                  height: size.height * 0.15,
                                                  color: AppTheme.primaryColor,
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: size.width * 0.3,
                                                        height:
                                                            size.height * 0.15,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              item.urlImage,
                                                            ),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child: Text(
                                                                item.title,
                                                                maxLines: 2,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                  color: AppTheme
                                                                      .textColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: Text(
                                                                "x ${cart.quantity}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                            const Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                            FittedBox(
                                                              fit: BoxFit
                                                                  .contain,
                                                              child: Text(
                                                                "Total price: ${cart.totalPrice}đ",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.grey),
                                        Text(
                                          "Total price all products ($totalAllProduct): $totalAllPrice đ",
                                          style: const TextStyle(
                                            color: AppTheme.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            const Text(
                                              "Order status:",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Obx(
                                              () => DropdownButton<int>(
                                                value:
                                                    controller.listStatusOrders[
                                                        indexOrder],
                                                items: List.generate(
                                                  2,
                                                  (index) => DropdownMenuItem(
                                                    value: index + 1,
                                                    child: Text(
                                                      controller.statusData[
                                                          index + 1]!,
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  controller.listStatusOrders[
                                                      indexOrder] = value!;
                                                  controller.editStatusOrder(
                                                    order.idOrder,
                                                    order.date,
                                                    order.carts,
                                                    value,
                                                    order.message,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({
    super.key,
    required this.controller,
    required this.size,
  });

  final AuthorHomeController controller;
  final Size size;

  @override
  State<HomeWidget> createState() => _homeState();
}

class _homeState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => widget.controller.isItemsEmpty.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text("Non products"),
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        widget.controller.getProductData();
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ),
                ],
              )
            : Visibility(
                visible: widget.controller.isLoading.value,
                replacement: RefreshIndicator(
                  onRefresh: () => widget.controller.getProductData(),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        width: widget.size.width,
                        child: TextField(
                          cursorColor: Colors.green,
                          controller: widget.controller.searchProduct,
                          decoration: InputDecoration(
                            labelText: "Search",
                            labelStyle: const TextStyle(color: Colors.black),
                            suffixIcon: IconButton(
                              onPressed: () {
                                widget.controller.getItemDataBySearch();
                              },
                              icon:
                                  const Icon(Icons.search, color: Colors.black),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: List.generate(
                            widget.controller.items.length,
                            (index) {
                              Item item = widget.controller.items[index];
                              String type =
                                  widget.controller.typesProduct[index];
                              return ProductWidget(
                                controller: widget.controller,
                                item: item,
                                type: type,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.controller,
    required this.item,
    required this.type,
  });
  final AuthorHomeController controller;
  final Item item;
  final String type;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "product${item.title}",
      onPressed: () {
        Get.toNamed("/authorDetailItem", arguments: {
          "id": item.id,
          "title": item.title,
          "idType": item.idType,
          "description": item.description,
          "price": item.price,
          "urlImage": item.urlImage,
          "status": item.status,
        });
      },
      elevation: 10,
      splashColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(
          color: Colors.grey,
          width: 2,
        ),
      ),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: 16,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  item.urlImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Text(
                "$type - ${item.title}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  "${item.price} đ",
                  maxLines: 1,
                  style: const TextStyle(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Flexible(
            flex: 7,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Flexible(
                    flex: 4,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.white60,
                        ),
                        shape: WidgetStatePropertyAll(
                          BeveledRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await controller.deleteItem(item.id, item.tagImage);
                      },
                      child: const FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.white60,
                        ),
                        shape: WidgetStatePropertyAll(
                          BeveledRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.toNamed("/authorAddEdit", arguments: {
                          "page": "Edit",
                          "id": item.id,
                          "idType": item.idType,
                          "title": item.title,
                          "description": item.description,
                          "price": item.price,
                          "urlImage": item.urlImage,
                          "status": item.status,
                        })?.then(
                          (value) {
                            controller.getDataProductAndType();
                          },
                        );
                      },
                      child: const FittedBox(
                        child: Icon(
                          Icons.edit,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}