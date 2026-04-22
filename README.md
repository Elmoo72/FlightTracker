# FlightTracker

iOS-приложение для отслеживания авиарейсов с поддержкой виджета на домашнем экране.

## Описание

FlightTracker позволяет добавлять рейсы и следить за их статусом в реальном времени. Приложение показывает подробную информацию о вылете и прилёте, текущий статус рейса, посадочный талон, а также обновляет данные через API авиационных данных.

## Скриншоты

> _Добавьте скриншоты приложения сюда_

## Функциональность

- Список добавленных рейсов с цветовой индикацией статуса
- Добавление рейсов вручную по номеру
- Детальная карточка рейса: аэропорт вылета/прилёта, время, терминал, статус
- Генерация посадочного талона
- Обновление статуса рейсов через airlabs.co API
- Виджет для домашнего экрана (WidgetKit)
- Локальное сохранение рейсов (UserDefaults, JSON)
- Обработка ошибок с отображением алертов

## Статусы рейсов

| Статус | Описание |
|--------|----------|
| Scheduled | Запланирован |
| Boarding | Посадка |
| Departed | Вылетел |
| In Air | В воздухе |
| Landed | Приземлился |
| Arrived | Прибыл |
| Delayed | Задержан |
| Cancelled | Отменён |
| Diverted | Перенаправлен |

## Технологии

- **Язык:** Swift
- **UI:** SwiftUI
- **Архитектура:** MVVM
- **Реактивность:** Combine (@Published, @StateObject)
- **Виджеты:** WidgetKit
- **Сеть:** URLSession + async/await (airlabs.co API)
- **Хранение:** UserDefaults (JSON Codable)
- **Минимальная версия iOS:** 17.0

## Структура проекта

```
FlyghtTracker/
├── App/
│   └── FlightTrackerApp.swift
├── Views/
│   ├── FlightListView.swift
│   ├── FlightDetailView.swift
│   ├── FlightCardView.swift
│   ├── BoardingPassView.swift
│   └── AddFlightView.swift
├── ViewModels/
│   └── FlightViewModel.swift
├── Models/
│   ├── Flight.swift
│   ├── Airport.swift
│   ├── FlightStatus.swift
│   └── SharedModels.swift
├── Services/
│   ├── FlightAPIService.swift
│   └── AirportDatabase.swift
├── Design/
│   └── DesignSystem.swift
└── Widget/
    ├── FlightWidget.swift
    └── FlightWidgetBundle.swift
```

## Запуск

1. Клонируйте репозиторий
2. Откройте `FlyghtTracker.xcodeproj` в Xcode
3. При необходимости добавьте API-ключ от [airlabs.co](https://airlabs.co) в `FlightAPIService.swift`
4. Выберите симулятор или устройство с iOS 17.0+
5. Нажмите **Run** (⌘R)

## Требования

- Xcode 15+
- iOS 17.0+
