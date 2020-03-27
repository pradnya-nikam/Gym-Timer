//
//  TimerLabel.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 26/03/20.
//  Copyright © 2020 prad. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {

  func convertSecondsToTimeFormatAndSetText(intervalInSeconds: Int) {
    self.text = convertSecondsToTimeFormat(intervalInSeconds: intervalInSeconds)
  }
  
  private func convertSecondsToTimeFormat(intervalInSeconds: Int) -> String {
    var convertedString = ""
    let oneHourInSec = 60*60
    let oneMinInSec = 60
    var interval = intervalInSeconds
    let hours: Int
    var mins = 0
    var sec = 0
    if interval > oneHourInSec {
      hours = interval/oneHourInSec
      interval = interval - hours*oneHourInSec
      convertedString.append("\(hours) : ")
    }
    if interval > oneMinInSec {
      mins = interval/oneMinInSec
      interval = interval - mins*oneMinInSec
    }
//    convertedString.append(String(format:"%02d : ", mins))
    if interval > 1 {
      sec = interval
    }
    convertedString.append(String(format:"%02d : %02d", mins, sec))
    return convertedString
  }
}
