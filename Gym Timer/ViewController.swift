//
//  ViewController.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 17/11/19.
//  Copyright © 2019 prad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var timer = Timer()

  var isWorkInterval = true
  var isStarted = true
  
  var workIntervalInSeconds = 45
  var restIntervalInSeconds = 15
  @IBOutlet weak var timerLabel: UILabel!
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func startTimerAction(_ sender: Any) {
    runTimer()
  }
  
  func runTimer() {
    statusLabel.text = isWorkInterval ? "Working" : "Resting"
    timer = Timer.scheduledTimer(timeInterval: 1 , target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
  }
  
  @objc func updateTimer() {
    let seconds : Int
    if isWorkInterval {
      workIntervalInSeconds -= 1
      seconds = workIntervalInSeconds
    } else {
      restIntervalInSeconds -= 1
      seconds = restIntervalInSeconds
    }
    if seconds < 2 {
      toggleTimer()
    }
    timerLabel.text = "\(seconds)"
    
  }
  func toggleTimer() {
    timer.invalidate()
    isWorkInterval = !isWorkInterval
    workIntervalInSeconds = 45 + 1
    restIntervalInSeconds = 15 + 1
    runTimer()
  }
  
  
}

