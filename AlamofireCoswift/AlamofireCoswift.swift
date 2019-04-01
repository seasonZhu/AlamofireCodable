//
//  AlamofireCoswift.swift
//  AlamofireCoswift
//
//  Created by season on 2019/3/20.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCodable
import coswift

extension DataRequest {
    
    /// 响应responseCoswift
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - responseSerializer: 可序列化的Response
    /// - Returns: Resolution
    /// - Throws: Error
    @discardableResult
    public func responseCoswift<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T) throws
        -> Resolution<T.SerializedObject>
    {
        
        func coswiftPromise() -> Promise<T.SerializedObject> {
            let promise = Promise<T.SerializedObject>()
            delegate.queue.addOperation {
                let result = responseSerializer.serializeResponse(
                    self.request,
                    self.response,
                    self.delegate.data,
                    self.delegate.error
                )
                
                let dataResponse = DataResponse<T.SerializedObject>(
                    request: self.request,
                    response: self.response,
                    data: self.delegate.data,
                    result: result,
                    timeline: Timeline()
                )
                
                (queue ?? DispatchQueue.main).async {
                    if let value = dataResponse.value {
                        promise.fulfill(value: value)
                    }else if let error = dataResponse.error {
                        promise.reject(error: error)
                    }
                }
            }
            
            return promise
        }
        
        return try await { coswiftPromise() }
    }
}

// MARK: - CoswiftCodable
extension DataRequest {
    
    /// 响应responseCoswiftCodable
    ///
    /// - Parameters:
    ///   - queue: 回调线程
    ///   - keyPath: 键值路径
    /// - Returns: Resolution
    /// - Throws: Error
    @discardableResult
    public func responseCoswiftCodable<T: Codable>(
        queue: DispatchQueue? = nil,
        keyPath: String? = nil) throws
        -> Resolution<T>
    {
        return try responseCoswift(
            queue: queue,
            responseSerializer: DataRequest.codableResponseSerializer(keyPath: keyPath)
        )
    }
}

extension Resolution {
    
    /// 获取成功结果
    public var value: T? {
        switch self {
        case .fulfilled(let value):
            return value
        case .rejected:
            return nil
        }
    }
    
    /// 获取Error
    public var error: Error? {
        switch self {
        case .fulfilled:
            return nil
        case .rejected(let error):
            return error
        }
    }
}
