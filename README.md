# MacMenu

<p align=center>
    <img src="MacMenu/Assets.xcassets/AppIcon.appiconset/Icon-128.png" alt="MacMenu Icon" width="128">
</p>

MacMenu is a multi-purpose menu bar application for macOS. It features a window manager, a keyboard cleaning mode and basic system monitoring.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## System Requirements

MacMenu requires macOS 11.0 or later. Older versions of macOS are not tested and may not work.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## Installation

Download the latest version from the [releases page](https://github.com/dan-koller/macmenu/releases). On first launch, macOS will warn you that the application is from an unidentified developer. To open it, right-click the application and select "Open". You will only have to do this once.

Also, you need to grant accessibility permissions to MacMenu. To do this, go to System Preferences > Security & Privacy > Privacy > Accessibility and check the box next to MacMenu. You can also add MacMenu to the list of login items to automatically launch it on login.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## Usage

### Window Manager

I hope it's pretty self-explanatory. You can drag windows to the edges of the screen to snap them to the sides or corners. You can also drag windows to the top of the screen to maximize them. You can also use the keyboard shortcuts:

| Shortcut | Action                              |
| -------- | ----------------------------------- |
| (^⌥←)    | Snap window to left half of screen  |
| (^⌥→)    | Snap window to right half of screen |
| (^⌥↑)    | Maximize window to full screen      |
| (^⌥↓)    | Center half of screen               |
| (^⌥c)    | Center current window (keep size)   |
| (^⌥⌘↑)   | Top half of screen                  |
| (^⌥⌘↓)   | Bottom half of screen               |

### Keyboard Cleaning

The cleaning mode disables the keyboard for a maximum of 20 seconds. This is useful if you want to clean your keyboard without accidentally triggering shortcuts.

### System Monitoring

The system monitoring feature displays the current CPU and RAM usage as well as disk space. You can also click on the menu bar item to display more information.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## Building

To build MacMenu, you need Xcode 12 or later. Simply open the project in Xcode and build it.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more information.

<img src="https://raw.githubusercontent.com/andreasbm/readme/master/assets/lines/solar.png">

## Credits

Some of the window management code is ported from [Rectangle](https://github.com/rxhanson/Rectangle). Special thanks to [rxhanson](https://github.com/rxhanson) for making Rectangle open source.
