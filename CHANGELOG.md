# Changelog

All notable changes to this package will be documented here.

## [1.2.0] - 2025-05-28

### BREAKING

- The `verifyCard` method has been renamed to `verifyCardNumber` for better clarity and consistency with the package's API.

### Added

- Comprehensive Dartdoc comments for all public APIs (classes, methods, fields) to improve usability and achieve a high score on pub.dev.
- A new getter `IranianBanks.allBanks` to provide access to the complete, unmodifiable list of bank data.

### Changed

- The example application is now fully interactive, featuring `TextField`s and a `TabBar` for a better demonstration of the package's capabilities.
- Added real-time validation feedback (icons) to the example app's UI.
- Improved and standardized the internal bank data list:
  - Data for merged banks (Ansar, Ghavvamin, etc.) now correctly points to Bank Sepah, ensuring consistency while maintaining recognition of old card numbers.
  - The list is now sorted alphabetically for easier maintenance.
- Refactored `BankInfoView` to eliminate redundant code in logo path generation, making it more efficient.

### Fixed

- **Critical:** Replaced the buggy `verifyIBAN` implementation with a robust and correct MOD-97 algorithm.
- Corrected incorrect IBAN codes for several banks (e.g., Bank Day, Resalat Bank).
- Resolved numerous data conflicts, including duplicate `bank_name` identifiers and conflicting card number prefixes.
- Fixed the `allBanks` getter, which previously returned an empty list.
- Corrected various typos and informational errors in the bank database.

## [1.1.0] - 2025-05-27

- Included validation utilities for card numbers and IBANs.

## [1.0.0] - 2025-05-19

- Initial official release
- Bank detection based on card number and IBAN
- Provides detailed bank info including name, title, logo, and color
- Added basic documentation and usage examples
- Configured linting and static analysis
