import 'package:e_commerce/core/di/injection.dart';
import 'package:e_commerce/featchers/AUTH/data/repos/auth_repo.dart';
import 'package:e_commerce/featchers/AUTH/presentation/cubits/login/login_cubit.dart';
import 'package:e_commerce/featchers/home/presentation/views/widgets/ProfileBody.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profileview extends StatelessWidget {
  const Profileview({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // نقوم بإنشاء الـ Cubit وتمرير الـ Repo المسجل في getIt
      create: (context) => LoginCubit(getIt<AuthRepo>()),
      child: const ProfileBody(),
    );
  }
}