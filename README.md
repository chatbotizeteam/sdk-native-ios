# Zowie iOS SDK

[![Swift 5.3 Supported](https://img.shields.io/badge/Swift-5.3-green.svg)](https://github.com/apple/swift) [![Swift 5.3 Supported](https://img.shields.io/badge/iOS-12+-orange.svg)](https://apple.com)

## Installation

### Swift Package Manager

1. Follow the [Apple guide](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) to add the package dependency to your app.
2. Search for the `https://github.com/chatbotizeteam/sdk-native-ios.git` package.
3. Use the `spm` branch requirement.
4. Use `import ZowieSDK`

### WARNING
This is a temporary solution for SPM support. We are aware of the `is implemented in both` issue and we're trying to fix it.

## Usage

### Initialization

To be able to use Zowie SDK first of all you have to provide the configuration:

```swift
let configuration = ZowieConfiguration(
    instanceId: "INSTANCE_ID",
    authType: .anonymous,
    chatHost: "CHAT_HOST",
    startOnOpen: true,
    sessionTimeout: (timeout: 300000, onTimeout: {
            dismiss()
        })
)

Zowie.shared.set(configuration: configuration)
```

> ⚠️ **IMPORTANT**
> Choose the initialization flow properly. If chat is started immediately after SDK setup, use the `ASYNC` flow to guarantee full SDK initialization.

SDK configuration using `Zowie.shared.set(configuration:)` supports two initialization flows:

- `SYNC`: Call configuration setup in `AppDelegate`/`SceneDelegate` and present chat later during app runtime.
- `ASYNC`: Use asynchronous configuration setup when chat must be presented immediately after initialization. This is the only flow that guarantees the SDK is fully initialized before chat startup.

\***\*Remember, you won't be able to use ANY of SDK functionalities without a proper configuration setup, so be sure you provide it.\*\***

You can clear anonymous session with `Zowie.shared.clearAnonymousSession(forInstanceId: "INSTANCEID)`. If your integration requires token authentication you can replace `.anonymous` with `.token`.

### Chat UI

You can access Chat UI from `ZowieChatViewController`. Use it just like a regular view controller, so it's up to you how you want to put it in your stack. For example, you can show it from a different view controller:

```swift
let chatViewController = ZowieChatViewController()
navigationController?.pushViewController(chatViewController, animated: true)
```

### Voice UI

You can also open the voice agent directly — there is no need to go through the text chat first. Use `ZowieVoiceChatViewController` like any other view controller (push or present):

```swift
let voiceChatViewController = ZowieVoiceChatViewController()
navigationController?.pushViewController(voiceChatViewController, animated: true)
```

> ⚠️ **Microphone permission**
> Your app's `Info.plist` must contain `NSMicrophoneUsageDescription` (or the equivalent `INFOPLIST_KEY_NSMicrophoneUsageDescription` build setting if your project uses generated Info.plist).

### Chat initialization error

If you want to handle the chat initialization error, use:

```swift
Zowie.shared.onChatInitializationError = { error in
    // Do something
}
```

### Lifecycle events

The SDK fires a single callback when its view controllers transition on/off screen. Use it for analytics, host-UI coordination, or to drive whatever "chat is active" state your app keeps.

```swift
Zowie.shared.onScreenEvent = { event in
    switch event {
    case .chatDidAppear, .chatWillDisappear: ...
    case .voiceDidAppear, .voiceWillDisappear: ...
    }
}
```

Set once at app launch. Adding a new screen type later is an enum case, not a new property.

### Custom Attributes

Use `ZowieAttributes` to configure metadata, context and appearance.

```swift
let attributes = ZowieAttributes(
    metadata: ZowieMetadata(
        firstName: "first",
        lastName: "last",
        name: "name",
        locale: "locale",
        timeZone: "timeZone",
        phoneNumber: "123456789",
        email: "email@email.com",
        extraParams: ["custom": "value"]
    ),
    context: "contextId",
    inputPlaceholder: "Write to reply...",
    primaryColor: "#222529",
    fontColor: .white,
    ctaColor: "#14B8A6",
    userMessageBackgroundColor: "#222529",
    userMessageFontColor: .white
)

Zowie.shared.set(customAttributes: attributes) { result in
    // Completion handler is optional
}
```

The following APIs are still available for backward compatibility, but are deprecated in favor of `ZowieAttributes`:

- `Zowie.shared.set(metadata:)`
- `Zowie.shared.set(contextId:)`
- `Zowie.shared.set(layoutConfiguration:)`
- `Zowie.shared.set(colors:)`
- `Zowie.shared.set(strings:)`

### Starting a fresh session

By default, `set(configuration:)` reuses any cached anonymous identity from a previous launch so the user resumes their conversation. To **start clean every time** (e.g. a kiosk app, or after a user logs out), pass `freshSession: true`:

```swift
await Zowie.shared.set(
    configuration: configuration,
    freshSession: true
)
```

- For **anonymous auth**: deletes the keychain entries for `configuration.instanceId`. The next sign-in mints a brand-new user.
- For **token auth**: the keychain isn't used; this just drops the in-memory cache (services rebuilt, message list cleared).

`freshSession` defaults to `false`, so existing integrations see no change.

### Setting a referral value
```swift
/// Sets a referral value for the conversation.
///
/// - Parameters:
///   - referral: A `String` representing the referral information to be set.
///   - completion: A closure that is called upon completion of the operation. The closure provides a `ZowieReferralStatus`
///                 which indicates the outcome of setting the referral:
///       - `.failure(ZowieError)`: The operation failed, with the associated `ZowieError` providing details about the error.
///       - `.waiting`: The referral has been accepted and will be sent during the next chat initialization.
///       - `.success`: The operation completed successfully and the referral was set immediately.
Zowie.shared.set(referral: "VALUE") { status in
    // status handling
}
```

### FCM notifications

To receive FCM notifications you have to provide `deviceToken`

```swift
Zowie.shared.set(fcmToken: "token") { result in
    // Completion handler is optional
}
```

This will allow us to send push notifications to the user's device. Remember that you have set up all required notification-related permissions.

If you want to disable notifications, use:

```swift
Zowie.shared.disableNotifications() { result in
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

### Layout `deprecated in favor of ZowieAttributes`

```swift
let config = ZowieLayoutConfiguration(showConsultantAvatar: false, consultantNameMode: .firstName)
Zowie.shared.set(layoutConfiguration: config)
```

### Localization `deprecated in favor of ZowieAttributes`

The only supported language in this SDK is `english`. If you need more localization please provide it as below:

```swift
let strings = ZowieStrings(
    messagePlaceholder: "string",
    sendFailureErrorMessage: "string",
    tryAgain: "string",
    delivered: "string",
    read: "string",
    attachment: "string",
    disconnectMessage: "string",
    reconnectMessage: "string",
    historyErrorMessage: "string"
)

Zowie.shared.set(strings: strings)
```

### Colors `deprecated in favor of ZowieAttributes`

Feel free to set up color branding however you like with help of `Zowie.shared.set(colors: colors)`

### URL Handling

By default, Zowie SDK opens URLs using an external web browser. You can provide custom handling:

```swift
Zowie.shared.set(urlHandler: { url, source in
    // Return false if you want to handle URL by yourself
    return false
})
```

### AI Session Notice

If AI session notice is enabled in widget configuration, SDK shows a default notice and bottom sheet.

You can override the "More" action:

```swift
Zowie.shared.onAISessionNoticeMoreTapped = { header, message in
    // Present your own explanation screen
}
```

When no custom handler is provided, SDK shows its default bottom sheet.

### Markdown Content

SDK renders Markdown in supported message content, including links, emphasis and selected block elements. URL taps still go through the configured URL handler.

### Decision Engine Events

You can listen for Decision Engine events triggered from the configured scenario with `Zowie.shared.on(eventName, handler)`.

For more information about Decision Engine, see the [Decision Engine API documentation](https://github.com/chatbotizeteam/decission-engine-api#ui).

- `eventName` must match decision engine event name exactly.
- `params` is delivered as `Any?` and depends on what was sent from the Decision Engine scenario:
  - JSON object: `[String: Any]`
  - JSON array: `[Any]`
  - plain value or invalid JSON: `String`
  - missing value: `nil`

```swift
Zowie.shared.on("meetingDetails") { [weak self] params in
    // handle event payload
    self?.handleMeetingDetails(params)
}
```

To remove a handler for a given event, use `off`:

```swift
Zowie.shared.off("meetingDetails")
```
