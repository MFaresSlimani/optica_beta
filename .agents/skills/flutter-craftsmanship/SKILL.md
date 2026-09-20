---
name: flutter-craftsmanship
description: >-
  Professional Flutter UI craftsmanship standards that prevent "AI slop".
  Enforces an 8-point spatial system, tactile micro-interactions, thumb-zone ergonomics,
  human typography hierarchy, theme depth, and platform-native polish.
---

# Flutter UI Craftsmanship: The "Anti-AI-Slop" Manifesto

## 1. What Defines "AI Slop" in Mobile UI
AI models generate the "statistical average" of beginner tutorials unless strictly constrained. Typical hallmarks of AI slop:
- **Magic numbers**: Random padding like `EdgeInsets.only(top: 17, left: 13)` instead of an 8-point grid.
- **Generic gradients & purple cards**: Overused saturated purple/blue gradients with heavy, dark drop shadows.
- **Box-in-a-box syndrome**: Wrapping every single text widget in an elevated Card with rigid borders.
- **Web-first thinking on mobile**: Placing primary actions at the top corners outside thumb reach, ignoring notch/home bar insets (`SafeArea`), and hardcoding rigid widths (`width: 300`) that overflow on standard 360-390px screens.
- **Lifeless interactions**: Static buttons with no press depression, no haptic feedback, and abrupt screen cuts instead of smooth Cupertino slides.
- **Dead empty states**: A blank white square or bare text `Text('No data')`.

---

## 2. The 7 Pillars of Human-Crafted Mobile UI

### Pillar 1: The 8-Point Spatial Grid
Never use arbitrary padding integers. Every margin, padding, height, and spacing must be a multiple of 4 or 8:
- `4px`: Micro-spacing (badge padding, icon-text gap)
- `8px`: Tight spacing (between related lines or subtitle)
- `12px`: Compact gap (between elements in a card)
- `16px`: Standard gutter / screen horizontal padding
- `20px - 24px`: Section separator
- `32px - 48px`: Major landmark separation

### Pillar 2: Thumb-Zone Ergonomics
- **Bottom-Heavy Primary Actions**: Sticky bottom action bar or floating action button rather than putting critical submit buttons above the fold or in corners.
- **Minimum 48x48dp Touch Targets**: Wrap small icons in `IconButton`, or add `padding: EdgeInsets.all(8)` so thumbs never miss.
- **Dismissible Overlays**: Bottom sheets with drag handles (`showModalBottomSheet(isScrollControlled: true)`) instead of cramped full-screen dialogs.

### Pillar 3: Typographic Hierarchy & Letterspacing
Never use uniform font weights and colors. Every screen must have a 4-tier visual hierarchy:
1. **Eyebrow / Overline**: `fontSize: 11-12, fontWeight: FontWeight.bold, letterSpacing: 1.0, textTransform: uppercase, color: textSubtle`
2. **Page / Card Title**: `fontSize: 20-24, fontWeight: FontWeight.bold, color: textPrimary`
3. **Body Text**: `fontSize: 15-16, height: 1.4, color: textSecondary`
4. **Metadata / Caption**: `fontSize: 13, color: textMuted`

### Pillar 4: Tactile Feedback & Micro-Interactions
Human-crafted apps feel alive and physical:
- **Haptics on Action**: Call `HapticFeedback.lightImpact()` on button presses, toggles, and item additions.
- **Press Scale / Bounce**: Use `AnimatedScale` or `AnimatedContainer` (200ms `Curves.easeOutCubic`) on active items.
- **Scroll Physics**: Always set `physics: const BouncingScrollPhysics()` on iOS and mobile lists.
- **Transitions**: Use `Transition.cupertino` for smooth horizontal push-and-pop instead of instant cut transitions.

### Pillar 5: Layered Surface Depth (Not Heavy Shadows)
Instead of harsh black drop shadows (`BoxShadow(color: Colors.black, blurRadius: 10)`):
- Use subtle **tinted borders**: `Border.all(color: AppColors.accent.withValues(alpha: 0.2), width: 1.0)`
- Soft ambient glow: `BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04), blurRadius: 10, offset: Offset(0, 3))`
- Layered darkness in dark mode: Background (`#0B2C33`) -> Card Surface (`#0F363F`) -> Input/Chip Surface (`#14414B`).

### Pillar 6: Rich, Intentional Empty States
Empty states are design opportunities:
- Muted circular icon background (`radius: 28, color: accent.withValues(alpha: 0.15)`)
- Friendly, reassuring title (`"No orders yet"`)
- Actionable recovery subtitle (`"Configure your lenses above and tap 'Add to Order' to begin."`)

### Pillar 7: Fluid Adaptability
- Never hardcode screen-spanning widths (`width: 380`). Always use `Expanded`, `Flexible`, or `double.infinity` within bounded parent constraints.
- Always handle text overflow with `maxLines` and `overflow: TextOverflow.ellipsis`.
- Support Dark Mode and Light Mode natively using theme tokens.
