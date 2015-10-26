//
//  ViewController.swift
//  CoreNetwork
//
//  Created by lihao on 15/10/26.
//  Copyright © 2015年 Egg Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let manager = HTTPRequestManager()
        manager.dataRequest(method: HTTPRequestManager.Method.GET, urlString: "http://httpbin.org/get", parameter: ["foo": "bar"]) { (responseObject, error) -> Void in
            print(responseObject)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

