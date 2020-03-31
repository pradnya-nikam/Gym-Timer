//
//  ViewController.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 17/11/19.
//  Copyright © 2019 prad. All rights reserved.
//

import UIKit
import AVFoundation


let DEFAULT_WORK_INTERVAL = 45
let DEFAULT_REST_INTERVAL = 15

class TimerViewController: UIViewController {

  var timer = Timer()

  //User defined values
  var workIntervalInSeconds = DEFAULT_WORK_INTERVAL
  var restIntervalInSeconds = DEFAULT_REST_INTERVAL
  var noOfWorkouts = 2
//  var noOfRounds = 2
  
  //Counters
  var workIntervalCounter = DEFAULT_WORK_INTERVAL
  var restIntervalCounter = DEFAULT_REST_INTERVAL
  var noOfWorkoutsCounter = 0
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
  @IBOutlet weak private var timerLabel: TimerLabel!
  @IBOutlet weak private var statusLabel: UILabel!
  @IBOutlet weak private var workIntervalLabel: UILabel!
  @IBOutlet weak private var restIntervalLabel: UILabel!
  @IBOutlet weak var noOfWorkoutsLabel: UILabel!
  @IBOutlet weak var noOfRoundsLabel: UILabel!
  @IBOutlet weak var startOrPauseButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    resetValues()
  }

  private func resetValues() {
    workIntervalLabel.text = "\(workIntervalInSeconds) seconds"
    restIntervalLabel.text = "\(restIntervalInSeconds) seconds"
    noOfWorkoutsLabel.text = "\(noOfWorkouts)"
//    noOfRoundsLabel.text = "\(noOfRounds)"
    timerLabel.convertSecondsToTimeFormatAndSetText(intervalInSeconds: workIntervalInSeconds)
    statusLabel.text = "Not started"
    resetCounters()
  }
  
  private func resetCounters() {
    isWorkInterval = true
    isStarted = false
    workIntervalCounter = workIntervalInSeconds
    restIntervalCounter = restIntervalInSeconds
    noOfWorkoutsCounter = 0
  }
  
  //MARK: Timer Stuff
  private func startTimer() {
    informIntervalStartBySpeakingOut()
    statusLabel.text = isWorkInterval ? "Working" : "Resting"
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerViewController.updateTimer)), userInfo: nil, repeats: true)
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
    if seconds < 1 {
      toggleTimer()
    }
    timerLabel.convertSecondsToTimeFormatAndSetText(intervalInSeconds: seconds)
    
  }

  func toggleTimer() {
    timer.invalidate()
    //If work interval has ended, count this workout
    if isWorkInterval {
      noOfWorkoutsCounter += 1
    }
    if noOfWorkoutsCounter >= noOfWorkouts {
      notifyWorkoutCompleted()
      return
    }
    isWorkInterval = !isWorkInterval
    workIntervalCounter = workIntervalInSeconds + 1
    restIntervalCounter = restIntervalInSeconds + 1
    startTimer()
    
  }

  private func notifyWorkoutCompleted() {
    statusLabel.text = "Workout Completed"
    isStarted = false
    speakOut(speech: "Workout Completed")
    resetCounters()
  }
  
  //MARK: Speech stuff
  
  private func informIntervalStartBySpeakingOut() {
    let speech = isWorkInterval ? "Starting work": "Starting rest"
    speakOut(speech: speech)
  }
  
  private func speakOut(speech: String) {
    let utterance = AVSpeechUtterance(string: speech)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    utterance.rate = 0.5
    
    let synthesizer = AVSpeechSynthesizer()
    synthesizer.speak(utterance)
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
  
  //MARK: Change Intervals
  @IBAction func changeRestIntervalAction(_ sender: Any) {
    openPickerInAlertView(title: "Rest Interval", type: .Rest)
  }
  
  @IBAction func changeWorkIntervalAction(_ sender: Any) {
    openPickerInAlertView(title: "Work Interval", type: .Work)
  }
  
  var pickerDatasourceDelegate: IntervalPickerDatasourceDelegate?
  
  func openPickerInAlertView(title: String, type: IntervalType) {
    let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
    //371x216
     let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 216))
     alert.view.addSubview(picker)
    let currentIntervalValue = (type == .Work) ? workIntervalInSeconds : restIntervalCounter
    let pickerDatasourceDelegate = IntervalPickerDatasourceDelegate(picker: picker, currentIntervalValue: currentIntervalValue)
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

