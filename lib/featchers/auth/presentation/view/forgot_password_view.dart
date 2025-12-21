import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/vereficationotp/vereficationotp_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/vereficationotp/vereficationotp_state.dart';
import 'package:e_commerce/featchers/AUTH/widgets/cusstom_textfield.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController phoneController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formKey,
            child: BlocConsumer<OTPCubit, OTPState>(
              listener: (context, state) {
                if (state is OTPLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) =>
                        const Center(child: CircularProgressIndicator()),
                  );
                } else {
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pop(); // close loading
                }

                if (state is OTPCodeSent) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال رمز التحقق')),
                  );

                  // تأكد من تمرير الرقم من الحالة أو متغير محفوظ
                  final phone =
                      context.read<OTPCubit>().currentPhoneNumber ??
                      ''; // أضفها في Cubit

                  Navigator.pushNamed(
                    context,
                    AppRoutes.otp,
                    arguments: {
                      'cubit': context.read<OTPCubit>(),
                      'phone': phone,
                    },
                  );
                } else if (state is OTPError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is OTPVerified) {
                  // في حالة التحقق التلقائي
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم التحقق بنجاح')),
                  );
                }
              },
              builder: (context, state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'نسيان كلمة المرور',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'لا تقلق، ما عليك سوى كتابة رقم هاتفك وسنرسل رمز التحقق.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.darkgrey600,
                        ),
                      ),
                      const SizedBox(height: 32),
                      CustomTextFormField(
                        controller: phoneController,
                        hintText: 'ادخل رقم هاتفك',
                        textInputType: TextInputType.phone,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final rawPhone = phoneController.text.trim();
                              // التأكد من إزالة الصفر من البداية وإضافة +20
                              final formattedPhone = rawPhone.startsWith('+')
                                  ? rawPhone
                                  : '+20${rawPhone.startsWith('0') ? rawPhone.substring(1) : rawPhone}';

                              context.read<OTPCubit>().sendOTP(formattedPhone);
                            }
                          },
                          label: 'ارسال رمز التحقق',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
