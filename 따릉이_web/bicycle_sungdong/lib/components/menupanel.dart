import 'package:flutter/material.dart';

class MenuPanel extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;
  const MenuPanel({super.key, required this.selectedIndex, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    // 👇 Drawer로 변경!
    return Drawer(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(child: Text("메뉴", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22))),
          _buildMenuButton(context, 0, '공지사항', Icons.campaign),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, int idx, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: TextStyle(fontSize: 18)),
      selected: selectedIndex == idx,
      selectedTileColor: Colors.deepPurple.shade50,
      onTap: () => onMenuSelected(idx),
    );
  }
}

