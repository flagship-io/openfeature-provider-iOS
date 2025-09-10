# Welcome to the Comprehensive Guide for OpenFeature x Flagship iOS
This documentation is your one-stop resource for integrating Flagship integration for OpenFeature.  Our library comes with preconfigured methods designed to simplify the implementation of the Decision API or Bucketing Mode. Let's get started on enhancing your development experience with OpenFeature x Flagship!

## Table of Contents
- [Overview](#overview)
- [Installation](#installation)
  - [CocoaPods](#cocoapods)
  - [Swift Package Manager](#swift-package-manager)
- [Quick-start](#quick-start)
  - [Register the ABTastyProvider with OpenFeature](#register-the-abtastyprovider-with-openfeature)
  - [Flag Evaluation (Read Flag)](#flag-evaluation-read-flag)
  - [Context Updates](#context-updates)
- [Reference](#reference)
  - [Class Definition](#class-definition)
  - [Metadata](#metadata)
  - [Initialization](#initialization)
  - [Core Methods](#core-methods)
  - [Feature Flag Evaluation Methods](#feature-flag-evaluation-methods)
- [Contact us](#contact-us)

## Overview

`ABTastyProvider` is an implementation of OpenFeature's `FeatureProvider` protocol that integrates with AB Tasty's feature flag management system through the Flagship SDK. It provides a bridge between OpenFeature's standardized API and AB Tasty's functionality.




## Installation
**- iOS 15.0+**

**- Xcode 14.0+**

**- ABTasty account with environment ID and API key**

### Installation Methods

#### CocoaPods

1. Make sure you have CocoaPods installed. If not, install it:

```bash
sudo gem install cocoapods
```

2. Create a Podfile in your project directory if you don't have one:

```bash
pod init
```

3. Add the following line to your Podfile:

```bash
pod 'ABTastyOpenfeature-iOS'
```

4. Install the dependencies:

```bash
pod install
```

5. Open the .xcworkspace file instead of the .xcodeproj file from now on.

#### Swift Package Manager

1. In Xcode, select File > Add Packages...
2. Enter the package repository URL:

```bash
https://github.com/flagship-io/openfeature-provider-iOS.git
```

3. Select the version rule (Recommended: Up to Next Major Version)
4. Click Add Package

Alternatively, add it directly to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/flagship-io/openfeature-provider-iOS.git", from: "1.0.0")
]
```

## Quick-start

### Register the ABTastyProvider  with OpenFeature

`Init` and `Set` provider with `context`

{% hint style="info" %}
In the context use the **targetingKey** for the visitorId and you should mention **hasConsented through the context**&#x20;
{% endhint %}

```swift
 
 // Create a context with an "openUserId"
 let ctx = MutableContext(
            targetingKey: "openUserId",
            structure: MutableStructure(attributes: ["isQA": Value.boolean(true),
                                                     "city": Value.string("FR"),
                                                     "hasConsented": Value.boolean(true),
                                                     "ctx1": Value.boolean(false),
                                                     "ctx2": Value.integer(125),
                                                     "ctx3": Value.double(12.0)])
                                                     
Task {
    // Create ABTasty provider
   let provider = ABTastyProvider(envId: "envId", apiKey: "apiKey", configurator: FSConfigBuilder().build())
   // Set provider through OpenFeature API
   await OpenFeatureAPI.shared.setProviderAndWait(provider: provider, initialContext: ctx)
}
```

### Flag Evaluation (Read Flag)

After `init` and `set` provider with the apropriate `context` use the client instance to get the evaluation flag

```swift
// Update UIs on the main thread
DispatchQueue.main.async {
 // get a bool flag value
 let client = OpenFeatureAPI.shared.getClient()
 // Retreive the String flag for 'btnTitle'key
 let btnTitle = client.getStringValue(key: "btnTitle", defaultValue: "default")
 // Retreive the Integer flag for 'intValue'key
 let intValue = client.getIntegerValue(key: "intValue", defaultValue: 0)
 // Update UIs
}
```

### Context Updates

 On visitor context changed use `setEvaluationContextAndWait` function before read flag value 

```swift
 // New context to inject 
  let updatedContext = MutableContext(
            targetingKey: "openUserId",
            structure: MutableStructure(attributes: ["isQA": Value.boolean(false)]))
  Task {
        await OpenFeatureAPI.shared.setEvaluationContextAndWait(evaluationContext: updatedContext)
        // Refresh the values after context update
            DispatchQueue.main.async {
                let client = OpenFeatureAPI.shared.getClient()
                // get String value for 'btnTitle' key flag
                let btnTitle = client.getStringValue(key: "btnTitle", defaultValue: "default")
                // get Integer value for 'intValue' key flag
                let intValue = client.getIntegerValue(key: "intValue", defaultValue: 0)
                // Update UIs
        }
    }

```
## Reference
### Class Definition
```swift
public class ABTastyProvider: FeatureProvider
```

### Metadata
The provider uses custom metadata structure:

```swift
public struct ABTastyMetadata: ProviderMetadata {
    public var name: String? = "FlagshipProvider"
}
```

### Initialization

```swift
public init(
    envId: String,
    apiKey: String,
    configurator: FlagshipConfig
)
```

###

| Parameter    | Type           | Description                                                                                                      |
| ------------ | -------------- | ---------------------------------------------------------------------------------------------------------------- |
| envId        | String         | Environment ID provided by ABTasty                                                                              |
| apiKey       | String         | Api authentication key provided by ABTasty.                                                                     |
| configurator | FlagshipConfig | Custom flagship configuration. [see SDK configuration](https://docs.abtasty.com/server-side/sdks/ios/ios-1/swift-reference#configuration) |



### Core Methods

#### Initialize

Initializes the provider with optional context data. This method:

\- Processes the initial context into Flagship format

\- Extracts consent information

\- Creates an AB Tasty client instance

```swift
public func initialize(
    initialContext: (any OpenFeature.EvaluationContext)?
) async throws
```

#### Context Management

Updates the provider context with new evaluation context data. This method:

\- Converts OpenFeature context to Flagship format

\- Updates consent status

\- Updates visitor ID

\- Updates ABTasty client with new context

```swift
public func onContextSet(
    oldContext: (any OpenFeature.EvaluationContext)?, 
    newContext: any OpenFeature.EvaluationContext
) async throws
```

### Feature Flag Evaluation Methods

#### Boolean Evaluation

```swift
public func getBooleanEvaluation(
    key: String,
    defaultValue: Bool,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Bool>
```

#### String Evaluation

```swift
public func getStringEvaluation(
    key: String,
    defaultValue: String,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<String>
```

#### Integer Evaluation

```swift
public func getIntegerEvaluation(
    key: String,
    defaultValue: Int64,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Int64>
```

#### Double Evaluation

```swift
public func getDoubleEvaluation(
    key: String,
    defaultValue: Double,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Double>
```

#### Object Evaluation

```swift
public func getObjectEvaluation(
    key: String,
    defaultValue: OpenFeature.Value,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<OpenFeature.Value>
```

## Contact us

Feel free to [contact us](mailto:product.feedback@abtasty.com?subject=Flagship%20Developer%20Documentation) if you have any questions regarding this documentation.

