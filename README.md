🖼️ Image Web Link Plasmoid for KDE Plasma 6.4+

Version: 1.4.0
Author: Example Developer
License: GPL-3.0-or-later
Category: Graphics
ID: org.example.imageweblink

🌟 Overview

Image Web Link is a KDE Plasma 6.4+ widget (plasmoid) that displays an image or GIF on your desktop or panel, optionally linked to a web address.
When clicked, the widget opens the specified URL in your default browser.
You can also set a hover image — an alternate image that appears when your mouse hovers over the widget.

✨ Features

✅ Supports GIF, JPG, PNG, WebP, and SVG formats
✅ Optional hover image (different image when hovering)
✅ Optional clickable web link
✅ Transparent or default background
✅ Drag & drop image support
✅ Custom or auto size options
✅ Works in both panel and desktop modes
✅ Uses modern Plasma 6.4 / Kirigami 6 APIs

⚙️ Configuration Options
Setting	Description
Image file	Main image displayed by the widget
Hover image	Optional image shown when cursor hovers over the widget
Web link	URL opened when the image is clicked
Link name	Tooltip name shown in panel mode
Transparent background	Removes default Plasma background
Auto-resize	Automatically fits the image to widget area
Use custom size	Enables manual width/height settings
Custom width / height	Fixed pixel size for the image widget

🧠 How It Works

The plasmoid dynamically loads your image and, if enabled:

Displays an alternate hover image when hovered

Opens the linked URL on left-click

Supports drag and drop to quickly replace the image

Adjusts size automatically or according to your custom dimensions

When added to a panel, it switches to a compact representation with tooltip info.
On the desktop, it expands to full representation with support for image drop and resizing.

🛠️ Installation
🔹 Automatic Build & Install (Recommended)

Run the included builder script:

chmod +x build-imageweblink.sh
./build-imageweblink.sh

This will:

Create a plasmoid package (org.example.imageweblink.plasmoid)

Remove any existing installation

Install it with kpackagetool6

Restart Plasma automatically

After installation:

🧩 Add the widget via:
Right-click Desktop → Add Widgets... → Image Web Link

🧰 Requirements

KDE Plasma 6.4 or newer

kpackagetool6 available in your PATH

QtQuick / Kirigami 6 components
