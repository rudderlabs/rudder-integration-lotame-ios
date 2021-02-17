# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating Lotame with RudderStack's iOS SDK

1. Add [Lotame](http://lotame.com) as a destination in the [Dashboard](https://app.rudderstack.com/).

2. Rudder-Lotame is available through [CocoaPods](https://cocoapods.org). To install it, add the following line to your Podfile and followed by `pod install`:

```ruby
pod 'Rudder-Lotame'
```

## Initialize ```RSClient```

Put this code in your ```AppDelegate.m``` file under the method ```didFinishLaunchingWithOptions```
```
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:DATA_PLANE_URL];
[builder withFactory:[RudderLotameFactory instance]];
[RSClient getInstance:WRITE_KEY config:[builder build]];
```

## Send Events

Follow the steps from our [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios).

## Contact Us

If you come across any issues while configuring or using this integration, please feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
