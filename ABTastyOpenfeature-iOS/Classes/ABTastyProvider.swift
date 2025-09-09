
#if canImport(Flagship)
import Flagship
#elseif canImport(FlagShip)
import FlagShip
#else
#error("Flagship framework not found")
#endif

import Combine
import OpenFeature

/// Describes the ConfigCat OpenFeature metadata.
public struct ABTastyMetadata: ProviderMetadata {
    public var name: String? = "FlagshipProvider"
}

public class ABTastyProvider: FeatureProvider {
    public var metadata: any OpenFeature.ProviderMetadata = ABTastyMetadata()
    public var hooks: [any OpenFeature.Hook] = []
    private let eventHandler = EventHandler()
    var fsClient: FSVisitor?

    private var abClient: ABTastyClient?

    public init(
        envId: String,
        apiKey: String,
        configurator: FlagshipConfig
    ) {
        Flagship.sharedInstance.start(envId: envId, apiKey: apiKey, config: configurator)
    }

    public func initialize(initialContext: (any OpenFeature.EvaluationContext)?) async throws {
        var fsContext: [String: Any] = [:]

        // Adapt context
        if let aInitialContext = initialContext {
            let context = aInitialContext.asMap()
            context.forEach { key, openValue in
                // Retreieve the value of the context
                if let aOpenValue = openValue.anyValue {
                    fsContext.merge([key: aOpenValue]) { _, new in new }
                }
            }
        }
        // Retreive the consent information from evaluation context in OF
        let hasConsented = fsContext["hasConsented"] as? Bool ?? false
        abClient = try await ABTastyClient(visitorId: initialContext?.getTargetingKey() ?? "", hasConsented: hasConsented, context: fsContext)
    }

    public func onContextSet(oldContext: (any OpenFeature.EvaluationContext)?, newContext: any OpenFeature.EvaluationContext) async throws {
        var fsContext: [String: Any] = [:]
        let context = newContext.asMap()
        context.forEach { key, openValue in
            if let aOpenValue = openValue.anyValue {
                fsContext.merge([key: aOpenValue]) { _, new in new }
            }
        }
        let hasConsented = fsContext["hasConsented"] as? Bool ?? false
        let visitorId = newContext.getTargetingKey()
        try await abClient?.updateContext(visitorId: visitorId, hasConsented: hasConsented, context: fsContext)
    }

    public func getBooleanEvaluation(key: String, defaultValue: Bool, context: (any OpenFeature.EvaluationContext)?) throws -> OpenFeature.ProviderEvaluation<Bool> {
        return abClient?.getFlagEvaluation(flagKey: key, defaultValue: defaultValue) ?? ProviderEvaluation(value: defaultValue)
    }

    public func getStringEvaluation(key: String, defaultValue: String, context: (any OpenFeature.EvaluationContext)?) throws -> OpenFeature.ProviderEvaluation<String> {
        return abClient?.getFlagEvaluation(flagKey: key, defaultValue: defaultValue) ?? ProviderEvaluation(value: defaultValue)
    }

    public func getIntegerEvaluation(key: String, defaultValue: Int64, context: (any OpenFeature.EvaluationContext)?) throws -> OpenFeature.ProviderEvaluation<Int64> {
        return abClient?.getFlagEvaluation(flagKey: key, defaultValue: defaultValue) ?? ProviderEvaluation(value: defaultValue)
    }

    public func getDoubleEvaluation(key: String, defaultValue: Double, context: (any OpenFeature.EvaluationContext)?) throws -> OpenFeature.ProviderEvaluation<Double> {
        return abClient?.getFlagEvaluation(flagKey: key, defaultValue: defaultValue) ?? ProviderEvaluation(value: defaultValue)
    }

    public func getObjectEvaluation(key: String, defaultValue: OpenFeature.Value, context: (any OpenFeature.EvaluationContext)?) throws -> OpenFeature.ProviderEvaluation<OpenFeature.Value> {
        return ProviderEvaluation(
            value: defaultValue)
    }

    public func observe() -> AnyPublisher<OpenFeature.ProviderEvent?, Never> {
        return eventHandler.observe()
    }
}
