import 'package:flutter/material.dart';

class NotePopUpMenu extends StatefulWidget {
  const NotePopUpMenu(
      {Key? key,
      required this.value,
      required this.share,
      required this.delete})
      : super(key: key);

  final String value;
  final void Function() share, delete;

  @override
  State<NotePopUpMenu> createState() => _NotePopUpMenuState();
}

class _NotePopUpMenuState extends State<NotePopUpMenu> {
  late Object? _value;
  late void Function() _share, _delete;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _share = widget.share;
    _delete = widget.delete;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (newValue) {
        setState(() {
          _value = newValue;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
          value: 'Share',
          child: GestureDetector(
            onTap: _share,
            child: const Text('Share'),
          ),
        ),
        PopupMenuItem(
          value: 'Delete',
          child: GestureDetector(
            onTap: _delete,
            child: Text('Delete'),
          ),
        ),
      ],
    );
  }
}
