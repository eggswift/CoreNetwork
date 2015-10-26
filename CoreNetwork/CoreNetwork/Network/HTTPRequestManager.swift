//  HTTPRequestManager.swift
//
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
import Alamofire
import SwiftyJSON

public enum HTTPRequestError: ErrorType {
    case None
    case SystemError(error: NSError?)
    case NetworkError
    case BusinessError(description: String)
}

public typealias HTTPRequestHandler = (responseObject: AnyObject?, error: HTTPRequestError?) -> Void
public typealias HTTPRequestJSONHandler = (responseObject: JSON?, error: HTTPRequestError?) -> Void

public class HTTPRequestManager {
    public enum Method : String {
        case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
        var alamofireMethod: Alamofire.Method {
            var results = Alamofire.Method.GET
            switch self {
            case .GET:
                results = Alamofire.Method.GET
            case .POST:
                results = Alamofire.Method.POST
            case .HEAD:
                results = Alamofire.Method.HEAD
            case .OPTIONS:
                results = Alamofire.Method.OPTIONS
            case .PUT:
                results = Alamofire.Method.PUT
            case .PATCH:
                results = Alamofire.Method.POST
            case .DELETE:
                results = Alamofire.Method.DELETE
            case .TRACE:
                results = Alamofire.Method.TRACE
            case .CONNECT:
                results = Alamofire.Method.CONNECT
            }
            return results
        }
    }
    
    
    /**
    data请求
    
    - parameter m:                  方法类型
    - parameter url:                URL
    - parameter param:              参数
    - parameter complectionHandler: 回调
    
    - returns: 当前request
    */
    public func dataRequest(method m: Method, urlString url: URLStringConvertible, parameter param: [String : AnyObject]?, complectionHandler: HTTPRequestHandler?) -> Request{
        
        /*
        public func request(method: Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .URL, headers: [String: String]? = nil) -> Request
        */
        let req = Alamofire.request(m.alamofireMethod, url, parameters: param, encoding: .URL, headers: nil)
        req.responseJSON { (resp) -> Void in
            if resp.result.isSuccess {
                if let handler = complectionHandler {
                    handler(responseObject: resp.result.value, error: nil)
                }
            } else {
                if let handler = complectionHandler {
                    handler(responseObject: nil, error: HTTPRequestError.SystemError(error: resp.result.error))
                }
            }
        }
        
        return req
    }
    
    
    /**
    上传任务
    
    - parameter data:             上传的数据
    - parameter urlStr:           URL
    - parameter completionHandle: 回调
    */
    public func uploadRequest(data: NSData, urlStr: URLStringConvertible, completionHandler: HTTPRequestHandler?){
        
        
        
    }
    
}

extension HTTPRequestManager {
    
    public func dataRequest(requestParams param: HTTPRequestParameters, completionHandler: HTTPRequestHandler?) {
        let req = HTTPRequest(requestParams: param)
        let now = NSDate().timeIntervalSince1970
        
        //已经设置了缓存
        if let _ = req.cacheIdentifier {
            //是否过期
            if let t = req.cacheOverdueTimeInterval where now - t < 0 {
                if let handler = completionHandler, data = req.loadCacheData(){
                    //存在缓存并没有过期,返回缓存中的数据
                    handler(responseObject: data, error: nil)
                }
                return
            }
        }
        
        //开始请求数据
        dataRequest(method: req.method, urlString: req.URLString, parameter: req.parameters) { (responseObject, error) -> Void in
            if error == nil {
                // 成功后，根据业务解析数据
                
                //缓存
                req.dataProcess.saveData(responseObject!)
                req.cacheOverdueTimeInterval = now
                if let handler = completionHandler {
                    handler(responseObject: req.loadCacheData(), error: nil)
                }
            }else {
                //失败情况
                if let handler = completionHandler {
                    handler(responseObject: nil, error: error)
                }
            }
        }
    }
}

