import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/app_color.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final ValueChanged<String>? onSearchChanged;
  final double height;
  final bool showBackButton;
  final List<Widget> extraActions;

  const SearchAppBar({
    super.key,
    required this.title,
    this.onSearchChanged,
    this.height = 90.0,
    this.showBackButton = false,
    this.extraActions = const [],
  });

  @override
  Size get preferredSize => Size(double.infinity, height);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  String get title => widget.title;
  ValueChanged<String>? get onSearchChanged => widget.onSearchChanged;
  double get height => widget.height;
  bool get showBackButton => widget.showBackButton;
  List<Widget> get extraActions => widget.extraActions;

  final queryController = TextEditingController();
  final queryFocusNode = FocusNode();
  final _controller = StreamController<String>();
  Timer? _debounceTimer;

  bool isSearching = false;

  @override
  void initState() {
    _controller.stream.listen(_onQueryChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: height,
      padding: showBackButton
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: AlignmentDirectional.bottomCenter,
      decoration: const BoxDecoration(
        color: AppColor.primary,
      ),
      child: isSearching
          ? TextField(
              focusNode: queryFocusNode,
              controller: queryController,
              onChanged: _controller.add,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffix: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: _onCloseQuery,
                ),
                contentPadding: const EdgeInsets.only(bottom: 5.0),
              ),
              style: textTheme.titleLarge?.copyWith(color: Colors.white),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showBackButton)
                  IconButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onSearchChanged != null)
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: _onOpenQuery,
                  ),
                ...extraActions,
              ],
            ),
    );
  }

  @override
  void dispose() {
    queryController.dispose();
    queryFocusNode.dispose();
    _controller.close();
    super.dispose();
  }

  void _onOpenQuery() {
    setState(() => isSearching = true);
    queryFocusNode.requestFocus();
  }

  void _onCloseQuery() {
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      isSearching = false;
    });
    queryController.clear();
    onSearchChanged?.call('');
  }

  void _onQueryChanged(String query) async {
    _debounceTimer?.cancel();
    _debounceTimer = null;

    _debounceTimer = Timer(const Duration(seconds: 2), () {
      onSearchChanged?.call(query);
    });
  }
}
