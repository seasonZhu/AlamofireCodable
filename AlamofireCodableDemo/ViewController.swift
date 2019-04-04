//
//  ViewController.swift
//  AlamofireCodableDemo
//
//  Created by season on 2019/2/25.
//  Copyright © 2019 season. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireCodable
import coswift
import AlamofireCoswift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        // 将不知道到底谁先回调的情况变为可以控制的顺序执行 有的时候 这个代价还是值得
        co_launch {
            
            // 昨天我在外面进行了封装
            let items = try TopicsRequest<[Item]>.getModel(keyPath: "list")
            print("-------------------------------------------------------")
            print("1:\n\(items.result)")
            print("-------------------------------------------------------")
            let topics = try TopicsRequest<Topics>.getModel()
            print("2:\n\(topics.result)")
            
            //  今天我在Alamofire的内部进行了封装
            let u17RootResolution: Resolution<U17Root> = try Alamofire.request("http://app.u17.com/v3/appV3_3/ios/phone/comic/boutiqueListNew", method: .post).responseCoswiftCodable()
            print("-------------------------------------------------------")
            print("3:\n\(u17RootResolution.value)")
            print("-------------------------------------------------------")
            let topicsResolution: Resolution<Topics> = try Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCoswiftCodable()
            print("4:\n\(topicsResolution.value)")
            
            let _ = try? BaiduRequest.shared.fetchWeatherData()
        }
    }

    private func setUpUI() {
        let requestModel1Button = UIButton(frame: CGRect(x:  0, y: 88, width: view.bounds.width, height: 44))
        requestModel1Button.setTitle("请求Model1", for: .normal)
        requestModel1Button.backgroundColor = UIColor.lightGray
        requestModel1Button.addTarget(self, action: #selector(requestModel1), for: .touchUpInside)
        view.addSubview(requestModel1Button)
        
        let requestModel2Button = UIButton(frame: CGRect(x:  0, y: 176, width: view.bounds.width, height: 44))
        requestModel2Button.setTitle("请求Model2", for: .normal)
        requestModel2Button.backgroundColor = UIColor.lightGray
        requestModel2Button.addTarget(self, action: #selector(requestModel2), for: .touchUpInside)
        view.addSubview(requestModel2Button)
    }
    
    @objc
    func requestModel1() {
        // 顶层的请求Model
        Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCodable { (response: DataResponse<Topics>) in
            guard let value = response.value else { return }
            print(value)
        }
        // keyPath目标的请求Model
        Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCodable(queue: nil, keyPath: "list") { (response: DataResponse<[Item]>) in
            guard let list = response.value else { return }
            print(list)
        }
    }
    
    @objc
    func requestModel2() {
        // 顶层的请求Model
        Alamofire.request("http://app.u17.com/v3/appV3_3/ios/phone/comic/boutiqueListNew", method: .post).responseCodable { (response: DataResponse<U17Root>) in
            guard let u17Root = response.value else { return }
            print(u17Root)
        }
        // keyPath目标的请求Model 可以进行深层的keyPath 使用/分割开即可
        Alamofire.request("http://app.u17.com/v3/appV3_3/ios/phone/comic/boutiqueListNew", method: .post).responseCodable(keyPath: "data/returnData/comicLists") { (response: DataResponse<[ComicList]>) in
            guard let comicLists = response.value else { return }
            print(comicLists)
        }
    }
}

/// 基于coswift的Promise,写了这么一大堆,为的就是避免回调
class TopicsRequest<T: Codable> {
    static func useCoswift(keyPath: String? = nil) -> Promise<T> {
        let promise = Promise<T>()
        
        Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCodable(queue: nil, keyPath: keyPath) { (response: DataResponse<T>) in
            if let value = response.value {
                promise.fulfill(value: value)
            }else if let error = response.error {
                promise.reject(error: error)
            }
        }
        
        return promise
    }
    
    static func getModel(keyPath: String? = nil) throws -> (result: T?, error: Error?) {
        let result = try await { useCoswift(keyPath: keyPath) }
        
        switch result {
        case .fulfilled(let items):
            return (items, nil)
        case .rejected(let error):
            return (nil, error)
        }
    }
}
