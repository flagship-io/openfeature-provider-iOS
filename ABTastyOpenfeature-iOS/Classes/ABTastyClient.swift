//
//  ABTastyResolver.swift
//  openFeature-iOS
//
//  Created by Adel Ferguen on 30/07/2025.
//


#if canImport(Flagship)
import Flagship
#elseif canImport(FlagShip)
import FlagShip
#else
#error("Flagship framework not found")
#endif
import Foundation
import OpenFeature

class ABTastyClient {
    /**
     The underlying Flagship visitor instance used to manage feature flag evaluations and context for the current user.

     - Note: This property is initialized in the class initializer and is used internally for all flag-related operations.
     */
    private var client: FSVisitor

    /**
     Initializes an `ABTastyClient` asynchronously with the specified visitor ID, consent status, and context.

     This initializer creates a new Flagship visitor instance and fetches all feature flags asynchronously.
     The initialization process waits for flag fetching to complete before returning.

     - Parameters:
        - visitorId: A unique identifier string for the visitor
        - hasConsented: A boolean flag indicating whether the visitor has given consent for data collection
        - context: A dictionary of key-value pairs containing additional context information for the visitor

     - Throws: An error if the flag fetching operation fails

     - Important: This is an asynchronous initializer that must be called with `await`
     */

    public init(visitorId: String, hasConsented: Bool, context: [String: Any]) async throws {
        // Create visitor
        client = Flagship.sharedInstance.newVisitor(visitorId: visitorId,
                                                    hasConsented: hasConsented,
                                                    instanceType: .NEW_INSTANCE)
            .withContext(context: context)
            .build()

        // Fetch flags asynchronously
        try await withCheckedThrowingContinuation { continuation in
            client.fetchFlags {
                continuation.resume()
            }
        }
    }

    /**
     Retrieves the evaluation of a feature flag for the given key and default value.

     - Parameters:
        - flagKey: The key identifying the feature flag.
        - defaultValue: The value to return if the flag is not found or cannot be evaluated.

     - Returns:
        An `OpenFeature.ProviderEvaluation` containing the flag value or the default value if unavailable.
     */
    public func getFlagEvaluation<T>(flagKey: String, defaultValue: T) -> OpenFeature.ProviderEvaluation<T> {
        // Get flag value
        let flagValue: T? = getFlag(flagKey: flagKey, defaultValue: defaultValue) as T?
        return ProviderEvaluation<T>(value: flagValue ?? defaultValue, variant: nil, reason: nil, errorCode: nil, errorMessage: nil)
    }

    /**
     Retrieves the value of a feature flag for the given key and default value.

     - Parameters:
        - flagKey: The key identifying the feature flag.
        - defaultValue: The value to return if the flag is not found or cannot be evaluated.

     - Returns:
        The value of the feature flag if available, otherwise the default value.
     */
    private func getFlag<T>(flagKey: String, defaultValue: T) -> T? {
        return client.getFlag(key: flagKey).value(defaultValue: defaultValue)
    }

    /**
     Updates the visitor configuration and fetches feature flags asynchronously.

     This method updates the visitor's configuration by either rebuilding the visitor instance (if visitorId changed)
     or updating the context (if only context changed). After updating, it fetches all feature flags.

     - Parameters:
        - visitorId: The new visitor identifier. If different from current, recreates visitor instance
        - hasConsented: A boolean indicating whether the visitor has consented to data collection
        - context: A dictionary of key-value pairs for the visitor's context

     - Throws: An error if the flag fetching operation fails

     - Important: This is an asynchronous operation that must be called with `await`
     */ public func updateContext(visitorId: String, hasConsented: Bool, context: [String: Any]) async throws
    {
        if visitorId != client.visitorId {
            // Rebuild the visitor with new values
            client = Flagship.sharedInstance.newVisitor(visitorId: visitorId, hasConsented: hasConsented).withContext(context: context).build()
        } else {
            client.updateContext(context)
        }

        // Fetch flags asynchronously
        try await withCheckedThrowingContinuation { continuation in
            client.fetchFlags {
                continuation.resume()
            }
        }
    }
}
