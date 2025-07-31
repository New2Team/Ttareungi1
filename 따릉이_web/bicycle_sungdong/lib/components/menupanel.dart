import 'package:flutter/material.dart';

class MenuPanel extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onMenuSelected;

  const MenuPanel({
    super.key,
    required this.selectedIndex,
    required this.onMenuSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 220,
      child: Container(
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green.shade700,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "따릉이 정보",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 🔸 메뉴 항목
            _buildMenuButton(context, 0, '공지사항', Icons.campaign),

          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, int idx, String label, IconData icon) {
    final isSelected = selectedIndex == idx;

    return InkWell(
      onTap: () => onMenuSelected(idx),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: isSelected ? Colors.green.shade100 : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.green.shade800 : Colors.black54),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.green.shade900 : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}