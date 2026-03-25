import 'package:e_commerce/core/functions_helper/valedator.dart';
import 'package:e_commerce/featchers/AUTH/widgets/cusstom_textfield.dart';
import 'package:e_commerce/featchers/checkout/domain/enteteis/order_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressInputSection extends StatefulWidget {
  const AddressInputSection({
    super.key,
    required this.formKey,
    required this.valueListenable,
  });

  final GlobalKey<FormState> formKey;
  final ValueListenable<AutovalidateMode> valueListenable;

  @override
  State<AddressInputSection> createState() => _AddressInputSectionState();
}

class _AddressInputSectionState extends State<AddressInputSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // ✅ يحافظ على الحالة

  // 🧠 نعرف الكنترولرز عشان القيم تفضل موجودة
  final TextEditingController nameController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    // تنظيف الكنترولرز
    nameController.dispose();
    // emailController.dispose();
    addressController.dispose();
    cityController.dispose();
    floorController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ ضروري مع AutomaticKeepAliveClientMixin
    return ValueListenableBuilder<AutovalidateMode>(
      valueListenable: widget.valueListenable,
      builder: (context, value, child) => SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          autovalidateMode: value,
          child: Column(
            children: [
              const SizedBox(height: 24),
CustomTextFormField(
  controller: nameController,
  onSaved: (value) {
    context.read<OrderInputEntity>().shippingAddressEntity.name = value!;
  },
  hintText: 'الاسم كامل (ثلاثي على الأقل)',
  textInputType: TextInputType.text,
  // تأكد أنك تنادي الدالة التي أنشأناها بالأعلى
  validator: (value) => Validators.validateName(value), 
),
              // const SizedBox(height: 16),
              // CustomTextFormField(
              //   controller: emailController,
              //   onSaved: (value) {
              //     context.read<OrderInputEntity>().shippingAddressEntity.email =
              //         value!;
              //   },
              //   hintText: 'البريد الإلكتروني',
              //   textInputType: TextInputType.emailAddress,
              //   validator: Validators.validateEmail,
              // ),
              // const SizedBox(height: 16),
                            CustomTextFormField(
                controller: cityController,
                onSaved: (value) {
                  context.read<OrderInputEntity>().shippingAddressEntity.city =
                      value!;
                },
                hintText: 'المدينه , القاهرة , الجيزة ...',
                textInputType: TextInputType.text,
                validator: Validators.validateCity,
              ),   
               const SizedBox(height: 16),
              CustomTextFormField(
                controller: addressController,
                onSaved: (value) {
                  context
                          .read<OrderInputEntity>()
                          .shippingAddressEntity
                          .address =
                      value!;
                },
                hintText: 'العنوان (شارع , عمارة , ...)',
                textInputType: TextInputType.text,
                validator: Validators.validateAddress,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: floorController,
                onSaved: (value) {
                  context.read<OrderInputEntity>().shippingAddressEntity.floor =
                      value!;
                },
                hintText: 'رقم الطابق , رقم الشقه ..',
                textInputType: TextInputType.text,
                validator: Validators.validateFloor,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: phoneController,
                onSaved: (value) {
                  context.read<OrderInputEntity>().shippingAddressEntity.phone =
                      value!;
                },
                hintText: 'رقم الهاتف',
                textInputType: TextInputType.number,
                validator: Validators.validatePhone,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
