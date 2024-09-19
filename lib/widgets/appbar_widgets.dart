import 'package:flutter/material.dart';
import 'package:letter_a/styles/colors_style.dart';
import 'package:letter_a/styles/typography_style.dart';

class LAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  final Color? bgColor;
  final PreferredSizeWidget? bottom;
  final String? useFor;

  LAppBar({
    required this.leading,
    this.title,
    required this.actions,
    this.bgColor,
    this.bottom,
    this.useFor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: leading,
      ),
      title: Padding(
        padding: useFor == 'logoPlusTabbar'
            ? EdgeInsets.only(left: 0)
            : const EdgeInsets.only(left: 16.0),
        child: useFor == 'logoPlusTabbar'
            ? Center(
                child: Image.asset(
                    'assets/images/img_logo_transparent_white.png',
                    width: 120))
            : Text(
                '$title',
                style: LText.H3(
                    color: bgColor == LColors.secondary ||
                            bgColor == LColors.primary ||
                            bgColor == LColors.black
                        ? LColors.white
                        : LColors.black),
              ),
      ),
      actions: actions,
      bottom: bottom != null
          ? bottom
          : useFor == 'announcementC' || useFor == 'announcementV'
              ? TabBar(
                  indicatorColor: LColors.primary,
                  indicatorWeight: 4,
                  labelColor: LColors.white,
                  unselectedLabelColor: LColors.white.withOpacity(0.72),
                  tabs: [
                    Tab(
                        icon: Icon(Icons.campaign_outlined),
                        text: 'Announcements'),
                    Tab(
                        icon: Icon(Icons.star_border_outlined),
                        text: 'For You'),
                  ],
                )
              : useFor == 'announcementA'
                  ? TabBar(
                      tabs: [
                        Tab(
                            icon: Icon(Icons.notifications_active_outlined),
                            text: 'All Notif'),
                        Tab(
                            icon: Icon(Icons.campaign_outlined),
                            text: 'Announcements'),
                        Tab(
                            icon: Icon(Icons.star_border_outlined),
                            text: 'For You'),
                      ],
                    )
                  : null,
    );
  }

  @override
  Size get preferredSize => useFor == 'announcementC' ||
          useFor == 'announcementV' ||
          useFor == 'announcementA' ||
          useFor == 'logoPlusTabbar'
      ? Size.fromHeight(120)
      : Size.fromHeight(kToolbarHeight);
}
