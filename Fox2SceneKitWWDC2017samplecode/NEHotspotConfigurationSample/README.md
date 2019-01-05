# NEHotspotConfigurationSample

NEHotspotConfigurationSample shows how to use `NEHotspotConfigurationManager` to create new Wi-Fi configurations, both persistent and one-off.

**IMPORTANT** Despite their similar names, `NEHotspotConfigurationManager` and `NEHotspotHelper` perform very different functions.  For more information on how these APIs fit into the iOS Wi-Fi landscape, see QA1942 [iOS Wi-Fi Management APIs][qa1942].

[qa1942]: <https://developer.apple.com/library/mac/#qa/qa1942/_index.html>


## Requirements

### Build

Xcode 9.3

The sample was built using Xcode 9.3 on macOS 10.13.4 with the iOS 11.3 SDK.  You should be able to open the project and choose *Product* > *Build*.

**IMPORTANT** The sample is set up to use Xcode’s automatic code signing support.  To build the sample to run on a device, you must configure it to use your team (via *General* > *Signing* > *Team* in the target editor).

**IMPORTANT** `NEHotspotConfigurationManager` is not supported on the simulator and the sample will not build for that environment.

### Runtime

iOS 11.0 or later

`NEHotspotConfigurationManager` is new in iOS 11.


## Packing List

The sample contains the following items:

* `README.md` — This file.

* `LICENSE.txt` — The standard sample code licence.

* `NEHotspotConfigurationSample.xcodeproj` — An Xcode project for the program.

* `NEHotspotConfigurationSample` — A directory for the app, which contains:

  - `Info.plist`, `LaunchScreen.storyboard`, `NEHotspotConfigurationSample.entitlements` — Various boilerplate resources.
  
  - `AppDelegate.swift` — The central controller for the app.
  
  - `Main.storyboard` — The main storyboard for the app.
  
  - `HotspotsViewController.swift` — The main view controller for the app.
  
  - `AddViewController.swift` — A view controller that let’s the user add a new Wi-Fi configuration.

  - `HotspotManager.swift` — A model-level object that wraps `NEHotspotConfigurationManager` to make it easier for the view controller to use.


## Using the Sample

**IMPORTANT** The sample must be run on a real device because `NEHotspotConfigurationManager` is not supported on the simulator.

To use the sample:

1. Run the app.

2. Tap the add (+) button to add a new Wi-Fi configuration; the system will prompt you to confirm this operation.

3. Once you’ve added a configuration, you can tap the associated Delete button to delete it


## How it Works

This is not a complex sample.  The `HotspotManager` class contains all of the stuff specific to `NEHotspotConfigurationManager`.  The rest of the code is just a basic UI wrapped around that functionality.

The `HotspotManager` class has extensive doc comments, so look in `HotspotManager.swift` for more information about that code.


## Caveats

`NEHotspotConfigurationManager` has a raft of options for handling all sorts of weird and wonderful Wi-Fi configurations. This sample does not attempt to surface all of those options.  Rather, it presents a very simple UI that lets you configure:

* The network’s SSID
* The password, if any
* Whether that password is WPA-style or WEP-style
* Whether to join the network once or remember the network for future use

If you need any of the other options (Hotspot 2.0, EAP-TLS, and so on) it should be relatively straightforward to extend this code to support them.

On early versions of iOS 11 deleting one configuration would deleting all of your app’s configurations (r. 33776794). This bug is fixed in iOS 11.2 and later.

If you join a network temporarily (by setting `joinOnce` to true), it can take a while (a few tens of seconds) to rejoin the infrastructure Wi-Fi after you leave the NEHotspotConfigurationSample app.


## Feedback

If you find any problems with this sample, or you’d like to suggest improvements, please [file a bug][bug] against it.

[bug]: <http://developer.apple.com/bugreporter/>


## Version History

1.0d1 (Aug 2017) was released to a small number of developers on a one-to-one basis.

1.0d2 (Aug 2017) was released to a small number of developers on a one-to-one basis; the changes relative to 1.0d1 are all cosmetic (read me improvements, doc comments, and so on).

1.0 (Apr 2018) was the first shipping version. Changes relative to 1.0d2 include:

* Added a code to display an alert when adding a network configuration fails
* Changed the read me discussion of `joinOnce` to reflect new discoveries
* Changed the project to quieten a bogus warning from the *Capabilities* editor
* Updated to Xcode 9.1
* Various ‘cosmetic’ changes to comments and the read me

Share and Enjoy

Apple Developer Technical Support<br>
Core OS/Hardware

26 Apr 2018

Copyright (C) 2018 Apple Inc. All rights reserved.
