import 'package:flutter/material.dart';
import 'package:flutter_communication/core/common/responses/response.dart';
import 'package:flutter_communication/dependency_injection.dart';
import 'package:flutter_communication/feature/domain/entities/message_entity.dart';
import 'package:flutter_communication/feature/domain/use_cases/chat/live_message_use_case.dart';
import 'package:flutter_communication/other/widgets/message_tile.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final liveMessage = locator<LiveMessageUseCase>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: liveMessage.call(),
      builder: (context, AsyncSnapshot snapshot) {
        print("Message : $snapshot");
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            final response = snapshot.data as Response;
            return _Messages(
              items: response.result,
            );
        }
      },
    );
  }
}

class _Messages extends StatelessWidget {
  final List<MessageEntity> items;

  const _Messages({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return MessageTile(
          item: item,
        );
      },
    );
  }
}
