//
//  BaiduRequest.swift
//  AlamofireCodableDemo
//
//  Created by season on 2019/4/4.
//  Copyright © 2019 season. All rights reserved.
//

import Foundation
import AlamofireCoswift
import coswift
import CoreLocation

public class BaiduRequest {
    
    fileprivate let urlPath = "http://www.baidu.com"
    
    public static let shared = BaiduRequest()
    
    
    public func fetchWeatherData() throws -> String  {
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let location = CLLocation(latitude: 0, longitude: 0)
        guard var components = URLComponents(string:urlPath) else {
            throw NSError(domain: "BaiduRequest", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid URL."]) as Error
            
        }
        
        // get appId from Info.plist
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        components.queryItems = [URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:"796b6557f59a77fa02db756a30803b95")]
        // 这个网址很有意思,将url和参数封装成为一个get请求的形式,参数进行了拼接,原生请求可以参考这个
        let url = components.url
        
        var ret = ""
        
        
        let result = try await { session.dataTask(with: url!)}
        
        switch result {
        case .fulfilled(let (data, response)):
            
            if let data1 = data {
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("response: \(httpResponse)")
                }
                if let str = String(data: data1, encoding: String.Encoding.utf8) {
                    ret = str
                    print("responseString: \(str)")
                }
            }
            
        case .rejected(let error):
            
            print("error: \(error)")
        }
        
        return ret
    }
    
    
    
}

