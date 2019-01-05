/*
    Copyright (C) 2018 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    Main app controller.
 */

import UIKit

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// A reference to the ‘model’ object that represents our hotspot
    /// configurations.

    var manager: HotspotManager! = nil

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    
        // Create and retain our model-level controller.  This vends hotspot
        // data in a way that’s easier for our view controller to use.

        self.manager = HotspotManager()
        
        // Create the main view controller (HotspotsViewController), inject
        // our manager into that, and then use it as the root of our navigation
        // hierarchy.
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let hotspots = mainStoryboard.instantiateViewController(withIdentifier: "hotspots") as! HotspotsViewController
        hotspots.manager = self.manager
        (self.window!.rootViewController! as! UINavigationController).viewControllers = [ hotspots ]
        
        return true
    }
}
