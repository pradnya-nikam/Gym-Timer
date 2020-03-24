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

class ViewController: UIViewController, IntervalChangeDelegate {

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
  
  @IBAction func changeIntervalsAction(_ sender: Any) {
      openPickerInAlertView(title: "Work Interval")
  }
  var pickerDatasourceDelegate: PickerDatasourceDelegate?
  
  func openPickerInAlertView(title: String) {
    let alert = UIAlertController(title: title, message: "\n\n\n", preferredStyle: .actionSheet)
     let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
     alert.view.addSubview(picker)
    let pickerDatasourceDelegate = PickerDatasourceDelegate(picker: picker)
    pickerDatasourceDelegate.loadData()
    
//    pickerDatasourceDelegate?.intervalChangeDelegate = self
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self](action)  in
      print("You selected \(pickerDatasourceDelegate.selectedMinute), \(pickerDatasourceDelegate.selectedSecond)")
      self?.intervalChanged(min: pickerDatasourceDelegate.selectedMinute, sec: pickerDatasourceDelegate.selectedSecond)
    }))
    self.pickerDatasourceDelegate = pickerDatasourceDelegate
    self.present(alert ,animated: true, completion: nil )
  }
  
  func openPickerVC() {
    if let pickerVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "IntervalPickerViewController") as? IntervalPickerViewController {
      pickerVC.intervalChangeDelegate = self
      pickerVC.currentWorkInterval = workIntervalInSeconds
      self.present(pickerVC, animated: true, completion: nil)
    }
  }
  
  //MARK: IntervalChange delegate methods
  func intervalChanged(min: Int, sec: Int) {
    workIntervalInSeconds = min * 60 + sec
    resetValues()
  }
}

