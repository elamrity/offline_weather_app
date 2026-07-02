# 🌦️ Offline-Aware Weather Application

A production-ready, highly performant, and reliable weather dashboard application built with Flutter. This project is engineered with an **Offline-First approach**, adhering strictly to the principles of **Clean Architecture** and robust state management.

---

## 🚀 Key Features

*   **Offline persistence:** Powered by Hive DB for blazing-fast local caching.
*   **Intelligent Caching & Sync Strategy:** Always displays cached data instantly if offline or if the remote server fails.
*   **Dynamic Location Selection:** Fully interactive city search that updates the state and persists user preferences.
*   **Granular Forecasts:** Displays beautiful, scannable hourly and 5-day daily forecasts.
*   **Reliable State Handling:** Built-in connection awareness with explicit user feedback on data staleness ("Last Updated").

---

## 🏗️ Architecture Blueprint

The project is structured following **Clean Architecture** to ensure independent layers, high testability, and a clear separation of concerns:

```text
lib/
│
├── core/                  # Shared utilities, DI, network info, and failures
│   ├── di/                # Service Locator (GetIt)
│   ├── error/             # Failures and exceptions definition
│   └── network/           # Connectivity mapping
│
└── features/weather/      # Feature-driven modules
    ├── data/              # Models, Local & Remote data sources, Repo implementation
    ├── domain/            # Entities, Business logic boundaries (UseCases), Repo interfaces
    └── presentation/      # BLoC state management, Pages, Custom UI Widgets
