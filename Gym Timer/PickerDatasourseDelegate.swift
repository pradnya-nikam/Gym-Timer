//
//  PickerDatasourseDelegate.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 24/03/20.
//  Copyright © 2020 prad. All rights reserved.
//

import UIKit
class PickerDatasourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
  let workIntervalPicker: UIPickerView
  var pickerData = [[Int]]()
  weak var intervalChangeDelegate: IntervalChangeDelegate?
  var currentWorkInterval = DEFAULT_WORK_INTERVAL
  var selectedMinute = 0
  var selectedSecond = DEFAULT_WORK_INTERVAL
  
  init(picker: UIPickerView) {
    self.workIntervalPicker = picker
    
  }

  func loadData() {
    //Insert 2 arrays for minutes and seconds values
    workIntervalPicker.dataSource = self
    workIntervalPicker.delegate = self

    pickerData = [[Int](),[Int]()]
    for i in 0..<60 {
      pickerData[0].append(i)
      pickerData[1].append(i)
    }
    
    selectCurrentDataOnPicker()
  }

  func selectCurrentDataOnPicker() {
    if currentWorkInterval > 60 {
      selectedMinute = currentWorkInterval/60
      selectedSecond = currentWorkInterval - selectedMinute*60
    } else {
      selectedMinute = 0
      selectedSecond = currentWorkInterval
    }
    workIntervalPicker.selectRow(selectedMinute, inComponent: 0, animated: false)
    workIntervalPicker.selectRow(selectedSecond, inComponent: 1, animated: false)
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return pickerData[component].count
  }
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return pickerData.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    switch component {
    case 0:
      return "\(pickerData[component][row]) min"
    case 1:
      return "\(pickerData[component][row]) sec"
    default:
      return ""
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case 0:
      selectedMinute = row
    default:
      selectedSecond = row
    }
  }
  
  func onDoneButtonTap(_ sender: Any) {
    intervalChangeDelegate?.intervalChanged(min: selectedMinute, sec: selectedSecond)
//    dismissSelf()
  }
  
  
}
