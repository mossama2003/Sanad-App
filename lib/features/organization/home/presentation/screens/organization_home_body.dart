import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/organization_home_cubit.dart';

import '../widgets/organization_home_navbar_widget.dart';

class OrganizationHomeBody extends StatelessWidget {
  const OrganizationHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationHomeCubit, OrganizationHomeState>(
      builder: (context, state) {
        final cubit = OrganizationHomeCubit.get(context);

        return Scaffold(
          body: cubit.currentScreen,
          bottomNavigationBar: OrganizationHomeNavbarWidget(
            selected: cubit.selectedItem,
            onTap: cubit.updateSelectedNavbarItem,
          ),
        );
      },
    );
  }
}
