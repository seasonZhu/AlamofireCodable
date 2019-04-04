//
//  URLSession+coswift.swift
//  AlamofireCoswift
//
//  Created by season on 2019/4/4.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation
import coswift

extension URLSession {
    
    /// 封装了coswift的基本网络请求
    ///
    /// - Parameter url: 网址
    /// - Returns: Promise<T> 配合await 获取Resolution<T>解答
    public func dataTask(with url: URL) -> Promise<(Data?, URLResponse?)> {
        
        /// 这里的泛型T是一个元组类型(Data?, URLResponse?)
        let promise = Promise<(Data?, URLResponse?)>()
        
        let task = self.dataTask(with: url) { (data, response, error) in
            
            if let e = error {
                promise.reject(error: e)
            } else {
                promise.fulfill(value: (data, response))
            }
        }
        
        promise.onCancel { [weak task] (pro) in
            task?.cancel()
        }
        task.resume()
        return promise
    }
}
