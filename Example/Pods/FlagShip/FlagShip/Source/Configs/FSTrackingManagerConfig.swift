//
//  FSTrackingConfig.swift
//  Flagship
//
//  Created by Adel Ferguen on 24/03/2023.
//  Copyright © 2023 FlagShip. All rights reserved.
//

import Foundation

// Default value for Pool Size Max
public var POOL_SIZE_MAX: Int = 10

// Batch Interval Time
public var BATCH_INTERVAL_TIME: Double = 5

public enum FSCacheStrategy: Int {
    // This strategy will use the pool to batch events at regular intervals.
    // Each time a hit is added or removed from the pool, it will be replicated to the database
    // through the hit cache interface from the cache manager.
    case CONTINUOUS_CACHING = 0

    // This strategy will use the pool to batch events at regular intervals.
    // Each time a batch has been sent the pool must be saved to the the database
    // through the hit cache interface from the cache manager in order to prevent data loss.
    case PERIODIC_CACHING

    // This strategy will not send batch events except when the hits are loaded from the database.
    // It works like the previous version of the SDK. Api requests are made each time a hits has been emitted by a visitor instance.
    case NO_CACHING_STRATEGY

    var name: String {
        switch self { case .CONTINUOUS_CACHING:
            return "CONTINUOUS_CACHING"
        case .PERIODIC_CACHING:
            return "PERIODIC_CACHING"
        case .NO_CACHING_STRATEGY:
            return "NO_CACHING_STRATEGY"
        }
    }
}

public class FSTrackingManagerConfig: NSObject {
    // Pool Size Maximum
    var poolMaxSize: Int

    // Interval Batch Time
    var batchIntervalTimer: Double

    // Strategy
    var strategy: FSCacheStrategy

    public init(poolMaxSize: Int = POOL_SIZE_MAX, batchIntervalTimer: Double = BATCH_INTERVAL_TIME, strategy: FSCacheStrategy = .CONTINUOUS_CACHING) {
        self.poolMaxSize = poolMaxSize
        self.batchIntervalTimer = batchIntervalTimer
        self.strategy = strategy
    }
}
