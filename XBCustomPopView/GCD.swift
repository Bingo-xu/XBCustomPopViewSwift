//
//  GCD.swift
//  JNB Air Cleaner 2.0
//
//  Created by lol on 16/7/7.
//  Copyright © 2016年 Shenzhen WEL Technology Co., Ltd. All rights reserved.
//

import Foundation
typealias funcIntVoidBlock = (Int) -> () //或者 () -> Void

 class GCD: NSObject {
    
     class func mainQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
     class func globalQueue() -> DispatchQueue {
        return DispatchQueue.global()
//        return DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default)
    }
    
     class func asyncMainQueue(_ block: @escaping ()->()) {
        mainQueue().async(execute: block)
    }
    
     class func asyncGlobalQueue(_ block: @escaping ()->()) {
        globalQueue().async(execute: block)
    }
    
     class func afterMainQueue(_ time: Double, block: @escaping ()->()) {
        let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        mainQueue().asyncAfter(deadline: delay, execute: block)
    }
    
     class func afterGlobalQueue(_ time: Double, block: @escaping ()->()) {
        let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        globalQueue().asyncAfter(deadline: delay, execute: block)
    }
    
     class func cancleMethodWith(block: @escaping ()->()) {
        
    }
    
    /**多任务完成后再执行下一任务**/
     class func groupMainQueueDask(_ groupDaskBlock:@escaping funcVoidVoidBlock,
                                           doneBlock: funcVoidVoidBlock?)  {
        let group = DispatchGroup()
        GCD.asyncMainQueue(groupDaskBlock)
//       _ = group.wait(timeout: .distantFuture)//可以设置超时时间，到了时间没有完成也会返回
//        doneBlock()
        if doneBlock != nil {
            group.notify(queue: GCD.mainQueue(), execute: doneBlock!) //所有任务完成才会执行下一步
        }
    }
    
    /**多任务完成后再执行下一任务**/
     class func groupGlobalQueueDask(_ groupDaskBlock:@escaping funcVoidVoidBlock,
                                    doneBlock: funcVoidVoidBlock?)  {
        let group = DispatchGroup()
        GCD.asyncGlobalQueue(groupDaskBlock)
        //       _ = group.wait(timeout: .distantFuture)//可以设置超时时间，到了时间没有完成也会返回
        //        doneBlock()
        if doneBlock != nil {
            group.notify(queue: GCD.mainQueue(), execute: doneBlock!) //所有任务完成才会执行下一步
        }
    }
    
    /**
     大量任务并发for循环放到一个线程中处理是很慢的，GCD提供两个函数dispatch_apply和dispatch_apply_f,
     dispatch_apply用于block，dispatch_apply_f用于c函数，它们可以替代可并发的for循环，来并行的运行而提高执行效率。
     **/
     class func moreGlobalQueueApplyWith(count:Int,doneBlock: @escaping funcIntVoidBlock)  {
        DispatchQueue.concurrentPerform(iterations: count, execute: doneBlock)
    }
    
}

extension DispatchQueue {
    private static var onceTracker = [String]()
    
    open class func once(token: String, block:() -> Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if onceTracker.contains(token) {
            return
        }
        
        onceTracker.append(token)
        block()
    }
}
