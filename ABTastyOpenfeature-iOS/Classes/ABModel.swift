//
//  ABModel.swift
//  Pods
//
//  Created by Adel Ferguen on 04/08/2025.
//

import Foundation
import OpenFeature

extension Value {
    /// Convert `Value` → `Any?` (for JSON, Foundation, etc.)
    public var anyValue: Any? {
        switch self {
        case .boolean(let b): return b
        case .string(let s): return s
        case .integer(let i): return i
        case .double(let d): return d
        case .null: return nil
        case .list(let arr): return arr.compactMap { $0.anyValue }
        case .structure(let dict):
            // Recursively convert
            return dict.compactMapValues { $0.anyValue }
        case .date:
            return nil
        }
    }

    /// Initialize a `Value` from an `Any` (e.g. from JSON)
    init?(any: Any?) {
        switch any {
        case let b as Bool:
            self = .boolean(b)
        case let i as Int64:
            self = .integer(i)
        case let d as Double:
            self = .double(d)
        case let s as String:
            self = .string(s)
        case let arr as [Any]:
            let values = arr.compactMap { Value(any: $0) }
            guard values.count == arr.count else { return nil }
            self = .list(values)
        case let obj as [String: Any]:
            var vdict = [String: Value]()
            for (k, vAny) in obj {
                guard let v = Value(any: vAny) else { return nil }
                vdict[k] = v
            }
            self = .structure(vdict)
        case .none:
            self = .null
        default:
            return nil
        }
    }
}
