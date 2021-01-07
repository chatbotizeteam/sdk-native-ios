
# Zowie iOS SDK
[![Swift 5.3 Supported](https://img.shields.io/badge/Swift-5.3-green.svg)](https://github.com/apple/swift) [![Swift 5.3 Supported](https://img.shields.io/badge/iOS-11+-orange.svg)](https://apple.com) 
  

## Installation

  

### Cocoapods

  
  Add `pod ZowieSDK` to your Podfile
  
```
pod ZowieSDK
```

To support dependencies that Zowie uses, add the following code at the end of your `Podfile`

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end
```
  

## Usage

  

### Initialization

To be able to use Zowie SDK first of all you have to provide the configuration:

```swift
let configuration = ZowieConfiguration(
    userId: "USERID",
    conversationId: "CONVERSATIONID",
    instanceId: "INSTANCEID",
    referralId: nil,
    authType: .raw
)

Zowie.shared.set(configuration: configuration)
```

Both `referralId` and `authType` are optional. ****Remember you won't be able to use ANY of SDK functionalities without a proper configuration  setup, so be sure that you provide it.****

  

If your integration requires token authentication you can replace `.raw` with `.token`.


### Chat UI

  

You can access Chat UI from `ZowieChatViewController`. It can be used just like a regular view controller, so it's up to you how you want to put it in your stack. For example, you can show it from a different view controller:
```swift
let chatViewController = ZowieChatViewController()()
navigationController?.pushViewController(chatViewController, animated: true)
  ```

### Setting user metadata

  

You can set needed user metadata. All those fields are optional.

```swift
let metadata = ZowieMetadata(
    firstName: "first",
    lastName: "last",
    name: "name",
    locale: "locale",
    timeZone: "timeZone",
    phoneNumber: "123456789",
    email: "email@email.com"
)
Zowie.shared.set(metadata: metadata)
```

### FCM notifications
To receive FCM notifications you have to provide `deviceToken`
```swift
Zowie.shared.set(fcmToken: "token") { result in
    // Completion handler is optional
}
```
This will allow us to send push notifications to user device. Remember that you have set up all required notification related permissions.

If you want to disable notifications, use:
```swift
Zowie.shared.disableNotifications() { result in
    // Completion handler is optional
}
```
###  User status
To set user's status, use:
```swift
Zowie.shared.setStatus(isActive: true) { result in
    // Completion handler is optional
}
```

### Context
You can feed backend with the `contextId`
```swift
Zowie.shared.set(contextId: "contextId") { result in
    // Completion handler is optional
}
```
## Customization

  

### Localization

The only supported language in this SDK is `english`. If you need more localization please provide it as below:

```swift
let strings = ZowieStrings(
    messagePlaceholder: "string",
    sendFailureErrorMessage: "string",
    tryAgain: "string",
    delivered: "string",
    attachment: "string",
    disconnectMessage: "string",
    reconnectMessage: "string",
    historyErrorMessage: "string"
)

Zowie.shared.set(strings: strings)
```

  

### Colors
Feel free to set up color branding however you like with help of  `Zowie.shared.set(colors: colors)`


