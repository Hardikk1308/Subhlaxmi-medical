import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchableDropdown<T> extends StatefulWidget {
  final T? value; // Currently selected value
  final List<T> items; // List of items
  final ValueChanged<T?>? onChanged; // Callback for value change
  final String Function(T) itemBuilder; // Function to build item label
  final Icon Function(T)? itemIconBuilder; // Optional function to build item icon
  final String label; // Label to display above the dropdown
  final String textOptions; // Hint text for dropdown
  final String? Function(T?)? validator; // Validator function

  const CustomSearchableDropdown({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.itemIconBuilder,
    required this.label,
    this.value,
    this.onChanged,
    this.textOptions = 'Select an option',
    this.validator,
  });

  @override
  State<CustomSearchableDropdown<T>> createState() =>
      _CustomSearchableDropdownState<T>();
}

class _CustomSearchableDropdownState<T>
    extends State<CustomSearchableDropdown<T>> {
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  void _openSearchDialog(BuildContext context) {
    showSearch(
      context: context,
      delegate: _DropdownSearchDelegate(
        items: widget.items,
        itemLabelBuilder: widget.itemBuilder,
        itemIconBuilder: widget.itemIconBuilder,
        onSelected: (selected) {
          setState(() {
            _selectedValue = selected;
            Navigator.pop(context);
          });
          if (widget.onChanged != null) {
            widget.onChanged!(selected);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(widget.label, style: TextStyle(fontSize: 14)),
        SizedBox(height: 8.h),

        // Searchable Dropdown
        GestureDetector(
          onTap: () => _openSearchDialog(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded( // Ensures the text doesn't overflow
                  child: Text(
                    _selectedValue != null
                        ? widget.itemBuilder(_selectedValue as T)
                        : widget.textOptions,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _selectedValue != null ? Colors.black : Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Ensures ellipsis for long text
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),


        // Validation
        if (widget.validator != null)
          Visibility(
            visible: widget.validator!(_selectedValue) != null,
            child: Padding(
              padding: EdgeInsets.only(top: 4.h,),
              child: Text(
                widget.validator!(_selectedValue) ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),

        SizedBox(height: 6.h,),

      ],
    );


  }
}

class _DropdownSearchDelegate<T> extends SearchDelegate<T?> {
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final Icon Function(T)? itemIconBuilder;
  final ValueChanged<T?> onSelected;

  _DropdownSearchDelegate({
    required this.items,
    required this.itemLabelBuilder,
    this.itemIconBuilder,
    required this.onSelected,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildFilteredList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildFilteredList();
  }

  Widget _buildFilteredList() {
    final filteredItems = items
        .where((item) =>
        itemLabelBuilder(item).toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return ListTile(
          leading: itemIconBuilder?.call(item),
          title: Text(itemLabelBuilder(item)),
          onTap: () {
            onSelected(item);
            // close(context, item);
          },
        );
      },
    );
  }
}
