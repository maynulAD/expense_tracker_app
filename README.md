# Personal Expense Tracker App 💰

A simple and user-friendly Personal Expense Tracker application developed using Flutter and SQLite. The application helps users manage their daily income and expenses, track their spending, and monitor their current balance.

## Features

### 1. Dashboard
- Display the application name: Expense Tracker.
- Show total income.
- Show total expenses.
- Calculate and display the current balance dynamically.
- Display recent transactions.
- Floating Action Button (FAB) to add new transactions.

### 2. Add Transaction
- Add a transaction title.
- Enter the transaction amount.
- Select a category from the dropdown menu.
- Choose transaction type (Income or Expense).
- Select a transaction date using Date Picker.
- Save transaction information in the local database.

### 3. Transaction Management
- View all recorded transactions.
- Display transaction title, amount, category, date, and type.
- Edit existing transactions.
- Delete transactions with confirmation through an AlertDialog.
- Automatically update dashboard summaries after adding, editing, or deleting transactions.

### 4. Input Validation
- Transaction title cannot be empty.
- Amount must be a valid positive number.
- Category selection is required.
- Transaction type selection is required.

### 5. Local Database
- Uses SQLite through the `sqflite` package.
- Stores transaction information locally on the device.
- Keeps transaction data available after closing and reopening the application.

## Technologies Used

- **Framework:** Flutter
- **Programming Language:** Dart
- **Database:** SQLite
- **Database Package:** sqflite
- **Path Management:** path
- **Date Formatting:** intl
- **UI:** Material Design 3

## Database Structure

**Database Name:** `expense_tracker.db`

**Table Name:** `transactions`

| Column | Data Type |
|---|---|
| id | INTEGER PRIMARY KEY AUTOINCREMENT |
| title | TEXT |
| amount | REAL |
| category | TEXT |
| type | TEXT |
| date | TEXT |

## Project Structure

```text
lib/
├── main.dart
├── app.dart
│
├── models/
│   └── transaction_model.dart
│
├── database/
│   └── database_helper.dart
│
├── screens/
│   ├── dashboard_screen.dart
│   ├── add_edit_transaction_screen.dart
│   └── transaction_details_screen.dart
│
├── widgets/
│   ├── summary_card.dart
│   └── transaction_tile.dart
│
└── utils/
    └── app_formatters.dart
```

## Installation and Setup

1. Download and extract the project.
2. Open the project folder in Visual Studio Code or Android Studio.
3. Open the terminal in the project directory.
4. Run the following command to install dependencies:

```bash
flutter pub get
```

5. Connect an Android device or start an emulator.
6. Run the application:

```bash
flutter run
```

## Testing

To run the included project tests, execute:

```bash
flutter test
```

## Restrictions

- No Firebase integration.
- No Supabase integration.
- No external API or backend connection.
- All transaction data is stored locally using SQLite.

## Developer

**Md Gazi Maynul Hassan Moin**

Developed as a Flutter assignment to demonstrate UI development, local database integration, CRUD operations, form validation, state management, and dynamic calculations.

---

