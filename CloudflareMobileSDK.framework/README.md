# Cloudflare Mobile SDK

## Requirements ##

- Xcode 7 and above
- iOS 7.0 and above
  
## Installing the Cloudflare Mobile SDK ##

### Bitcode ###

There is both bitcode enabled and bitcode disabled versions of Cloudflare Mobile SDK. To distinguish whether a version of SDK has bitcode enabled,
check the last digit of the release version.

>
+ x.x.x.1 -> Bitcode Enabled = No
+ x.x.x.2 -> Bitcode Enabled = Yes

To determine whether your application has bitcode enabled, navigate to your project and check the **Enable Bitcode** property in your **Build Settings**
under **Build Options**.

If you are unsure whether you should use bitcode enabled or disabled SDK, go ahead and choose bitcode enabled SDK as bitcode is enabled by default in latest Xcode versions.

### Manual installation (Drag and drop) ###

Download and unzip appropriate bitcode enabled/disabled Cloudflare Mobile iOS SDK from portal. You can find the download link under your App settings in portal.

1. Drag **CloudflareMobileSDK.framework** into your Xcode project.
2. Link following iOS frameworks in your project:
   + **SystemConfiguration.framework**
   + **CoreTelephony.framework**
   + **libresolv.9.tbd** (Xcode 7+) or **libresolv.9.dylib** (Xcode 6 and below).
 
   We use SystemConfiguration and CoreTelephony to optimize configurations for your network and to respond to any changes that may occur. We use libresolv 
   for DNS related functions.

### CocoaPods installation ###

If you use CocoaPods, add one of following line to your project’s ``podfile``
and run ``pod install`` or ``pod update``.

   pod ‘Cloudflare’

The latest version pulled through CocoaPods will be built with ``bitcode enabled``.
If you wish to have a bitcode disabled version, please find the latest 
Cloudflare [release](https://cocoapods.org/pods/Cloudflare) and append a ``1`` instead of ``2``.

    | Ex.
    | pod ‘CloudflareMobileSDK’, ‘1.2.0.1’ // Xcode 7 - Bitcode not enabled
    | pod ‘CloudflareMobileSDK’, ‘1.2.0.2’ // Xcode 7 - Bitcode enabled


## Initializing Cloudflare Mobile SDK ##

Initialization is the process of modifying your application in order to communicate with Cloudflare Network. To initialize the SDK, you’ll have to import
**CFMobile** header file into your AppDelegate’s implementation file.

For Swift applications, place this import in your **bridging-header.h** file.

{{<highlight swift>}}
// AppDelegate.m (Obj-C) or bridging-header.h (Swift)
#import <CloudflareMobileSDK/CFMobile.h>
{{</highlight>}}

Initialize SDK at the beginning of your AppDelegate's **application:didFinishLaunchingWithOptions:** method.

### Objective-C
{{<highlight swift>}}
[CFMobile initialize:@"CLOUDFLARE_CLIENT_KEY"];
{{</highlight>}}

### Swift
{{<highlight swift>}}
CFMobile.initialize("CLOUDFLARE_CLIENT_KEY");
{{</highlight>}}

A unique client key is created when you register your application and can be retrieved from the portal.

Cloudflare Mobile SDK is now integrated with your iOS application! The **SDK State** for the app version will be ``ON`` by default and this can be changed by clicking toggling the **SDK** button on top right corner of App details page.

## Verifying Integration ##

To verify that Cloudflare SDK is initialized you can add a **completionHandler** parameter to initialize selector which
will execute asychronously after SDK initialization is complete.

The **initialized** selector returns a boolean indicating whether SDK is initialized or not.

Here's an example of how you might verify SDK initialization.

### Objective-C
{{<highlight objective-c>}}
// Objective-C
[CFMobile initialize:@"CLOUDFLARE_CLIENT_KEY" completionHandler:^{
    if ([CFMobile initialized]) {
        // SDK is ON.
        ...
    } else {
        // SDK is OFF. Change log settings for more details.
        ...
    }
}];
{{</highlight>}}

### Swift
{{<highlight swift>}}
// Swift
CFMobile.initialize("tCMVTYrTosuMaDSy", completionHandler: {
    if (CFMobile.initialized()) {
        // SDK is ON.
        print("sdk is on")
        ...
    } else {
        // SDK is OFF. Change log settings for more details.
        print("sdk is off")
        ...
    }
})

{{</highlight>}}

## Disabling Cloudflare Mobile SDK ##

If for any reason you would like to disable Cloudflare Mobile SDK, navigate to the portal to your app settings and select the combination of application versions and/or 
Cloudflare SDK versions that should be disabled. Once disabled, SDK will not initialize on the device.

## Limitations ##

1. Cloudflare Mobile SDK has a native dependency which causes the Xcode debugger to stop on SIGPIPEs. These SIGPIPEs will not negatively affect your application and you can
   ignore them by adding a breakpoint with the debugger command 
   ``process handle SIGPIPE -n false -s false``
   
2. Cloudflare Mobile SDK does not currently support ``WKWebView`` requests.

## License ##

Commercial License. Please see https://storage.googleapis.com/cf-neumob-storage/mobile-sdk-license-agreement.pdf


