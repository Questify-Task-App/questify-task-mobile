# Questify Task Mobile

A gamified task management app where you earn coins by completing tasks and can exchange them for rewards.

## 🎯 About the Project

Questify Task is an application that transforms your daily tasks into a gamified experience. Combine productivity with fun:

- 📝 Create and manage daily tasks
- 🎮 Earn coins by completing tasks
- 🎁 Exchange coins for rewards
- 📊 Track your progress

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
│   └── task.dart            # Task model
├── pages/                    # Application pages
│   ├── daily_page.dart      # Daily tasks page
│   ├── tasks_page.dart      # General tasks page
│   └── rewards_page.dart    # Rewards page
├── screens/                  # Main screens
│   └── home_screen.dart     # Main screen with navigation
├── services/                 # Services and business logic
│   ├── coin_persistence_service.dart    # Coin management
│   ├── task_persistence.service.dart    # Task persistence
│   ├── list_manager_service.dart        # List management
│   └── update_service.dart              # Update service
└── widgets/                  # Reusable components
    ├── coin_banner.dart     # Coin banner
    └── list_manager.dart    # Task list manager
```

## 🚀 Features

### Task Management
- Create, edit and delete tasks
- Categorization in daily and general tasks
- Coin reward system
- Local data persistence

### Coin System
- Earn coins by completing tasks
- Persistent balance between sessions
- Customizable reward system

### Automatic Updates
- Automatic version checking
- Mandatory updates in production
- GitHub Releases integration

## 🔧 Technologies Used

- **Flutter**: Main framework
- **Shared Preferences**: Local persistence
- **Upgrader**: Automatic update system
- **GitHub Actions**: CI/CD and automatic releases

## 📦 Versioning

The project uses automated semantic versioning based on commits:

- `break:` - Increments major version (x.0.0)
- `feat:` - Increments minor version (0.x.0)
- `fix:` - Increments patch version (0.0.x)

## 🚀 Getting Started

1. Clone the repository
```bash
git clone https://github.com/Questify-Task-App/questify-task-mobile.git
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the project
```bash
flutter run
```

### Production Environment

To generate a production APK:
```bash
flutter build apk --release
```

## 📱 Distribution

The app uses GitHub Releases for distribution and automatic updates:

1. Push to main triggers GitHub Actions
2. Version is automatically incremented
3. APK is built and published as a release
4. Users receive update notification

## 🤝 Contributing

1. Create a feature branch: `git checkout -b feature/name`
2. Commit your changes: `git commit -m 'feat: My new feature'`
3. Push to the branch: `git push origin feature/name`
4. Open a Pull Request

## 📝 License

This project is under the MIT license. See the [LICENSE](LICENSE) file for details.
