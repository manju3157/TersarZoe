//
//  Global.swift
//  TersarZoe
//
//  Created by Manjunath Ramesh on 24/12/20.
//

import Foundation

class Global {
    static func delay(_ delay: Double, closure:@escaping () -> Void) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }

    typealias SimpleCallBack = () -> Void

    static func background(_ task:@escaping SimpleCallBack, main: SimpleCallBack? = nil ) {
        DispatchQueue.global().async {
            task()
            if let main = main {
                DispatchQueue.main.async(execute: main)
            }
        }
    }

    static func background(_ task:@escaping SimpleCallBack ) {
        background(task, main: nil)
    }
}
