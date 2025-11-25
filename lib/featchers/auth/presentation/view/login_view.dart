// ignore_for_file: public_member_api_docs, sort_constructors_first
// Hide conflicting Column from drift
import 'package:e_commerce/core/functions_helper/build_overlay_bar.dart';
import 'package:e_commerce/core/functions_helper/routs.dart';
import 'package:e_commerce/core/utils/app_colors.dart';
import 'package:e_commerce/core/utils/app_imags.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_state.dart';
import 'package:e_commerce/featchers/AUTH/widgets/build_app_bar.dart';
import 'package:e_commerce/featchers/AUTH/widgets/cusstom_textfield.dart';
import 'package:e_commerce/featchers/AUTH/widgets/customProgressLoading.dart';
import 'package:e_commerce/featchers/AUTH/widgets/password_field.dart';
import 'package:e_commerce/featchers/AUTH/widgets/socialbutton.dart';
import 'package:e_commerce/featchers/auth/widgets/custombotton.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart'; // Single import for Flutter
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: 'تسجيل دخول', showBackButton: false),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          }
          if (state is LoginFailure) {
            showBar(context, state.message);
          }
        },
        builder: (context, state) {
          return CustomProgresIndecatorHUD(
            isLoading: state is LoginLoading ? true : false,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      // Now correctly references Flutter's Column
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        CustomTextFormField(
                          onSaved: (value) {
                            email = value!;
                          },
                          hintText: 'البريد الإلكتروني',
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        PasswordField(
                          onSaved: (value) {
                            password = value!;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.forgotPassword);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets
                                  .zero, // يخلي الزر بشكل نص فقط بدون مساحة إضافية
                              minimumSize: Size(0, 0),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'نسيت كلمة .المرور؟',
                              style: TextStyle(
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        CustomButton(
                          text: 'تسجيل دخول',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              context
                                  .read<LoginCubit>()
                                  .signInWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                            } else {
                              setState(() {
                                autovalidateMode = AutovalidateMode.always;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'لا تمتلك حساب؟ ',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: 'قم بإنشاء حساب',
                                  style: TextStyle(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(
                                        context,
                                      ).pushReplacementNamed(AppRoutes.signup);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: const [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.0),
                              child: Text('أو', style: TextStyle(fontSize: 16)),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SocialButton(
                          onPressed: () {
                            context.read<LoginCubit>().signInWithGoogle();
                          },
                          icon: SvgPicture.asset(Assets.socialIconsGoogle),
                          text: 'تسجيل بواسطة جوجل',
                        ),
                        const SizedBox(height: 12),
                        // SocialButton(
                        //   icon: SizedBox(
                        //     width: 24,
                        //     height: 24,
                        //     child: SvgPicture.asset(Assets.vectorApple),
                        //   ),
                        //   text: 'تسجيل بواسطة أبل',
                        //   onPressed: () {},
                        // ),
                        // const SizedBox(height: 12),
                        // SocialButton(
                        //   icon: SvgPicture.asset(
                        //     Assets.facebook,
                        //     width: 40,
                        //     height: 20,
                        //   ),
                        //   text: 'تسجيل بواسطة فيسبوك',
                        //   onPressed: () {
                        //     context.read<LoginCubit>().signInWithFacebook();
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
