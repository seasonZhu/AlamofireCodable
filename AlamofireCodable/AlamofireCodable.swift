//
//  AlamofireCodable.swift
//  AlamofireCodable
//
//  Created by season on 2019/2/25.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - Codable

extension Request {
    /// 返回遵守Codable协议的Result类型
    ///
    /// - Parameters:
    ///   - response: 服务器返回的响应
    ///   - data: 服务器返回的数据
    ///   - error: AFError
    ///   - keyPath: 模型的keyPath 可解析深层的JSON数据
    /// - Returns: Result<T>
    public static func serializeResponseCodable<T: Codable>(response: HTTPURLResponse?, data: Data?, error: Error?, keyPath: String?) -> Result<T> {
        if let error = error { return .failure(error) }
        
        if let response = response, emptyDataStatusCodes.contains(response.statusCode) {
            do {
                let value = try JSONDecoder().decode(T.self, from: Data())
                return .success(value)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
        
        guard let validData = data else {
            return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
        }
        
        if let keyPath = keyPath, !keyPath.isEmpty {
            var keyPaths = keyPath.components(separatedBy: "/")
            return keyPathForCodable(keyPaths: &keyPaths, data: validData)

        }else {
            do {
                let value = try JSONDecoder().decode(T.self, from: validData)
                return .success(value)
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
    }
    
    /// 通过键值路径寻找深层的JSON对应的模型
    ///
    /// - Parameters:
    ///   - keyPaths: 路径数组
    ///   - data: 数据
    /// - Returns: Result<T>
    private static func keyPathForCodable<T: Codable>(keyPaths: inout [String], data: Data)  -> Result<T> {
        if let firstKeyPath = keyPaths.first, keyPaths.count > 1 {
            keyPaths.remove(at: 0)
            if let JSONObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let keyPathJSONObject = (JSONObject as AnyObject?)?.value(forKeyPath: firstKeyPath),
                let keyPathData = try? JSONSerialization.data(withJSONObject: keyPathJSONObject) {
                return keyPathForCodable(keyPaths: &keyPaths, data: keyPathData)
            }
        }else if let lastKeyPath = keyPaths.last, keyPaths.count == 1  {
            keyPaths.remove(at: 0)
            if let JSONObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let keyPathJSONObject = (JSONObject as AnyObject?)?.value(forKeyPath: lastKeyPath),
                let keyPathData = try? JSONSerialization.data(withJSONObject: keyPathJSONObject) {
                do {
                    let value = try JSONDecoder().decode(T.self, from: keyPathData)
                    return .success(value)
                } catch {
                    return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
                }
            }
        }
        
        return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
    }
}

extension DataRequest {
    /// 创建一个遵守Codable协议的response serializer
    ///
    /// - Parameter keyPath: 键值路径
    /// - Returns: 遵守Codable协议的response serializer
    public static func codableResponseSerializer<T: Codable>(keyPath: String?) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            return Request.serializeResponseCodable(response: response, data: data, error: error, keyPath: keyPath)
        }
    }
    
    /// 添加一个请求完成的handle
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - keyPath: 键值路径
    ///   - completionHandler: handle
    /// - Returns: DataRequest
    @discardableResult
    public func responseCodable<T: Codable>(
        queue: DispatchQueue? = nil,
        keyPath: String? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void)
        -> Self
    {
        return response(
            queue: queue,
            responseSerializer: DataRequest.codableResponseSerializer(keyPath: keyPath),
            completionHandler: completionHandler
        )
    }
}

private let emptyDataStatusCodes: Set<Int> = [204, 205]
