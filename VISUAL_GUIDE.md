# 🎨 Visual Guide - Prescription Upload UI

## Complete UI Mockup

```
┌────────────────────────────────────────────┐
│                                            │
│  < Upload Prescription          🔔          │ ← AppBar (buildAppBar)
│                                            │
└────────────────────────────────────────────┘
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │   Prescription Guide                 │  │ ← PrescriptionGuideCard
│  │                                      │  │    backgroundColor: #1BA598
│  │   ✓ Upload Clear Image              │  │
│  │   ✓ Doctor Details Required         │  │
│  │   ✓ Date Of Prescription            │  │
│  │   ✓ Patient Details                 │  │
│  │   ✓ Dosage Details                  │  │
│  │                                      │  │
│  │   How It Works                       │  │
│  │   ┌────┐  ┌────┐  ┌────┐            │  │
│  │   │📁  │  │🔔  │  │🚚  │            │  │ ← HowItWorkItemWidget (x3)
│  │   │Up  │  │Rec │  │Med │            │  │
│  │   │load│  │eived│ │    │            │  │
│  │   └────┘  └────┘  └────┘            │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌──────────────────────────────────────┐  │
│  │                                      │  │
│  │        📁 Upload file here           │  │ ← UploadAreaWidget
│  │                                      │  │    borderColor: #1BA598
│  │                                      │  │    backgroundColor: #F0FFFE
│  │  (shows image preview if selected)  │  │
│  │                                      │  │
│  └──────────────────────────────────────┘  │
│                                            │
│  ┌─────────────────┐  ┌─────────────────┐  │
│  │ 📷 Camera       │  │ 🖼️ Gallery      │  │ ← UploadButtonWidget (x2)
│  │                 │  │                 │  │    backgroundColor: #87CEEB
│  └─────────────────┘  └─────────────────┘  │                   #9DB4BE
│                                            │
│  ┌──────┐  ┌──────┐  ┌──────┐             │
│  │ ⌂    │  │ 🔧   │  │ 📄   │  ┌──────┐  │
│  │      │  │      │  │      │  │ ↻    │  │
│  └──────┘  └──────┘  └──────┘  │      │  │ ← BottomNavigationIconsWidget
│                                 └──────┘  │    (5 icons in circles)
│                                 ┌──────┐  │
│                                 │ 👤   │  │
│                                 │      │  │
│                                 └──────┘  │
│                                            │
└────────────────────────────────────────────┘
```

---

## Color Reference Card

```
┌─────────────────────────────────────────────────┐
│ Color Palette                                   │
├─────────────────────────────────────────────────┤
│                                                 │
│  ■ Primary/Text/Icons        ■ Teal            │
│    #1BA598                    RGB(27, 165, 152)│
│                                                 │
│  ■ Light Background           ■ Cyan           │
│    #F0FFFE                    RGB(240, 255, 254)
│                                                 │
│  ■ Camera Button              ■ Sky Blue       │
│    #87CEEB                    RGB(135, 206, 235)
│                                                 │
│  ■ Gallery Button             ■ Gray-Blue      │
│    #9DB4BE                    RGB(157, 180, 190)
│                                                 │
│  ■ Text/Guides                ■ Teal           │
│    #1BA598                    RGB(27, 165, 152)
│                                                 │
│  ■ White/Light                ■ White          │
│    #FFFFFF                    RGB(255, 255, 255)
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Component Size Reference

```
┌────────────────────────────────────────────┐
│ Dimensions (in logical pixels)             │
├────────────────────────────────────────────┤
│                                            │
│ Prescription Guide Card                    │
│   Border Radius:        24px               │
│   Padding:              24px (all sides)   │
│                                            │
│ Title Font Size:        22px               │
│ Subtitle Font Size:     18px               │
│ Guidelines Font Size:   14px               │
│ Small Font Size:        12px               │
│                                            │
│ Upload Area                                │
│   Height:               200px              │
│   Border Radius:        16px               │
│   Border Width:         2px                │
│                                            │
│ Upload Buttons                             │
│   Border Radius:        12px               │
│   Vertical Padding:     14px               │
│   Spacing Between:      16px               │
│                                            │
│ Icons                                      │
│   Upload Zone Icon:     50px               │
│   How It Works Icon:    40px               │
│   Button Icon:          24px               │
│   Bottom Nav Icon:      24px               │
│   Guideline Icon:       20px               │
│                                            │
│ Spacing Between Sections: 32px             │
│ Horizontal Page Padding:  16px             │
│                                            │
└────────────────────────────────────────────┘
```

---

## Typography Reference

```
┌──────────────────────────────────────────────┐
│ Text Styles                                  │
├──────────────────────────────────────────────┤
│                                              │
│ Title (Prescription Guide)                   │
│   Size: 22px                                 │
│   Weight: Bold                               │
│   Color: White (#FFFFFF)                     │
│                                              │
│ Subtitle (How It Works)                      │
│   Size: 18px                                 │
│   Weight: Bold                               │
│   Color: White (#FFFFFF)                     │
│                                              │
│ Guidelines                                   │
│   Size: 14px                                 │
│   Weight: Medium (500)                       │
│   Color: White (#FFFFFF)                     │
│                                              │
│ Button Labels                                │
│   Size: 14px                                 │
│   Weight: SemiBold (600)                     │
│   Color: White (#FFFFFF)                     │
│                                              │
│ How It Works Labels                          │
│   Size: 12px                                 │
│   Weight: Medium (500)                       │
│   Color: White (#FFFFFF)                     │
│                                              │
│ Upload Text                                  │
│   Size: 16px                                 │
│   Weight: SemiBold (600)                     │
│   Color: #1BA598                             │
│                                              │
└──────────────────────────────────────────────┘
```

---

## Layout Breakdown

### Section 1: App Bar
```
┌────────────────────────────────────────┐
│ < Upload Prescription      🔔          │
└────────────────────────────────────────┘
  ← (provided by buildAppBar)
```

### Section 2: Prescription Guide
```
┌─────────────────────────────────────────────┐
│ Prescription Guide                          │
│                                             │
│ ✓ Upload Clear Image                        │
│ ✓ Doctor Details Required                   │
│ ✓ Date Of Prescription                      │
│ ✓ Patient Details                           │
│ ✓ Dosage Details                            │
│                                             │
│ How It Works                                │
│                                             │
│ [📁]      [🔔]      [🚚]                  │
│ Upload    Received   Medicine at            │
│ Prescrip. Notif.    doorstep               │
└─────────────────────────────────────────────┘
  32px gap
```

### Section 3: Upload Area
```
┌─────────────────────────────────────────┐
│                                         │
│     📁 Upload file here                 │
│                                         │
│  (displays selected image here)         │
│                                         │
└─────────────────────────────────────────┘
  20px gap
  ┌──────────────┐   ┌──────────────┐
  │📷 Camera     │   │🖼️ Gallery    │
  └──────────────┘   └──────────────┘
  32px gap
```

### Section 4: Bottom Navigation
```
┌──────────────────────────────────────────┐
│  [⌂]  [🔧]  [📄]  [↻]  [👤]            │
│      Icons in circles, evenly spaced     │
└──────────────────────────────────────────┘
```

---

## Responsive Behavior

```
┌─────────────────────────────────────┐
│ Screen Size Considerations          │
├─────────────────────────────────────┤
│                                     │
│ Small Screen (<400px)               │
│   • Reduced padding                 │
│   • Smaller font sizes              │
│   • Adjust spacing                  │
│                                     │
│ Medium Screen (400-600px)           │
│   • Standard padding (16px)         │
│   • Standard font sizes             │
│   • Standard spacing (32px)         │
│                                     │
│ Large Screen (>600px)               │
│   • Larger padding (20px)           │
│   • Larger font sizes               │
│   • More spacing (40px)             │
│                                     │
│ Current Implementation: Responsive  │
│   Uses SingleChildScrollView        │
│   Works on all sizes                │
│                                     │
└─────────────────────────────────────┘
```

---

## Icon Guide

```
┌──────────────────────────────────────────┐
│ Icons Used in UI                         │
├──────────────────────────────────────────┤
│                                          │
│ Prescription Guide Section:              │
│   ✓ Icons.check_circle                   │
│                                          │
│ How It Works Section:                    │
│   • Icons.upload_file (Upload)           │
│   • Icons.notifications_active (Notify)  │
│   • Icons.local_shipping (Delivery)      │
│                                          │
│ Upload Area:                             │
│   • Icons.image_outlined                 │
│                                          │
│ Buttons:                                 │
│   • Icons.camera_alt (Camera)            │
│   • Icons.image (Gallery)                │
│                                          │
│ Bottom Navigation:                       │
│   • Icons.home                           │
│   • Icons.build                          │
│   • Icons.description                    │
│   • Icons.refresh                        │
│   • Icons.person                         │
│                                          │
│ All from Flutter Material Icons Library  │
│ (Icons class from package:flutter/material)
│                                          │
└──────────────────────────────────────────┘
```

---

## Widget Hierarchy

```
Uploadprescription (StatefulWidget)
│
├── Scaffold
│   ├── AppBar (buildAppBar)
│   │
│   └── Body: SingleChildScrollView
│       └── Column
│           ├── PrescriptionGuideCard
│           │   ├── Title "Prescription Guide"
│           │   ├── Guidelines (5 items)
│           │   │   └── Row with checkmark icon
│           │   ├── Title "How It Works"
│           │   └── How It Works Items (3)
│           │       └── HowItWorkItemWidget (x3)
│           │
│           ├── UploadAreaWidget
│           │   ├── Image Preview or Upload Icon
│           │   ├── UploadButtonWidget (Camera)
│           │   └── UploadButtonWidget (Gallery)
│           │
│           └── BottomNavigationIconsWidget
│               └── Icon Buttons (5)
```

---

## State Management Flow

```
┌─────────────────────────────────────┐
│ Image Selection Flow                │
├─────────────────────────────────────┤
│                                     │
│ 1. User taps Camera/Gallery button  │
│       ↓                             │
│ 2. _pickImage(ImageSource) called   │
│       ↓                             │
│ 3. ImagePicker opens                │
│       ↓                             │
│ 4. User selects image               │
│       ↓                             │
│ 5. setState(_selectedImage = file)  │
│       ↓                             │
│ 6. UI rebuilds with preview         │
│       ↓                             │
│ 7. Show image in UploadAreaWidget   │
│                                     │
└─────────────────────────────────────┘
```

---

## File Organization

```
lib/
│
└── featchers/
    │
    └── home/
        │
        └── presentation/
            │
            └── views/
                │
                └── widgets/
                    │
                    ├── uploadPrescription.dart ✅ Main file
                    ├── prescription_config.dart ✅ Config
                    ├── CUSTOMIZATION_SNIPPETS.dart 📝 Examples
                    └── EXAMPLE_IMPLEMENTATIONS.dart 📝 Reference
```

---

## Customization Quick Reference

```
┌───────────────────────────────────────────────┐
│ Where to Change What                          │
├───────────────────────────────────────────────┤
│                                               │
│ Colors                                        │
│   → prescription_config.dart (Lines 6-15)    │
│                                               │
│ Text/Guidelines                               │
│   → prescription_config.dart (Lines 17-35)   │
│                                               │
│ Font Sizes                                    │
│   → prescription_config.dart (Lines 37-42)   │
│                                               │
│ Spacing/Padding                               │
│   → prescription_config.dart (Lines 44-52)   │
│                                               │
│ How It Works Items                            │
│   → prescription_config.dart (Lines 88-103)  │
│                                               │
│ Bottom Nav Icons                              │
│   → prescription_config.dart (Lines 105-114) │
│                                               │
│ Image Capture Quality                         │
│   → uploadPrescription.dart (Line 20)        │
│                                               │
│ Upload Logic                                  │
│   → uploadPrescription.dart (_pickImage method)
│                                               │
└───────────────────────────────────────────────┘
```

---

## Before & After Colors

### Current (Teal/Green Theme)
```
Primary:  #1BA598  ■■■■■
Secondary: #87CEEB ■■■■■
Accent:   #9DB4BE  ■■■■■
```

### Alternative (Blue Theme)
```
Primary:  #2196F3  ■■■■■
Secondary: #42A5F5 ■■■■■
Accent:   #1E88E5  ■■■■■
```

### Alternative (Green Theme)
```
Primary:  #00796B  ■■■■■
Secondary: #26A69A ■■■■■
Accent:   #00897B  ■■■■■
```

---

This visual guide helps you understand the layout and structure of your prescription upload interface at a glance!
