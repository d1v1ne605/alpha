import 'package:alpha/presentation/view_models/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/base/base_view.dart';
import '../../../../injection/injector.dart';
import 'api_key_item_card.dart';

class MyApiKeyListScreen extends StatelessWidget {
  const MyApiKeyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModelBuilder: () => getIt<ProfileViewModel>(),
      autoDispose: false,
      builder: (context, viewModel, child) {
        return ListView.builder(
          itemCount: viewModel.apiKeys.length,
          itemBuilder: (context, index) {
            final apiKey = viewModel.apiKeys[index];
            return ApiKeyItemCard(apiKey: apiKey, index: index);
          },
        );
      },
    );
  }
}
