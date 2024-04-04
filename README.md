# swipee

[![Version](https://img.shields.io/pub/v/swipee.svg)](https://pub.dev/packages/swipee)
[![Generic badge](https://img.shields.io/badge/platform-android%20|%20ios%20|%20web%20-blue.svg)](https://pub.dev/packages/swipee)

 Customizable Swipe Button for flutter

## Screenshots



## How to use

```yaml
dependencies:
  swipee: <latest_version>
```


```dart
import 'package:swipee/swipee.dart';

```

```dart
     // basic usage
    Swipee(
        label: "Swipe Me",
        onSwipe: () {
            EasyLoading.showSuccess('Swiped!');
        }),

    // customize track and button
    Swipee(
        trackWidth: 250,
        trackHeight: 30,
        buttonWidth: 80,
        buttonHeight: 50,
        color: Colors.red,
        trackColor: Colors.amber,
        onSwipe: () {
        EasyLoading.showSuccess('Swiped!');
        },
        trackChild: const Text('> > > > >', style: TextStyle(fontSize: 20)),
        child: const Icon(Icons.arrow_forward),
    )

    // vertical swipe
    Swipee(
        axis: Axis.vertical,
        width: 50,
        height: 100,
        trackWidth: 30,
        trackHeight: 60,
        buttonWidth: 40,
        buttonHeight: 40,
        radius: 0,
        label: "GO!",
        color: Colors.blue,
        trackColor: Colors.indigo[100],
        onSwipe: () {
        EasyLoading.showSuccess('Swiped!');
        },
    )


```

## TODOs
- Material UI
- Unit Testing
- RTL and TTB swiping
- More customisation options


## Buy me a Coffee
ETH: alexay.eth

