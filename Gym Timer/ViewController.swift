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
  var isStarted = false {
    didSet {
      DispatchQueue.main.async {
        let title = self.isStarted ? "PAUSE" : "START"
        self.startOrPauseButton.setTitle(title, for: .normal)
      }
    }
  }
  
  //Outlets
  @IBOutlet weak private var timerLabel: UILabel!
  @IBOutlet weak private var statusLabel: UILabel!
  @IBOutlet weak private var workIntervalLabel: UILabel!
  @IBOutlet weak private var restIntervalLabel: UILabel!
  @IBOutlet weak var startOrPauseButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    resetValues()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    resetValues()
  }

  private func resetValues() {
    workIntervalLabel.text = "\(workIntervalInSeconds) seconds"
    restIntervalLabel.text = "\(restIntervalInSeconds) seconds"
    timerLabel.text = "\(workIntervalInSeconds)"
    statusLabel.text = "Not started"
    isWorkInterval = true
    isStarted = false
    workIntervalCounter = workIntervalInSeconds
    restIntervalCounter = restIntervalInSeconds
  }
  
  //MARK: Timer Stuff
  private func startTimer() {
    statusLabel.text = isWorkInterval ? "Working" : "Resting"
    timer = Timer.scheduledTimer(timeInterval: 1 , target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    isStarted = true
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
    startTimer()
  }
  
  //MARK: Button actions
  @IBAction func startTimerAction(_ sender: Any) {
    if !isStarted {
      startTimer()
      
    } else {
      timer.invalidate()
      isStarted = false
    }
  }
  @IBAction func stopTimerAction(_ sender: Any) {
    timer.invalidate()
    resetValues()
  }
  
  @IBAction func changeRestIntervalAction(_ sender: Any) {
    openPickerInAlertView(title: "Rest Interval", type: .Rest)
  }
  
  @IBAction func changeWorkIntervalAction(_ sender: Any) {
    openPickerInAlertView(title: "Work Interval", type: .Work)
  }
  
  var pickerDatasourceDelegate: PickerDatasourceDelegate?
  
  func openPickerInAlertView(title: String, type: IntervalType) {
    let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
    //371x216
     let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 216))
     alert.view.addSubview(picker)
    let currentIntervalValue = (type == .Work) ? workIntervalInSeconds : restIntervalCounter
    let pickerDatasourceDelegate = PickerDatasourceDelegate(picker: picker, currentIntervalValue: currentIntervalValue)
    pickerDatasourceDelegate.loadData()
    
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (action)  in
      self?.intervalChanged(min: pickerDatasourceDelegate.selectedMinute,
                            sec: pickerDatasourceDelegate.selectedSecond, type: type)
      self?.pickerDatasourceDelegate = nil
    }))
    self.pickerDatasourceDelegate = pickerDatasourceDelegate
    self.present(alert ,animated: true, completion: nil )
  }
  
  
  func intervalChanged(min: Int, sec: Int, type: IntervalType) {
    let valueInSeconds = min * 60 + sec
    switch type {
    case .Work:
      workIntervalInSeconds = valueInSeconds
    case .Rest:
      restIntervalInSeconds = valueInSeconds
    }
    resetValues()
  }
}

