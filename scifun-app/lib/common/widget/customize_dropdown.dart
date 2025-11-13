import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:thilop10_3004/common/cubit/select_cubit.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';

class CustomizeDropdown<T> extends StatefulWidget {
  CustomizeDropdown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
    required this.hintText,
    this.paddingDropdownItems,
    this.paddingButton,
    this.backgroundColorButton = Colors.white,
    this.borderRadiusButton,
    this.borderButton,
    this.suffixIconActive,
    this.hasError = false,
    this.suffixIconInActive,
    this.offset,
    this.maxHeightDropdown,
    this.shadowColor = Colors.grey,
    this.prefixIcon,
  }) : assert(value == null || items.containsKey(value),
            'Items are not contains value !');
  final bool hasError;
  final Map<T, String> items;
  final T? value;
  final void Function(T?) onChanged;
  final String hintText;
  final EdgeInsetsGeometry? paddingDropdownItems;
  final EdgeInsetsGeometry? paddingButton;
  final Color backgroundColorButton;
  final BorderRadius? borderRadiusButton;
  final BoxBorder? borderButton;
  final IconData? suffixIconActive;
  final IconData? suffixIconInActive;
  final Offset? offset;
  final double? maxHeightDropdown;
  final Color shadowColor;
  final Widget? prefixIcon;

  @override
  State<CustomizeDropdown<T>> createState() => _CustomizeDropdownState<T>();
}

class _CustomizeDropdownState<T> extends State<CustomizeDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  // Toggle dropdown
  void _toggleDropdown(BuildContext context) {
    if (_overlayEntry == null) {
      _showDropdown(context);
    } else {
      _removeDropdown(context);
    }
  }

  // Display dropdown
  void _showDropdown(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;

    final List<MapEntry<T, String>> convertItems =
        widget.items.entries.map((el) => MapEntry(el.key, el.value)).toList();

    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _removeDropdown(context),
        child: Stack(
          children: [
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: widget.offset ?? Offset(0, size.height + 8.h),
                showWhenUnlinked:
                    false, // * Trong trường hợp anchor bị kill đi thì widget gán vào anchor sẽ mất theo
                child: Container(
                  height: widget.maxHeightDropdown ?? 250.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: widget.borderRadiusButton ??
                          BorderRadius.circular(12.r),
                      border: Border.all(width: 1.w, color: AppColor.border),
                      boxShadow: [
                        BoxShadow(
                          color: widget.shadowColor,
                          blurRadius: 12.r,
                        ),
                      ]),
                  child: ClipRRect(
                    borderRadius: widget.borderRadiusButton ??
                        BorderRadius.circular(12.r),
                    child: Scrollbar(
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (_, index) => Divider(
                          height: 1.h,
                          color: Colors.grey,
                        ),
                        itemBuilder: (_, index) {
                          final bool isSelected =
                              convertItems[index].key == widget.value;
                          return CupertinoButton(
                            color:
                                isSelected ? AppColor.primary600 : Colors.white,
                            minSize: 0,
                            borderRadius: BorderRadius.zero,
                            padding: widget.paddingDropdownItems ??
                                EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 11.h,
                                ),
                            alignment: Alignment.centerLeft,
                            onPressed: () {
                              widget.onChanged(convertItems[index].key);
                              _removeDropdown(context);
                            },
                            child: Row(
                              spacing: 4.w,
                              children: [
                                Flexible(
                                  child: Text(
                                    convertItems[index].value,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColor.hurricane950,
                                        ),
                                  ),
                                ),
                                Visibility(
                                  visible: isSelected,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: convertItems.length,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (_overlayEntry != null) {
      Overlay.of(context).insert(_overlayEntry!);
      context.read<SelectCubit<bool>>().select(true);
    }
  }

  // This function is used to remove dopdown
  void _removeDropdown(BuildContext context) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    context.read<SelectCubit<bool>>().select(false);
  }

  // Get value or hint text
  String _getHintOrValue() {
    return widget.value != null
        ? widget.items.entries
                .where((el) => el.key == widget.value)
                .firstOrNull
                ?.value ??
            widget.hintText
        : widget.hintText;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: BlocProvider(
        create: (context) => SelectCubit<bool>(false),
        child: BlocBuilder<SelectCubit<bool>, bool>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () => _toggleDropdown(context),
              child: Container(
                alignment: Alignment.center,
                padding: widget.paddingButton ??
                    EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                decoration: BoxDecoration(
                  borderRadius:
                      widget.borderRadiusButton ?? BorderRadius.circular(12.r),
                  color: widget.backgroundColorButton,
                  border: widget.borderButton ??
                      Border.all(
                        width: 1.w,
                        color: widget.hasError
                            ? Colors.red // ✅ báo đỏ
                            : AppColor.border,
                      ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: widget.prefixIcon != null,
                      child: widget.prefixIcon == null
                          ? SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: widget.prefixIcon,
                            ),
                    ),
                    Expanded(
                      child: Text(
                        _getHintOrValue(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: widget.value != null
                                  ? null
                                  : (widget.hasError
                                      ? Colors.red
                                      : AppColor.hurricane900),
                            ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      state
                          ? (widget.suffixIconActive ?? Icons.expand_less)
                          : (widget.suffixIconInActive ?? Icons.expand_more),
                      size: 22.sp,
                      color: state
                          ? AppColor.primary50
                          //TODO: Đổi màu icon drop
                          : AppColor.primary600,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
