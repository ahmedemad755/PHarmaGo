import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/Features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/Features/profile/presentation/widgets/ProfileBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      // .value لأن LoginCubit سنجل-تون في getIt، ما ينفعش BlocProvider يقفلها لما الشاشة تتشال
      value: getIt<LoginCubit>(),
      child: const ProfileBody(),
    );
  }
}
