# AlamofireCodable
通过Alamofire请求数据,将数据一步到位转为基于遵守Codable协议的模型!
## 不吃药不打针,不使用其他任何JSON转模型框架,使用原生的Codable协议进行JSON转模型!
例如有下面这样的JSON:

```
{
  "code": 0,
  "list": [
    {
      "topicDesc": "错过线下行前说明会？这里有一份超完整的澳洲行前攻略给你。",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180608\\/18626cd2106344078969afd77acf3572.jpg",
      "id": 12,
      "topicStatus": 1,
      "upTime": "2018-06-13 14:46:06",
      "topicOrder": 21,
      "topicTittle": "澳洲行前"
    },
    {
      "topicDesc": "错过线下行前说明会？这里有一份超完整的英国行前攻略给你。",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180608\\/d27a7923a24d4cd6878fe08fa338be45.jpg",
      "id": 10,
      "topicStatus": 1,
      "upTime": "2018-06-13 14:46:17",
      "topicOrder": 20,
      "topicTittle": "英国行前"
    },
    {
      "topicDesc": "每月准时更新！留学时区为你搜集6月份留学活动资讯，想参加活动就来吧~",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180613\\/ad2983334ede4b18a0ac39e2af2df7de.jpg",
      "id": 13,
      "topicStatus": 1,
      "upTime": "2018-06-13 14:46:34",
      "topicOrder": 19,
      "topicTittle": "活动推荐"
    },
    {
      "topicDesc": "英国留学 - 5分钟语音微讲座",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180507\\/de7598df27a048949d7108f084156f2e.jpg",
      "id": 8,
      "topicStatus": 1,
      "upTime": "2018-05-29 15:42:44",
      "topicOrder": 17,
      "topicTittle": "英国语音"
    },
    {
      "topicDesc": "美国留学 - 5分钟语音微讲座",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180507\\/c052c8d666d54533aa823cf7991f83b6.jpg",
      "id": 7,
      "topicStatus": 1,
      "upTime": "2018-05-29 15:42:37",
      "topicOrder": 16,
      "topicTittle": "美国语音"
    },
    {
      "topicDesc": "澳大利亚留学 - 5分钟语音微讲座",
      "createTime": null,
      "topicImageUrl": "http:\\/\\/cdn.timez1.com\\/20180507\\/67189c3eb55b4ead98952c66722a0515.jpg",
      "id": 6,
      "topicStatus": 1,
      "upTime": "2018-06-25 10:48:41",
      "topicOrder": 15,
      "topicTittle": "澳洲语音"
    }
  ]
}
```

可以通过一些网站获取其模型,我们让每一个自定义的模型遵守Coable协议,如下:

```
struct Item: Codable {
    var topicOrder: Int?
    var id: Int?
    var topicDesc: String?
    var topicTittle: String?
    var upTime: String?
    var topicImageUrl: String?
    var topicStatus: Int?
}

struct Topics: Codable {
    var list: [Item]?
    var code: Int?
}
```

我们就可以通过Alamofire和我写一个分类方法responseCodable获取其模型了:

```
// 获取整个模型
Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCodable { (response: DataResponse<Topics>) in
	guard let value = response.value else { return }
  	print(value)
}
```

当然我们也可以通过其keyPath获取其更底层的模型:

```
// keyPath目标的请求Model
Alamofire.request("http://sun.topray-media.cn/tz_inf/api/topics", method: .post).responseCodable(queue: nil, keyPath: "list") { (response: DataResponse<[Item]>) in
	guard let list = response.value else { return }
	print(list)
}
```
## AlamofireCodable的优势
1.	完全使用系统协议,不依赖于其他JSON转模型的框架,**就算不使用Alamofire,可以使用原生的请求一步到位获取模型**.
2. 不用区分响应的是Object或者是[Object],上面的例子已经可以看出.
3. keyPath获取深层次的keyPath下的模型,**可以在requestModel2的方法中看具体实现**,而ObjectMapper只能获取一层下面的模型.
4. 定义的模型简单,模型类或者结构体只需要遵守Codable协议即可.
5. 涉及模型中定义自定义数据的,可以在**Demo中Model2**进行详细了解,这里只说重点,实现Decodable协议的具体方法!

## pod使用注意
目前仅推到我自己的[私有库](https://github.com/seasonZhu/AlamofireCodable),具体如何使用,可以参看该页面的使用说明.
至于原因,是有位大哥已经使用了AlamofireCodable在Cocoapods占了坑,那位大哥的写法借鉴了AlamofireObjectMapper.我没有办法推到Cocoapods上面去.

## 文章参考
[Encoding and Decoding Custom Types ](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types)

[Using JSON with Custom Types ](https://developer.apple.com/documentation/foundation/archives_and_serialization/using_json_with_custom_types)

## Demo地址
[AlamofireCodable](https://github.com/seasonZhu/AlamofireCodable)

