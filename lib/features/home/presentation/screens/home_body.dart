import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/home_cubit.dart';

import '../widgets/home_navbar_widget.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        return Scaffold(
          body: cubit.currentScreen,
          bottomNavigationBar: HomeNavbarWidget(
            selected: cubit.selectedItem,
            onTap: cubit.updateSelectedNavbarItem,
          ),
        );
      },
    );
  }
}
