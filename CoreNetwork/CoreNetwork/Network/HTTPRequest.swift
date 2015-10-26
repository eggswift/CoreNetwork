//
//  HTTPRequest.swift
//  Copyright (c) 2015 Egg swift. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the “Software”), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

enum HTTPRequestType: NSInteger {
    case None
    case Example
}

public struct HTTPRequestParameters {
    var type: HTTPRequestType
    var parameters: [String: AnyObject]?
    
    init(requestType: HTTPRequestType) {
        type = requestType
    }
}


class HTTPRequest {
    private static let HTTPCacheTimeStampKey = "com.alamofire.cacheTimeStampKey"
    var requestParams: HTTPRequestParameters
    var dataProcess: HTTPDataProcess
    
    init (requestParams: HTTPRequestParameters) {
        self.requestParams = requestParams
        self.dataProcess = HTTPDataProcess(requestParams: requestParams)
    }
    
    func loadCacheData() -> AnyObject? {
        return self.dataProcess.loadCacheData()
    }
    
}

extension HTTPRequest {
    
    /// 根据业务处理接口参数，通过闭包返回
    var httpRequestParameters: (method: HTTPRequestManager.Method, urlString: String, params : [String : AnyObject]?) {
        return (method, URLString, parameters)
    }
    var method: HTTPRequestManager.Method {
        switch requestParams.type {
        case .Example:
            return HTTPRequestManager.Method.GET
        default:
            return HTTPRequestManager.Method.GET
        }
    }
    var URLString: String {
        switch requestParams.type {
        case .Example:
            return "http://httpbin.org/get"
        default:
            return ""
        }
    }
    var parameters: [String: AnyObject]? {
        return requestParams.parameters
    }
    
    
    /// 计算request id，用来标示当前request类型
    var cacheIdentifier: String? {
        switch requestParams.type {
        case .Example:
            return "http://httpbin.org/get"
        default:
            return nil
        }
    }
    /// 读取缓存到期时间，更新缓存到期时间
    var cacheOverdueTimeInterval: NSTimeInterval? {
        get {
            guard cacheIdentifier != nil else {
                return nil;
            }
            
            if let dic = NSUserDefaults.standardUserDefaults().objectForKey(HTTPRequest.HTTPCacheTimeStampKey), timestamp = dic[cacheIdentifier!] as? NSNumber {
                return timestamp.doubleValue
            }
            return nil
        }
        set {
            guard cacheIdentifier != nil else {
                return
            }
            guard newValue != nil else {
                return
            }
            var dic = NSUserDefaults.standardUserDefaults().dictionaryForKey(HTTPRequest.HTTPCacheTimeStampKey)
            if dic == nil {
                dic = [String: NSNumber]()
            }
            dic![cacheIdentifier!] = NSNumber(double: newValue!)
            NSUserDefaults.standardUserDefaults().setObject(dic, forKey: HTTPRequest.HTTPCacheTimeStampKey)
        }
    }
}




