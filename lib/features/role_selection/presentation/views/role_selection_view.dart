import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/extension/spacing_extension.dart';
import '../../../../core/services/get_it_service.dart';
import '../components/role_card.dart';
import '../components/role_selection_bottom_bar.dart';
import '../components/role_selection_header.dart';
import '../../logic/role_selection_cubit.dart';
import '../../logic/role_selection_state.dart';

class RoleSelectionView extends StatelessWidget {
  const RoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RoleSelectionCubit>(),
      child: const _RoleSelectionViewBody(),
    );
  }
}

class _RoleSelectionViewBody extends StatelessWidget {
  const _RoleSelectionViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RoleSelectionCubit>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<RoleSelectionCubit, RoleSelectionState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const RoleSelectionHeader(),
                        32.verticalSpace,
                        ...cubit.roles.map(
                          (item) {
                            final isSelected = state.selectedRole == item.role;
                            return RoleCard(
                              item: item,
                              isSelected: isSelected,
                              onTap: () => cubit.selectRole(item.role),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                RoleSelectionBottomBar(
                  isEnabled: state.hasSelection,
                  onConfirm: () => cubit.confirmRole(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
