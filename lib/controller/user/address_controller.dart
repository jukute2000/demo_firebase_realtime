import 'package:demo_firebase_realtime/models/address_model.dart';
import 'package:demo_firebase_realtime/services/address_firebase.dart';
import 'package:demo_firebase_realtime/widgets/snackbar_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController numberPhone = TextEditingController();
  TextEditingController address = TextEditingController();
  String idUser = "";
  List<Address>? addresses;
  String idAddressChoose = "";
  int statusAddressChoose = 0;
  RxBool isLoading = false.obs;
  RxBool isAddressNull = true.obs;
  RxBool isAddAddress = false.obs;
  RxBool isEditAddress = false.obs;
  final _addressDatabase = AddressFirebase();
  final Map<String, dynamic> data;

  AddressController({required this.data}) {
    idUser = data["idUser"] ?? "";
    getDataAddress();
  }

  void changeIsAddAddress() {
    isAddAddress.value = !isAddAddress.value;
    name.clear();
    numberPhone.clear();
    address.clear();
  }

  void changeIsEditAddress(Address? currentAddress) {
    isAddAddress.value = !isAddAddress.value;
    isEditAddress.value = !isEditAddress.value;
    if (isEditAddress.value) {
      name.text = currentAddress!.name;
      numberPhone.text = currentAddress.phone;
      address.text = currentAddress.address;
      idAddressChoose = currentAddress.idAddress;
      statusAddressChoose = currentAddress.status;
    } else {
      name.clear();
      numberPhone.clear();
      address.clear();
      idAddressChoose = "";
      statusAddressChoose = 0;
    }
  }

  Future<void> getDataAddress() async {
    isLoading.value = true;
    addresses = await _addressDatabase.getAddress(idUser);
    if (addresses == null) {
      isAddressNull.value = true;
    } else {
      isAddressNull.value = false;
    }
    isLoading.value = false;
  }

  Future<void> changeAddressChose(Address address) async {
    isLoading.value = true;
    bool isChange = false;
    for (var element in addresses!) {
      if (element.idAddress == address.idAddress && element.status == 0) {
        isChange = true;
        await _addressDatabase.editAddress(idUser, address.idAddress,
            address.name, address.phone, address.address, address.status, true);
      }
      if (element.idAddress != address.idAddress && element.status == 1) {
        isChange = true;
        await _addressDatabase.editAddress(idUser, element.idAddress,
            element.name, element.phone, element.address, element.status, true);
      }
    }
    if (isChange) {
      await getDataAddress();
    }
    isLoading.value = false;
  }

  Future<void> deleteAddress() async {
    isLoading.value = true;
    bool isSuccess =
        await _addressDatabase.deleteAddress(idUser, idAddressChoose);
    Get.showSnackbar(SnackbarWidget.snackBarWidget(
      title: isSuccess ? "Success" : "Fail",
      message: isSuccess ? "Delete address successed" : "Delete address failed",
      isSuccess: isSuccess,
    ));

    if (isSuccess) {
      changeIsEditAddress(null);
      await getDataAddress();
    }
  }

  Future<void> editAddress() async {
    isLoading.value = true;
    await _addressDatabase.editAddress(idUser, idAddressChoose, name.text,
        numberPhone.text, address.text, statusAddressChoose, false);
    await getDataAddress();
    changeIsEditAddress(null);
    isLoading.value = false;
  }

  Future<void> addAddressUser() async {
    if (name.text == "" || numberPhone.text == "" || address.text == "") {
      Get.showSnackbar(
        SnackbarWidget.snackBarWidget(
            title: "Fail",
            message: "Not filled in all information",
            isSuccess: false),
      );
    } else {
      isLoading.value = true;
      bool isSuccess = await _addressDatabase.addAddressUser(
            idUser,
            name.text,
            numberPhone.text,
            address.text,
          ) ==
          "Success";
      if (isSuccess) {
        SnackbarWidget.snackBarWidget(
          title: "Success",
          message: "Add adress successed",
          isSuccess: true,
        );
        changeIsAddAddress();
        await getDataAddress();
      } else {
        SnackbarWidget.snackBarWidget(
          title: "Fail",
          message: "Add adress Failed",
          isSuccess: false,
        );
      }
    }
    isLoading.value = false;
  }
}
