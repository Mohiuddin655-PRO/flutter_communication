import 'package:flutter/material.dart';
import 'package:flutter_communication/feature/domain/entities/base_entity.dart';

import '../../domain/entities/user_entity.dart';
import 'text_view.dart';

class ItemUser extends StatelessWidget {
  final bool visible;
  final UserEntity item;
  final Function(UserEntity item)? onClick;

  const ItemUser({
    Key? key,
    required this.item,
    this.visible = true,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ListTile(
        onTap: () => onClick?.call(item),
        title: TextView(
          text: item.name,
        ),
        subtitle: TextView(
          text: item.email,
        ),
        leading: CircleAvatar(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: item.photo.isValid
                ? Image.network(
                    item.photo,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/img/img_user.jpeg",
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }
}
