//
//  ViewController.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 17/11/19.
//  Copyright © 2019 prad. All rights reserved.
//

import UIKit


let DEFAULT_WORK_INTERVAL = 45
let DEFAULT_REST_INTERVAL = 15

class ViewController: UIViewController {

  var timer = Timer()

  //User defined values
  var workIntervalInSeconds = DEFAULT_WORK_INTERVAL
  var restIntervalInSeconds = DEFAULT_REST_INTERVAL
  
  //Counters
  var workIntervalCounter = DEFAULT_WORK_INTERVAL
  var restIntervalCounter = DEFAULT_REST_INTERVAL

  //Flags
  
  var isWorkInterval = true
  var isStarted = true
  
  //Outlets
  @IBOutlet weak private var timerLabel: UILabel!
  @IBOutlet weak private var statusLabel: UILabel!
  @IBOutlet weak private var workIntervalLabel: UILabel!
  @IBOutlet weak private var restIntervalLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    resetValues()
  }

  private func resetValues() {
    workIntervalLabel.text = "\(workIntervalInSeconds) seconds"
    restIntervalLabel.text = "\(restIntervalInSeconds) seconds"
    isWorkInterval = true
    
  }
  
  private func runTimer() {
    statusLabel.text = isWorkInterval ? "Working" : "Resting"
    timer = Timer.scheduledTimer(timeInterval: 1 , target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
  }
  
  @objc private func updateTimer() {
    let seconds : Int
    if isWorkInterval {
      workIntervalCounter -= 1
      seconds = workIntervalCounter
    } else {
      restIntervalCounter -= 1
      seconds = restIntervalCounter
    }
    if seconds < 2 {
      toggleTimer()
    }
    timerLabel.text = "\(seconds)"
  }

  func toggleTimer() {
    timer.invalidate()
    isWorkInterval = !isWorkInterval
    workIntervalCounter = workIntervalInSeconds + 1
    restIntervalCounter = restIntervalInSeconds + 1
    runTimer()
  }
  
  
  //MARK: Button actions
  @IBAction func startTimerAction(_ sender: Any) {
    runTimer()
  }
  @IBAction func stopTimerAction(_ sender: Any) {
    timer.invalidate()
    resetValues()
  }
  
  @IBAction func changeIntervalsAction(_ sender: Any) {
    
  }
}

