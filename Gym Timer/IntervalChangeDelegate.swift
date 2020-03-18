//
//  IntervalChangeDelegate.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 18/03/20.
//  Copyright © 2020 prad. All rights reserved.
//

import Foundation

protocol IntervalChangeDelegate: AnyObject {
  func intervalChanged(min: Int, sec: Int)
}
