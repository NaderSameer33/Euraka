# Flutter Architecture & Coding Rules

## 1. Project Directory Structure

Strictly adhere to the following directory structure inside `lib/`:

```text
lib/
├── core/
│   ├── base/                     # Base classes (e.g., SafeCubit)
│   ├── caching/                  # Local storage (shared_pref_service, secure_storage_service)
│   ├── constants/                # App constants, keys, asset paths
│   ├── errors/                   # Failure and error handling models
│   ├── extension/                # Extensions (e.g., spacing_extension, context extensions)
│   ├── helper/                   # Global helper functions (helper_method.dart)
│   ├── routers/                  # App routing and navigation (app_routes, app_router_name)
│   ├── services/                 # Global services (api_service, get_it_service, fcm, notifications)
│   ├── theme/                    # App theme, app_colors, app_styles, app_font_weight
│   ├── utils/                    # Validators (app_validator.dart), formatters, helpers
│   └── widgets/                  # Reusable UI components (app_button, app_input, app_loading)
└── features/
    └── [feature_name]/
        ├── data/
        │   ├── models/           # Data models & JSON serialization
        │   └── repos/            # Repositories communicating with api_service
        ├── logic/
        │   ├── [feature]_cubit.dart
        │   └── [feature]_state.dart
        └── presentation/
            ├── views/            # Screen / Page widgets
            └── components/       # Feature-specific sub-widgets
```

---

## 2. Mandatory Core Reuse (Always Use Core)

- **Always prioritize and use files from `lib/core/`:**
  - **Colors & Styles:** Never hardcode colors (`Color(0xFF...)`) or inline `TextStyle`. Always use `AppColors` and `AppStyles` from `core/theme/`.
  - **UI Components:** Always reuse standard widgets from `core/widgets/` (`AppButton`, `AppInput`, `AppLoading`). Never recreate custom text fields, primary buttons, or loading indicators in features.
  - **Spacing & Layout:** Always use spacing extensions from `core/extension/spacing_extension.dart` (e.g., `16.verticalSpace`, `12.horizontalSpace`) and `flutter_screenutil` dimensions (`.w`, `.h`, `.r`, `.sp`).
  - **Validation:** Always use `AppValidator` from `core/utils/app_validator.dart` for form fields (phone, password, email, empty check).
  - **Services & Dependency Injection:** Always access singletons through `getIt<T>()` from `core/services/get_it_service.dart`.
  - **Networking:** Always use `ApiService` from `core/services/api_service.dart`.
  - **Storage:** Always use `SharedPrefService` for general preferences and `SecureStorageService` for sensitive tokens / credentials.
  - **State Management Base:** Always extend `SafeCubit` from `core/base/safe_cubit.dart` to prevent emitting states after cubit closure.

---

## 3. Strict DRY Principle (Zero Code Duplication)

- **No Duplicate Code:** Never write duplicate code or copy-paste identical logic/widgets across screens or features.
- **Rule of Reusability:**
  - If a widget or utility is used across multiple features, it **must** be extracted and placed into `lib/core/widgets/` or `lib/core/utils/`.
  - If a widget is used in multiple places within the same feature, it **must** be extracted into `features/[feature]/presentation/components/`.
  - If identical business logic or API handling appears more than once, extract it into a reusable helper method, base repository, or shared service.

---

## 4. Mandatory Dependencies

Whenever initiating a new feature or scaffolding code, ensure the following packages are utilized:

- **State Management:** `flutter_bloc`
- **Networking:** `dio`
- **Dependency Injection:** `get_it`
- **Storage:** `shared_preferences`, `flutter_secure_storage`
- **Environment & Security:** `flutter_dotenv`
- **UI & Responsiveness:** `flutter_screenutil`, `skeletonizer`, `toastification`
- **Debugging & Testing UI:** `device_preview`

---

## 5. Architectural & Implementation Rules

1. **State Management:** Always use `Cubit` (extending `SafeCubit`) inside `features/[feature]/logic/`.
2. **Separation of Concerns:** Never put API calls or business logic directly inside UI views. All data operations must flow through feature repositories in `data/repos/` consuming `ApiService`.
3. **Security & Secrets:** Sensitive values (tokens, credentials, API keys, base URLs) must never be hardcoded. Use `flutter_dotenv` with `.env` and `flutter_secure_storage`.
4. **Responsive UI:** Every dimension, padding, radius, and font size must use `flutter_screenutil` (`.w`, `.h`, `.r`, `.sp`).
5. **No Comments Rule:** **DO NOT write any comments in the code** (no `//` and no `/* */` comments). Code must be self-explanatory through clean naming conventions and clean architecture.
6. **Feature Completion & Git Workflow:** After finishing any feature, **ALWAYS ask the user** whether to push the branch, suggest a clean and professional commit message, and confirm with them before pushing.
7. **ThemeData & Theme-Driven Styling:** When supporting light and dark modes, always consume styling, surface colors, text colors, and borders directly through `ThemeData`, `Theme.of(context)`, and `Theme.of(context).colorScheme`. **NEVER use manual `isDark` checks** (e.g., `final isDark = ...` or ternary operators `isDark ? ... : ...`) inside UI components or widgets. All UI styling must be theme-driven and centralized in `AppTheme`.
8. **Pixel-Perfect Figma Replication & Layout Integrity:** Always build views strictly identical to the Figma design down to the smallest detail. **DO NOT swap or alter the order/positions of layout elements** (such as headers, buttons, cards, lists, and navigation). Ensure zero layout errors, zero overflow issues, and strict adherence to the visual hierarchy and structure defined in Figma.

Use the Figma MCP tool (download_figma_images) to export all image assets and icons from the provided Figma node/frame:

- Figma URL/Node: [https://www.figma.com/design/nDS0eiJHNkUFKPGHBb4MS8/Eureka?node-id=0-1&p=f&t=mBtODKOSzcw1RQdD-0]
- Target Directory: assets/images/ (or assets/icons/)
- Ensure the downloaded assets are properly formatted (PNG/SVG) and mapped correctly into the Flutter project's assets structure without manual intervention.

Before generating the UI for this screen:

1. Inspect our existing project design system in:
   - `lib/core/theme/` (or `AppColors`, `AppTextStyles`, `AppTheme`)
   - `lib/core/widgets/` (reusable buttons, custom text fields, cards)
2. Match every Figma color and typography style directly to our defined constants instead of hardcoding `Color(0x...)` or `TextStyle(...)`.
3. Reuse existing components (e.g., `CustomButton`, `CustomTextField`) wherever Figma components appear. If a Figma component has variants, map it to the corresponding widget properties.
