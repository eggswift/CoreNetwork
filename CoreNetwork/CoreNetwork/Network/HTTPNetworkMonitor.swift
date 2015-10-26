//
//  HTTPNetworkMonitor.swift
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

class HTTPNetworkMonitor {
    static let sharedManager = HTTPNetworkMonitor()
    
    let reachability: Reachability!
    var status: Reachability.NetworkStatus! {
        return reachability.currentReachabilityStatus
    }
    var description: String {
        return reachability.currentReachabilityString
    }
    
    init() {
        do {
            try reachability = Reachability.init(hostname: "www.baidu.com")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
        } catch {
            reachability = nil
        }
    }
    
    // 启动网络监听
    func startMonitoring() {
        do {
            try reachability.startNotifier()
        } catch {
            print("reachability开启失败")
        }
    }
    
    // 停止网络监听
    func stopMonitoring() {
        reachability.stopNotifier()
    }
    //网络状态发生改变
    func reachabilityChanged(note: NSNotification) {
        print(reachability.currentReachabilityString)
    }
    
    deinit {
        reachability.stopNotifier()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ReachabilityChangedNotification, object: nil)
    }
    
}
