//
//  main.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 26/03/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import UIKit

CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
{    argv in
    _ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(TimerApplication.self), NSStringFromClass(AppDelegate.self))
}
