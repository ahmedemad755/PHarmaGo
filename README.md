# 💊 PharmaGo

A Smart Pharmacy Management & Healthcare Ecosystem built with **Flutter** and **Firebase**, following **Clean Architecture**, **Repository Pattern**, **SOLID Principles**, and **Cubit (flutter_bloc)**.

---

# 🚀 Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- SharedPreferences
- flutter_bloc (Cubit)
- GetIt (Dependency Injection)
- Dartz (Either)
- Clean Architecture
- Repository Pattern

---

# ✨ Features

## 🔐 Authentication

- Email & Password Authentication
- Google Sign-In
- Phone OTP Verification
- Password Reset
- Email Verification
- Delete Account with Re-authentication

---

## 🛍 Products

- Display Products
- Product Details
- Real-time Best Selling Products
- Search by Name
- Search by Product Code
- Category Filtering
- Discount Filtering
- Price Sorting
- Firestore Integration

---

## 🛒 Cart

- Add Products to Cart
- Update Product Quantity
- Remove Products
- Clear Cart
- Persistent Cart using SharedPreferences
- Prescription Support
- Local Cart Storage
- Clean Architecture
- UseCases + Cubit

---

## 💳 Checkout

- Cash Payment
- PayPal Payment
- Shipping Address
- Multi-step Checkout
- Prescription Validation
- Order Confirmation

---

## 📦 Orders

- Create Orders
- View Order History
- Order Details
- Cancel Orders
- Upload Prescription Orders
- Order Status Tracking
- Real-time Firestore Updates

---

## ⏰ Alarm

- Medicine Reminder
- Local Notifications
- Mark Reminder as Done
- Persistent Storage
- SharedPreferences

---

## 📄 Prescription

- Upload Prescription
- Pharmacy Selection
- AI-ready Clean Architecture
- Gemini integration prepared (currently disabled)

---

# 📱 Screenshots

### Authentication

<table>
<tr>
<td align="center">
<img src="assets/readme/login.png" width="200"/><br/>
Login
</td>

<td align="center">
<img src="assets/readme/signup.png" width="200"/><br/>
Signup
</td>

<td align="center">
<img src="assets/readme/otp.png" width="200"/><br/>
OTP Verification
</td>

<td align="center">
<img src="assets/readme/forgetpass.png" width="200"/><br/>
Forgot Password
</td>

</tr>

<tr>

<td align="center">
<img src="assets/readme/profile.png" width="200"/><br/>
Profile
</td>

<td align="center">
<img src="assets/readme/logout.png" width="200"/><br/>
Logout
</td>

<td></td>
<td></td>

</tr>

</table>

---

### Products

<table>

<tr>

<td align="center">
<img src="assets/readme/product_screan.png" width="220"/><br/>
Products
</td>

<td align="center">
<img src="assets/readme/filttering_products.png" width="220"/><br/>
Search & Filtering
</td>

<td align="center">
<img src="assets/readme/product_detailes_screan.png" width="220"/><br/>
Product Details
</td>

</tr>

</table>

---

### Cart

<table>

<tr>

<td align="center">
<img src="assets/readme/cart_view.png" width="220"/><br/>
Cart
</td>

<td align="center">
<img src="assets/readme/deleteitem_fromcart.png" width="220"/><br/>
Delete Item
</td>

</tr>

</table>

---

### Checkout

<table>

<tr>

<td align="center">
<img src="assets/readme/checkout_view.png" width="220"/><br/>
Checkout
</td>

<td align="center">
<img src="assets/readme/paypal.png" width="220"/><br/>
PayPal Payment
</td>

</tr>

</table>

---

### Orders

<table>

<tr>

<td align="center">
<img src="assets/readme/myorders.png" width="220"/><br/>
My Orders
</td>

<td align="center">
<img src="assets/readme/orderddetailes.png" width="220"/><br/>
Order Details
</td>

<td align="center">
<img src="assets/readme/cancelorder.png" width="220"/><br/>
Cancel Order
</td>

</tr>

</table>

---

### Alarm

<table>

<tr>

<td align="center">
<img src="assets/readme/alarmlist.png" width="220"/><br/>
Alarm List
</td>

<td align="center">
<img src="assets/readme/addalarm.png" width="220"/><br/>
Add Alarm
</td>

<td align="center">
<img src="assets/readme/addalarmbody.png" width="220"/><br/>
Add Alarm Details
</td>

</tr>

</table>

---

### Prescription

<table>

<tr>

<td align="center">
<img src="assets/readme/pharmalist.png" width="220"/><br/>
Pharmacy Selection
</td>

</tr>

</table>

---

### Home

<table>

<tr>

<td align="center">
<img src="assets/readme/home.png" width="220"/><br/>
Home
</td>

</tr>

</table>

---

# 🏛 Architecture

The project follows **Clean Architecture** to separate business logic from presentation and data access.

```
Presentation
│
├── Cubit
│
Domain
│
├── Entity
├── Repository
└── UseCases
│
Data
│
├── Repository Implementation
├── Remote DataSource
├── Local DataSource
└── Models
```

---

# 🔐 Authentication Feature

```text
lib/Features/auth/
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   └── remote/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entites/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubits/
    └── view/
```

## Responsibilities

### RemoteDataSource

- Firebase Authentication
- Google Sign-In
- Phone Authentication
- Password Reset
- Email Verification

### LocalDataSource

- Cache User
- Read Cached User
- Clear Cache

### Repository

- Coordinates Remote + Local + Firestore
- Converts Exceptions to Failures
- Converts Models to Entities

### UseCases

Each business action has its own UseCase.

Examples:

- LoginUseCase
- SignupUseCase
- LogoutUseCase
- GoogleLoginUseCase
- VerifyPhoneUseCase
- VerifyOtpUseCase
- ResetPasswordUseCase
- DeleteAccountUseCase
- GetCurrentUserUseCase
- CheckEmailExistsUseCase
- SendEmailVerificationUseCase

### Cubits

Cubits depend only on **UseCases**.

---

## Authentication Flow

```text
LoginView

↓

LoginCubit

↓

LoginUseCase

↓

AuthRepository

↓

AuthRemoteDataSource
      │
      ├── Firebase Authentication
      ├── Firestore
      └── Local Cache
```

---

# 🛍 Products Feature

```text
lib/Features/products/
├── data/
│   ├── datasource/
│   │   ├── remote/
│   │   └── local/
│   ├── model/
│   └── repositories/
├── domain/
│   ├── entityes/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── view/
    └── widgets/
```

## Responsibilities

### RemoteDataSource

- Reads Products from Firestore
- Streams Best Selling Products

### Repository

- Converts ProductModel → ProductEntity
- Handles Either & Failures

### UseCases

- GetProductsUseCase
- GetBestSellingProductsUseCase

### ProductsCubit

Responsible for:

- Loading Products
- Loading Best Selling Products
- Search
- Category Filtering
- Discount Filtering
- Price Sorting

---

## Products Flow

```text
ProductsView

↓

ProductsCubit

↓

GetProductsUseCase

↓

ProductsRepository

↓

ProductsRemoteDataSource

↓

DatabaseService

↓

Cloud Firestore
```

---

# 🛒 Cart Feature

```text
lib/Features/cart/
├── data/
│   ├── datasource/
│   │   └── local/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubits/
    ├── view/
    └── widgets/
```

## Responsibilities

### LocalDataSource

- Save Cart
- Read Cart
- Clear Cart
- SharedPreferences Storage

### Repository

- Handles Local Storage
- Converts Models ↔ Entities
- Provides Cart Operations

### UseCases

- AddProductToCartUseCase
- UpdateQuantityUseCase
- DeleteCartItemUseCase
- GetCartUseCase
- SaveCartUseCase
- ClearCartUseCase

### CartCubit

Responsible for:

- Add Product
- Remove Product
- Update Quantity
- Load Saved Cart
- Save Cart Automatically
- Clear Cart
- Handle Prescription Image

---

## Cart Flow

```text
CartView

↓

CartCubit

↓

UseCases

↓

CartRepository

↓

CartLocalDataSource

↓

SharedPreferences
```

---

# 💳 Checkout Feature

```text
lib/Features/checkout/
├── data/
│   └── models/
├── domain/
│   └── entities/
├── presentation/
│   ├── controllers/
│   ├── manger/
│   │   └── add_order_cubit/
│   └── views/
└── widgets/
```

## Responsibilities

### CheckoutController

- Handles Checkout Flow
- Step Navigation
- Cash Payment
- PayPal Payment
- Validation

### UseCases

- CreateOrderUseCase
- UploadPrescriptionUseCase

### CheckoutCubit (AddOrderCubit)

- Creates Orders
- Handles Payment States
- Validates Checkout

---

## Checkout Flow

```text
CheckoutView

↓

CheckoutController

↓

CreateOrderUseCase

↓

OrdersRepository

↓

OrdersRemoteDataSource

↓

Firestore
```

---

# 📦 Orders Feature

```text
lib/Features/orders/
├── data/
│   ├── datasource/
│   │   └── remote/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubits/
    └── view/
```

## Responsibilities

### RemoteDataSource

- Create Orders
- Fetch Orders
- Cancel Orders
- Upload Prescription

### Repository

- Converts Models ↔ Entities
- Handles Failures
- Firestore Integration

### UseCases

- CreateOrderUseCase
- FetchOrdersUseCase
- CancelOrderUseCase
- UploadPrescriptionUseCase

### OrdersCubit

Responsible for:

- Create Orders
- Load Orders
- Cancel Orders
- Upload Prescription Orders
- Track Order Status

---

## Orders Flow

```text
OrdersView

↓

OrdersCubit

↓

UseCases

↓

OrdersRepository

↓

OrdersRemoteDataSource

↓

Cloud Firestore
```

---

# ⏰ Alarm Feature

```text
lib/Features/alarm/
├── data/
│   ├── datasource/
│   │   └── local/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubits/
    ├── views/
    └── widgets/
```

## Responsibilities

### LocalDataSource

- Save Alarms
- Read Alarms
- Delete Alarms
- Schedule Notifications

### Repository

- Handles Local Storage
- Converts Models ↔ Entities

### UseCases

- GetAlarmsUseCase
- AddAlarmUseCase
- RemoveAlarmUseCase
- MarkAlarmAsDoneUseCase

### AlarmsCubit

Responsible for:

- Load Alarms
- Create Alarm
- Remove Alarm
- Mark Alarm as Completed

---

## Alarm Flow

```text
AlarmView

↓

AlarmsCubit

↓

UseCases

↓

AlarmsRepository

↓

AlarmsLocalDataSource

↓

SharedPreferences
```

---

# 📄 Prescription Feature

```text
lib/Features/prescription/
├── data/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubits/
    ├── view/
    └── widgets/
```

## Responsibilities

### Repository

- Analyze Prescription
- AI Integration (Prepared)

### UseCases

- AnalyzePrescriptionUseCase

### PrescriptionCubit

Responsible for:

- Upload Prescription
- Analyze Prescription
- Return Medicine List

> **Note:** The Gemini AI integration behind `PrescriptionRepository` is fully implemented but currently disabled. The Clean Architecture layers (Entity, Repository, UseCase, Cubit) are already in place so the AI analysis can be switched on without touching the rest of the app.

---

## Prescription Flow

```text
PrescriptionView

↓

PrescriptionCubit

↓

AnalyzePrescriptionUseCase

↓

PrescriptionRepository

↓

Gemini AI (Prepared)
```

---

# 🗄 Cart Persistence

The shopping cart is stored locally using **SharedPreferences**, allowing users to keep their cart contents even after restarting the application.

Current implementation:

- Cart is stored locally using SharedPreferences.
- Cart is restored automatically.
- Each authenticated user has its own local cart.
- Current implementation is offline only.

Future improvement:

- Firestore synchronization for multi-device support.

---

# 🧩 Dependency Injection

The project uses **GetIt**.

Registration order:

1. Core Services
2. DataSources
3. Repositories
4. UseCases
5. Cubits

---

# ⚠ BlocProvider vs BlocProvider.value

Singleton Cubits should always use:

```dart
BlocProvider.value(
  value: getIt<LoginCubit>(),
)
```

Factory Cubits should use:

```dart
BlocProvider(
  create: (_) => getIt<SugnupCubit>(),
)
```

This prevents the runtime error:

```
StateError:
Cannot emit new states after calling close
```

---

# 📈 Future Improvements

- Hive Offline Cache
- Firestore Cart Synchronization
- Push Notifications (FCM)
- Pagination
- Infinite Scrolling
- Server-side Search
- Server-side Filtering
- Order Tracking Timeline
- AI Prescription Analysis (Gemini)
- Unit Testing
- Widget Testing

---

# 📂 Project Structure

```
lib/
│
├── core/
│
├── Features/
│   ├── auth/
│   ├── products/
│   ├── cart/
│   ├── checkout/
│   ├── orders/
│   ├── alarm/
│   ├── prescription/
│   └── profile/
│
└── main.dart
```

---

# 👨‍💻 Author

**Ahmed Emad**

Flutter Developer

- GitHub: https://github.com/ahmedemad755
- LinkedIn: https://www.linkedin.com/in/ahmed-emad-flutter/
