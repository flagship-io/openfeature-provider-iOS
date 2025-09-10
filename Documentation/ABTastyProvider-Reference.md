# ABTastyProvider Reference Documentation

## Overview

`ABTastyProvider` is an implementation of OpenFeature's `FeatureProvider` protocol that integrates with AB Tasty's feature flag management system through the Flagship SDK. It provides a bridge between OpenFeature's standardized API and AB Tasty's functionality.

## Requirements

- iOS 15.0+
- Flagship/FlagShip framework
- OpenFeature framework
- Combine framework

## Class Definition

```swift
public class ABTastyProvider: FeatureProvider
```

## Metadata

The provider uses custom metadata structure:

```swift
public struct ABTastyMetadata: ProviderMetadata {
    public var name: String? = "FlagshipProvider"
}
```

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `metadata` | `any OpenFeature.ProviderMetadata` | Provider metadata containing name and configuration |
| `hooks` | `[any OpenFeature.Hook]` | Array of provider hooks |
| `eventHandler` | `EventHandler` | Private handler for provider events |
| `fsClient` | `FSVisitor?` | Optional Flagship visitor client |
| `abClient` | `ABTastyClient?` | Private AB Tasty client instance |

## Initialization

```swift
public init(
    envId: String,
    apiKey: String,
    configurator: FlagshipConfig
)
```

### Parameters
- `envId`: Environment identifier for AB Tasty
- `apiKey`: Authentication API key
- `configurator`: Configuration instance for Flagship SDK

## Core Methods

### Initialize

```swift
public func initialize(
    initialContext: (any OpenFeature.EvaluationContext)?
) async throws
```

Initializes the provider with optional context data. This method:
- Processes the initial context into Flagship format
- Extracts consent information
- Creates an AB Tasty client instance

### Context Management

```swift
public func onContextSet(
    oldContext: (any OpenFeature.EvaluationContext)?, 
    newContext: any OpenFeature.EvaluationContext
) async throws
```

Updates the provider context with new evaluation context data. This method:
- Converts OpenFeature context to Flagship format
- Updates consent status
- Updates visitor ID
- Updates AB Tasty client with new context

## Feature Flag Evaluation Methods

### Boolean Evaluation

```swift
public func getBooleanEvaluation(
    key: String,
    defaultValue: Bool,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Bool>
```

### String Evaluation

```swift
public func getStringEvaluation(
    key: String,
    defaultValue: String,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<String>
```

### Integer Evaluation

```swift
public func getIntegerEvaluation(
    key: String,
    defaultValue: Int64,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Int64>
```

### Double Evaluation

```swift
public func getDoubleEvaluation(
    key: String,
    defaultValue: Double,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<Double>
```

### Object Evaluation

```swift
public func getObjectEvaluation(
    key: String,
    defaultValue: OpenFeature.Value,
    context: (any OpenFeature.EvaluationContext)?
) throws -> OpenFeature.ProviderEvaluation<OpenFeature.Value>
```

Note: Object evaluation currently always returns the default value.

## Event Observation

```swift
public func observe() -> AnyPublisher<OpenFeature.ProviderEvent?, Never>
```

Returns a Combine publisher for observing provider events.

## Usage Example

```swift
// Initialize the provider
let provider = ABTastyProvider(
    envId: "your-env-id",
    apiKey: "your-api-key",
    configurator: FlagshipConfig()
)

// Initialize with context
let context = EvaluationContext(
    targetingKey: "user-123",
    attributes: ["hasConsented": true]
)
try await provider.initialize(initialContext: context)

// Get a feature flag value
let flagValue = try provider.getBooleanEvaluation(
    key: "my-feature",
    defaultValue: false,
    context: nil
)

// Observe provider events
let cancellable = provider.observe()
    .sink { event in
        if let event = event {
            print("Provider event received: \(event)")
        }
    }
```

## Important Notes

### Context Handling
- The provider automatically converts OpenFeature context format to Flagship format
- Consent status is extracted from the `hasConsented` context attribute
- Visitor ID is managed through the targeting key in the evaluation context

### Default Values
- All evaluation methods return the default value if the AB Tasty client is not initialized
- Object evaluation method always returns the default value

### Framework Compatibility
The provider includes conditional imports to support both Flagship and FlagShip framework variations:

```swift
#if canImport(Flagship)
import Flagship
#elseif canImport(FlagShip)
import FlagShip
#else
#error("Flagship framework not found")
#endif
```