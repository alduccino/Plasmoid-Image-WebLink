#!/usr/bin/env bash
# KDE Plasma 6.4+ Image Viewer with Web Link Plasmoid Builder
# Version: 1.3.0 - Added link name field for panel tooltips

set -e

PLASMOID_ID="org.example.imageweblink"
BUILD_DIR="/tmp/plasmoid-build-$$"
PKG_DIR="$BUILD_DIR/$PLASMOID_ID"

echo "🔧 Creating plasmoid structure in temporary directory..."
mkdir -p "$PKG_DIR/contents/ui" "$PKG_DIR/contents/config"

########################################
# metadata.json (Plasma 6.4+ compatible)
########################################
cat > "$PKG_DIR/metadata.json" <<'EOF'
{
    "KPlugin": {
        "Authors": [
            {
                "Email": "none@example.org",
                "Name": "Example Developer"
            }
        ],
        "Category": "Graphics",
        "Description": "Displays an image (GIF, JPG, PNG, WebP, SVG) with clickable web link",
        "Icon": "image-x-generic",
        "Id": "org.example.imageweblink",
        "License": "GPL-3.0-or-later",
        "Name": "Image Web Link",
        "Version": "1.3",
        "Website": "https://example.org"
    },
    "KPackage": {
        "Type": "Plasma/Applet"
    },
    "X-Plasma-API-Minimum-Version": "6.0"
}
EOF

########################################
# contents/config/main.xml
########################################
cat > "$PKG_DIR/contents/config/main.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<kcfg xmlns="http://www.kde.org/standards/kcfg/1.0"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.kde.org/standards/kcfg/1.0
      http://www.kde.org/standards/kcfg/1.0/kcfg.xsd">
  <kcfgfile name=""/>
  <group name="General">
    <entry name="imagePath" type="String">
      <default></default>
    </entry>
    <entry name="webLink" type="String">
      <default></default>
    </entry>
    <entry name="linkName" type="String">
      <default></default>
    </entry>
    <entry name="transparentBackground" type="Bool">
      <default>true</default>
    </entry>
    <entry name="autoResize" type="Bool">
      <default>true</default>
    </entry>
    <entry name="customWidth" type="Int">
      <default>200</default>
    </entry>
    <entry name="customHeight" type="Int">
      <default>200</default>
    </entry>
    <entry name="useCustomSize" type="Bool">
      <default>false</default>
    </entry>
  </group>
</kcfg>
EOF

########################################
# contents/config/config.qml
########################################
cat > "$PKG_DIR/contents/config/config.qml" <<'EOF'
import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "preferences-desktop-theme"
        source: "configGeneral.qml"
    }
}
EOF

########################################
# contents/ui/configGeneral.qml
########################################
cat > "$PKG_DIR/contents/ui/configGeneral.qml" <<'EOF'
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
    property alias cfg_imagePath: imagePath.text
    property alias cfg_webLink: webLink.text
    property alias cfg_linkName: linkName.text
    property alias cfg_transparentBackground: transparentCheckBox.checked
    property alias cfg_autoResize: autoResizeCheckBox.checked
    property alias cfg_useCustomSize: useCustomSizeCheckBox.checked
    property alias cfg_customWidth: customWidthSpinBox.value
    property alias cfg_customHeight: customHeightSpinBox.value

    Kirigami.FormLayout {
        RowLayout {
            Kirigami.FormData.label: i18n("Image file:")

            TextField {
                id: imagePath
                Layout.fillWidth: true
                placeholderText: i18n("Select an image file...")
                readOnly: false
            }

            Button {
                icon.name: "document-open"
                text: i18n("Browse...")
                onClicked: fileDialog.open()
            }
        }

        TextField {
            id: webLink
            Kirigami.FormData.label: i18n("Web link:")
            Layout.fillWidth: true
            placeholderText: i18n("https://example.com")

            ToolTip.visible: hovered
            ToolTip.text: i18n("URL to open when clicking the image")
        }

        TextField {
            id: linkName
            Kirigami.FormData.label: i18n("Link name:")
            Layout.fillWidth: true
            placeholderText: i18n("Display name for the link")

            ToolTip.visible: hovered
            ToolTip.text: i18n("Name shown in tooltip when hovering over the widget in a panel")
        }

        CheckBox {
            id: transparentCheckBox
            text: i18n("Transparent background")
            Kirigami.FormData.label: i18n("Appearance:")
        }

        CheckBox {
            id: autoResizeCheckBox
            text: i18n("Auto-resize to fit widget")
        }

        Item {
            Kirigami.FormData.isSection: true
            Kirigami.FormData.label: i18n("Custom Size")
        }

        CheckBox {
            id: useCustomSizeCheckBox
            text: i18n("Use custom size")
            Kirigami.FormData.label: i18n("Size options:")
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Width:")
            enabled: useCustomSizeCheckBox.checked

            SpinBox {
                id: customWidthSpinBox
                from: 10
                to: 10000
                stepSize: 10
                editable: true

                textFromValue: function(value) {
                    return value + " px"
                }

                valueFromText: function(text) {
                    return parseInt(text)
                }
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Height:")
            enabled: useCustomSizeCheckBox.checked

            SpinBox {
                id: customHeightSpinBox
                from: 10
                to: 10000
                stepSize: 10
                editable: true

                textFromValue: function(value) {
                    return value + " px"
                }

                valueFromText: function(text) {
                    return parseInt(text)
                }
            }
        }

        Label {
            text: i18n("Tip: You can drag and drop an image file directly onto the widget")
            opacity: 0.7
            font.italic: true
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        Label {
            text: i18n("Supported formats: GIF, JPG, PNG, WebP, SVG")
            opacity: 0.6
            font.pointSize: Kirigami.Theme.smallFont.pointSize
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }
    }

    FileDialog {
        id: fileDialog
        title: i18n("Select Image File")
        currentFolder: "file://" + (imagePath.text ? imagePath.text.substring(0, imagePath.text.lastIndexOf('/')) : "")
        nameFilters: [
            i18n("Image Files (*.gif *.jpg *.jpeg *.png *.webp *.svg)"),
            i18n("GIF Images (*.gif)"),
            i18n("JPEG Images (*.jpg *.jpeg)"),
            i18n("PNG Images (*.png)"),
            i18n("WebP Images (*.webp)"),
            i18n("SVG Images (*.svg)"),
            i18n("All Files (*)")
        ]
        fileMode: FileDialog.OpenFile

        onAccepted: {
            let path = selectedFile.toString()
            // Remove file:// prefix
            if (path.startsWith("file://")) {
                path = path.substring(7)
            }
            imagePath.text = path
        }
    }
}
EOF

########################################
# contents/ui/main.qml
########################################
cat > "$PKG_DIR/contents/ui/main.qml" <<'EOF'
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami
import Qt5Compat.GraphicalEffects

PlasmoidItem {
    id: root

    property string imagePath: plasmoid.configuration.imagePath
    property string webLink: plasmoid.configuration.webLink
    property string linkName: plasmoid.configuration.linkName
    property bool transparentBackground: plasmoid.configuration.transparentBackground
    property bool autoResize: plasmoid.configuration.autoResize
    property bool isAnimated: imagePath.toLowerCase().endsWith(".gif")
    property bool useCustomSize: plasmoid.configuration.useCustomSize
    property int customWidth: plasmoid.configuration.customWidth
    property int customHeight: plasmoid.configuration.customHeight

    // Check if plasmoid is in a panel
    readonly property bool inPanel: (plasmoid.location === PlasmaCore.Types.TopEdge ||
                                     plasmoid.location === PlasmaCore.Types.RightEdge ||
                                     plasmoid.location === PlasmaCore.Types.BottomEdge ||
                                     plasmoid.location === PlasmaCore.Types.LeftEdge)

    // Set minimum size to 2x2 grid units
    Layout.minimumWidth: Kirigami.Units.gridUnit * 2
    Layout.minimumHeight: Kirigami.Units.gridUnit * 2

    // Tooltip for panels
    toolTipMainText: inPanel && linkName ? linkName : ""
    toolTipSubText: inPanel && linkName && webLink ? webLink : ""

    // Custom resize function with minimum size enforcement
    function applyCustomSize() {
        if (useCustomSize) {
            var width = Math.max(Kirigami.Units.gridUnit * 2, customWidth)
            var height = Math.max(Kirigami.Units.gridUnit * 2, customHeight)

            Layout.preferredWidth = width
            Layout.preferredHeight = height
            Layout.maximumWidth = width
            Layout.maximumHeight = height
        } else {
            // Reset to default behavior with 2x2 minimum
            Layout.preferredWidth = Kirigami.Units.gridUnit * 10
            Layout.preferredHeight = Kirigami.Units.gridUnit * 10
            Layout.maximumWidth = -1
            Layout.maximumHeight = -1
        }
    }

    // Apply custom size on configuration changes
    onUseCustomSizeChanged: applyCustomSize()
    onCustomWidthChanged: applyCustomSize()
    onCustomHeightChanged: applyCustomSize()

    Component.onCompleted: applyCustomSize()

    Plasmoid.backgroundHints: transparentBackground ?
        "NoBackground" :
        "DefaultBackground"

    function openWebLink() {
        if (webLink && webLink.trim() !== "") {
            Qt.openUrlExternally(webLink)
        }
    }

    // When in panel, use full representation directly (no popup)
    preferredRepresentation: inPanel ? fullRepresentation : compactRepresentation

    compactRepresentation: Item {
        id: compact

        Loader {
            id: compactImageLoader
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing

            sourceComponent: root.isAnimated ? animatedImageComponent : staticImageComponent

            Component {
                id: animatedImageComponent
                AnimatedImage {
                    source: root.imagePath
                    fillMode: Image.PreserveAspectFit
                    playing: true
                    visible: root.imagePath !== ""
                    cache: false
                    smooth: true
                    asynchronous: true
                }
            }

            Component {
                id: staticImageComponent
                Image {
                    source: root.imagePath
                    fillMode: Image.PreserveAspectFit
                    visible: root.imagePath !== ""
                    cache: true
                    smooth: true
                    asynchronous: true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: root.webLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: function(mouse) {
                if (mouse.button === Qt.LeftButton && root.webLink) {
                    root.openWebLink()
                } else if (mouse.button === Qt.RightButton || !root.webLink) {
                    root.expanded = !root.expanded
                }
            }
        }

        Kirigami.Icon {
            anchors.centerIn: parent
            source: "image-x-generic"
            visible: root.imagePath === ""
            width: Math.min(parent.width, parent.height) * 0.7
            height: width

            MouseArea {
                anchors.fill: parent
                onClicked: root.expanded = !root.expanded
            }
        }
    }

    fullRepresentation: Item {
        id: fullRep
        Layout.minimumWidth: Kirigami.Units.gridUnit * 2
        Layout.minimumHeight: Kirigami.Units.gridUnit * 2
        Layout.preferredWidth: inPanel ? Kirigami.Units.gridUnit * 2 : Kirigami.Units.gridUnit * 25
        Layout.preferredHeight: inPanel ? Kirigami.Units.gridUnit * 2 : Kirigami.Units.gridUnit * 25

        Loader {
            id: fullImageLoader
            anchors.fill: parent
            anchors.margins: Kirigami.Units.largeSpacing

            sourceComponent: root.isAnimated ? fullAnimatedImageComponent : fullStaticImageComponent

            Component {
                id: fullAnimatedImageComponent
                AnimatedImage {
                    source: root.imagePath
                    fillMode: root.autoResize ? Image.PreserveAspectFit : Image.Pad
                    playing: true
                    visible: root.imagePath !== ""
                    cache: false
                    smooth: true
                    asynchronous: true
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }
            }

            Component {
                id: fullStaticImageComponent
                Image {
                    source: root.imagePath
                    fillMode: root.autoResize ? Image.PreserveAspectFit : Image.Pad
                    visible: root.imagePath !== ""
                    cache: true
                    smooth: true
                    asynchronous: true
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: root.webLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: root.imagePath !== "" && root.webLink !== ""

            onClicked: {
                root.openWebLink()
            }
        }

        Kirigami.PlaceholderMessage {
            anchors.centerIn: parent
            width: parent.width - (Kirigami.Units.largeSpacing * 4)
            visible: root.imagePath === "" && !inPanel
            text: i18n("No image selected")
            explanation: i18n("Right-click the widget and select 'Configure...' to set an image file path, or drag and drop an image file here")
            icon.name: "image-x-generic"
        }

        DropArea {
            anchors.fill: parent
            onDropped: function(drop) {
                if (drop.hasUrls && drop.urls.length > 0) {
                    let url = drop.urls[0].toString()
                    // Remove file:// prefix if present
                    if (url.startsWith("file://")) {
                        url = url.substring(7)
                    }
                    plasmoid.configuration.imagePath = url
                    drop.accept()
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Kirigami.Theme.highlightColor
                border.width: 3
                radius: Kirigami.Units.cornerRadius
                visible: parent.containsDrag
                opacity: 0.5
            }
        }
    }
}
EOF

########################################
# Package + Install (Plasma 6.4 syntax)
########################################
echo "📦 Packaging plasmoid..."
cd "$BUILD_DIR"
ZIP_FILE="$BUILD_DIR/${PLASMOID_ID}.plasmoid"

# Remove old package if exists
rm -f "$ZIP_FILE"

# Create package
zip -qr "$ZIP_FILE" "$PLASMOID_ID"

echo "📦 Built: $ZIP_FILE"
echo "🚀 Installing..."

# Remove old version if exists (suppress error if not installed)
echo "🗑️  Removing old version if it exists..."
kpackagetool6 -t Plasma/Applet -r "$PLASMOID_ID" 2>/dev/null || echo "   (No previous version found)"

# Also remove any manually created directories
rm -rf "$HOME/.local/share/plasma/plasmoids/$PLASMOID_ID"

# Install new version
if kpackagetool6 -t Plasma/Applet -i "$ZIP_FILE"; then
    echo "✅ Image Web Link plasmoid installed successfully!"
    echo ""
    echo "🔄 Restarting Plasma shell..."
    killall plasmashell 2>/dev/null || true
    sleep 2
    kstart plasmashell &>/dev/null &
    echo ""
    echo "✅ Complete! Add the widget via:"
    echo "   Right-click desktop → Add Widgets → Image Web Link"
    echo ""
    echo "📝 Changes in v1.3:"
    echo "   • Added 'Link Name' field in settings"
    echo "   • Tooltip shows link name when hovering in panels"
    echo "   • Minimum size set to 2x2 grid units"
    echo "   • Popup removed when plasmoid is in a panel"
    echo ""
    echo "🧹 Cleaning up temporary files..."
    rm -rf "$BUILD_DIR"
else
    echo "❌ Installation failed!"
    echo "Package location: $ZIP_FILE"
    echo "Leaving temporary files for debugging."
    exit 1
fi
