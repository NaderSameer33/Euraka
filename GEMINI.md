# Project Guidelines & Rules

## 1. Strict RTL (Right-to-Left) UI Direction
- The application language is Arabic and must strictly enforce Right-to-Left (RTL) layout everywhere.
- In any `Row` or horizontal flex layout under RTL:
  - First child (`index 0`) renders on the **RIGHT** (start).
  - Last child renders on the **LEFT** (end).
  - Back buttons and leading elements on the right must be placed **first** in the `Row`.
  - Trailing elements (badges, count chips, close icons, action menus) on the left must be placed **last** in the `Row`.
  - NEVER use `MainAxisAlignment.end` to align Arabic labels to the right; in RTL, `end` aligns to the **LEFT**. Use `MainAxisAlignment.start` or default.
  - Dropdown select boxes must place the text on the **right** (first) and the chevron down arrow on the **left** (last).
  - Card detail rows with Arabic text and trailing icons must place text on the right and icons on the left.
  - Wrap chips with remove/close buttons must place the text on the right and the close button on the left.

## 2. Zero Comments Policy
- NEVER add comments (`//` or `/* */`) to any Dart code files.

## 3. Styling & Typography
- Always use `AppStyles` exclusively for all text styles.
- Always use `Theme.of(context)` and `colorScheme` for theming and colors. Never use `isDark` or manual brightness toggles.
- Always use `flutter_screenutil` dimensions (`.w`, `.h`, `.sp`, `.r`).

