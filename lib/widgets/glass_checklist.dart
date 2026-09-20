import 'package:flutter/material.dart';

class GlassChecklistTile extends StatelessWidget {
  final String glass;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const GlassChecklistTile({
    super.key,
    required this.glass,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.0),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              glass,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Icon(
            isChecked ? Icons.check_circle : Icons.circle_outlined,
            color: isChecked
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    );
  }
}
