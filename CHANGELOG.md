# Changelog

All notable changes to the Balaji Gold mobile application will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-02-12

### Added
- Initial release of Balaji Gold application
- Phone number authentication with OTP verification
- Customer management (add, view, list)
- Transaction management with auto-calculation
  - "You Got" (incoming money - green)
  - "You Gave" (outgoing money - red)
  - Auto calculation: weight × rate per gram
- Dashboard with colorful gradient cards
  - Total profit display
  - Total loss display
  - Total customers count
  - Net balance calculation
- Customer detail page
  - Net balance display with profit/loss indicator
  - Transaction history with date sorting
  - Add transaction form with real-time calculation
- AI Chatbot integration
  - OpenAI powered assistant
  - Gold/Silver rate queries
  - Customer balance queries
  - Floating action button with animation
- Gold & Silver rate API integration
  - Real-time rate fetching
  - Firestore rate storage
  - Fallback to stored rates
- Reports and Downloads
  - PDF generation for customer statements
  - CSV export for customer statements
  - All customers report export
  - Comprehensive reports page
- UI/UX Features
  - Beautiful gradient color schemes
  - Light and dark mode support
  - Smooth animations and transitions
  - Responsive layout
  - Material Design 3
  - Custom fonts (Google Fonts - Poppins)
- Firebase Integration
  - Firebase Authentication
  - Cloud Firestore database
  - Real-time data sync
- Architecture
  - Clean MVC/MVVM structure
  - Provider state management
  - Service layer separation
  - Reusable widgets
- Documentation
  - Comprehensive README
  - Firebase setup guide
  - API configuration guide
  - Deployment guide
  - Contributing guidelines
- Platform Support
  - Android (API 21+)
  - iOS (iOS 12+)

### Technical Details
- Flutter SDK 3.0.0+
- Material Design 3
- Firebase Core 2.24.2
- Provider 6.1.1
- OpenAI Chat GPT SDK 2.2.5
- PDF generation support
- CSV export support

## [Unreleased]

### Planned Features
- [ ] Offline mode with local database
- [ ] Push notifications for transaction updates
- [ ] Multi-language support
- [ ] Backup and restore functionality
- [ ] Transaction categories
- [ ] Advanced filtering and search
- [ ] Charts and analytics
- [ ] Payment reminders
- [ ] WhatsApp integration for statements
- [ ] Fingerprint/Face ID authentication
- [ ] Multiple business support
- [ ] Staff user management
- [ ] Custom receipt templates
- [ ] Automated SMS notifications

### Future Improvements
- [ ] Performance optimizations
- [ ] Improved error handling
- [ ] Better offline support
- [ ] Enhanced chatbot capabilities
- [ ] More export formats
- [ ] Cloud backup
- [ ] Integration with accounting software

---

## Version History

### Version Naming Convention
- MAJOR version for incompatible API changes
- MINOR version for new functionality in a backwards compatible manner
- PATCH version for backwards compatible bug fixes

### Release Notes Format
- **Added** for new features
- **Changed** for changes in existing functionality
- **Deprecated** for soon-to-be removed features
- **Removed** for now removed features
- **Fixed** for any bug fixes
- **Security** for vulnerability fixes
