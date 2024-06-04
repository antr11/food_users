import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_users/global/global.dart';
import 'package:food_users/models/address.dart';
import 'package:food_users/widgets/simple_app_bar.dart';
import 'package:food_users/widgets/text_field.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;
  getUserLocationAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    position = newPosition;

    placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);

    Placemark pMark = placemarks![0];

    String fullAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;
  }

  SaveAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "kittenGo",
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          //save address
          if (formKey.currentState!.validate()) {
            final model = Address(
              name: _name.text.trim(),
              state: _state.text.trim(),
              fullAddress: _completeAddress.text.trim(),
              phoneNumber: _phoneNumber.text.trim(),
              flatNumber: _flatNumber.text.trim(),
              city: _city.text.trim(),
              lat: position!.latitude,
              lng: position!.longitude,
            ).toJson();
            FirebaseFirestore.instance
                .collection("users")
                .doc(sharedPreferences!.getString("uid"))
                .collection("userAddress")
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(model)
                .then(
              (value) {
                Fluttertoast.showToast(msg: "Địa chỉ đã được lưu");
                formKey.currentState!.reset();
              },
            );
          }
        },
        label: const Text("lưu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Lưu địa chỉ mới:",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                color: Colors.black,
                size: 35,
              ),
              title: SizedBox(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: "Địa chỉ của bạn ?",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              label: const Text(
                "Get my Location",
                style: TextStyle(color: Colors.black),
              ),
              icon: const Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.cyan),
                  ),
                ),
              ),
              onPressed: () {
                //getCurrentLocationWithAddress
                getUserLocationAddress();
              },
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Tên",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "SDT",
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: "Thành phố",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "Quận/huyện",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Địa chỉ",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Địa chỉ chi tiết",
                    controller: _completeAddress,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
