import 'package:flutter/material.dart';

import '../../../../core/constant/app_size.dart';
import '../../../../core/style/app_colors.dart';
import '../../data/enums/home_navbar_enum.dart';

class HomeNavbarWidget extends StatelessWidget {
  const HomeNavbarWidget({
    super.key,
    required this.selected,
    required this.onTap,
  });

  final HomeNavbarItem selected;
  final ValueChanged<HomeNavbarItem> onTap;

  List<HomeNavbarItem> get _items => HomeNavbarItem.values;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(1.5, 0),
            color: AppColors.grey.withValues(alpha: 0.35),
            blurRadius: 3,
          ),
        ],
        // border: Border(
        //   top: BorderSide(
        //     color: AppColors.grey.withValues(alpha: 0.5),
        //     width: 0.5,
        //   ),
        // ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        elevation: 8,
        currentIndex: _items.indexOf(selected),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        selectedFontSize: AppSize.font(13),
        unselectedFontSize: AppSize.font(13),
        onTap: (index) {
          onTap(_items[index]);
        },
        items: _items.map((item) => item.buildItem(item == selected)).toList(),
      ),
    );
  }
}
