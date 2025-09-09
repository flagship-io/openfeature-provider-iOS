@testable import FlagShip
import OpenFeature
@testable import ABTastyOpenfeature_iOS
import XCTest

class ABTastyProviderTests: XCTestCase {
    var sut: ABTastyProvider!
    let envId = "test-env-id"
    let apiKey = "test-api-key"
    
    override func setUp() {
        super.setUp()
        let config = FSConfigBuilder()
            .withTimeout(60)
            .build()
        sut = ABTastyProvider(envId: envId, apiKey: apiKey, configurator: config)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testProviderInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.metadata.name, "FlagshipProvider")
    }
    
    func testInitializeWithContext() async throws {
        // Given
        let context = MutableContext(
            targetingKey: "test-visitor",
            structure: MutableStructure(attributes: [
                "isQA": Value.boolean(true),
                "hasConsented": Value.boolean(true),
                "city": Value.string("Paris")
            ])
        )
        
        // When
        try await sut.initialize(initialContext: context)
        
        // Then - verify we can get flag evaluations
        let evaluation = try  sut.getBooleanEvaluation(key: "testKey", defaultValue: false, context: nil)
        XCTAssertNotNil(evaluation)
    }
    
    func testContextUpdate() async throws {
        // Given
        let initialContext = MutableContext(
            targetingKey: "test-visitor",
            structure: MutableStructure(attributes: [
                "isQA": Value.boolean(true)
            ])
        )
        
        let newContext = MutableContext(
            targetingKey: "test-visitor",
            structure: MutableStructure(attributes: [
                "isQA": Value.boolean(false)
            ])
        )
        
        // When
        try await sut.initialize(initialContext: initialContext)
        try await sut.onContextSet(oldContext: initialContext, newContext: newContext)
        
        // Then - verify we can still evaluate flags after context update
        let evaluation = try  sut.getBooleanEvaluation(key: "testKey", defaultValue: false, context: newContext)
        XCTAssertNotNil(evaluation)
    }
    
    func testGetBooleanEvaluation() async throws {
        // Given
        let context = MutableContext(targetingKey: "test-visitor")
        let expectedDefaultValue = false
        
        // When
        try await sut.initialize(initialContext: context)
        let evaluation = try  sut.getBooleanEvaluation(key: "testKey", defaultValue: expectedDefaultValue, context: nil)
        
        // Then
        XCTAssertNotNil(evaluation)
        XCTAssertEqual(evaluation.value, expectedDefaultValue, "Boolean evaluation should return default value when flag doesn't exist")
        XCTAssertEqual(evaluation.reason, nil)
    }
    
    func testGetStringEvaluation() async throws {
        // Given
        let context = MutableContext(targetingKey: "test-visitor")
        let expectedDefaultValue = "default"
        
        // When
        try await sut.initialize(initialContext: context)
        let evaluation = try  sut.getStringEvaluation(key: "testKey", defaultValue: expectedDefaultValue, context: nil)
        
        // Then
        XCTAssertNotNil(evaluation)
        XCTAssertEqual(evaluation.value, expectedDefaultValue, "String evaluation should return default value when flag doesn't exist")
        XCTAssertEqual(evaluation.reason, nil)
    }
    
    func testGetIntegerEvaluation() async throws {
        // Given
        let context = MutableContext(targetingKey: "test-visitor")
        let expectedDefaultValue = Int64(42)
        
        // When
        try await sut.initialize(initialContext: context)
        let evaluation = try  sut.getIntegerEvaluation(key: "testKey", defaultValue: Int64(expectedDefaultValue), context: nil)
        
        // Then
        XCTAssertNotNil(evaluation)
        XCTAssertEqual(evaluation.value, expectedDefaultValue, "Integer evaluation should return default value when flag doesn't exist")
        XCTAssertEqual(evaluation.reason, nil)
    }
    
    func testGetDoubleEvaluation() async throws {
        // Given
        let context = MutableContext(targetingKey: "test-visitor")
        let expectedDefaultValue = 3.14
        
        // When
        try await sut.initialize(initialContext: context)
        let evaluation = try await sut.getDoubleEvaluation(key: "testKey", defaultValue: expectedDefaultValue, context: nil)
        
        // Then
        XCTAssertNotNil(evaluation)
        XCTAssertEqual(evaluation.value, expectedDefaultValue, "Double evaluation should return default value when flag doesn't exist")
        XCTAssertEqual(evaluation.reason, nil)
    }
    
    func testGetObjectEvaluation() async throws {
        // Given
        let context = MutableContext(targetingKey: "test-visitor")
        let expectedDefaultValue = Value.string("default")
        
        // When
        try await sut.initialize(initialContext: context)
        let evaluation = try  sut.getObjectEvaluation(key: "testKey", defaultValue: expectedDefaultValue, context: nil)
        
        // Then
        XCTAssertNotNil(evaluation)
        XCTAssertEqual(evaluation.value, expectedDefaultValue, "Object evaluation should return default value when flag doesn't exist")
        XCTAssertEqual(evaluation.reason, nil)
    }
    
    func testInitializeWithNilContext() async throws {
        // When
        try await sut.initialize(initialContext: nil)
        
        // Then
        let evaluation = try  sut.getBooleanEvaluation(key: "testKey", defaultValue: false, context: nil)
        XCTAssertNotNil(evaluation)
    }
    
    func testContextUpdateWithEmptyContext() async throws {
        // Given
        let emptyContext = MutableContext(targetingKey: "test-visitor")
        
        // When
        try await sut.onContextSet(oldContext: nil, newContext: emptyContext)
        
        // Then
        let evaluation = try  sut.getBooleanEvaluation(key: "testKey", defaultValue: false, context: emptyContext)
        XCTAssertNotNil(evaluation)
    }
}
