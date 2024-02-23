import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingButtonWidget extends StatelessWidget {
  const SettingButtonWidget({super.key, required this.title, this.subtitle, required this.icon, required this.onPressed});

  final String title;
  final String? subtitle;
  final String icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              SvgPicture.asset(
                'assets/svg/setting/$icon.svg',
              ),
            ],
          ),
          if (subtitle != null)
            Column(
              children: [
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
