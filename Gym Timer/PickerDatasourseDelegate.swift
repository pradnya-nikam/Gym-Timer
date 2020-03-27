//
//  PickerDatasourseDelegate.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 24/03/20.
//  Copyright © 2020 prad. All rights reserved.
//

import UIKit
class IntervalPickerDatasourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
  let intervalPicker: UIPickerView
  var pickerData = [[Int]]()
  let currentIntervalValue: Int
  var selectedMinute = 0
  var selectedSecond = 0
  let maxIntervalValue = 60
  init(picker: UIPickerView, currentIntervalValue: Int) {
    self.intervalPicker = picker
    self.currentIntervalValue = currentIntervalValue
  }

  func loadData() {

    intervalPicker.dataSource = self
    intervalPicker.delegate = self

    //Create 2 arrays for minutes and seconds values
    pickerData = [[Int](),[Int]()]
    for i in 0..<maxIntervalValue {
      pickerData[0].append(i)
      pickerData[1].append(i)
    }
    
    selectCurrentDataOnPicker()
  }

  func selectCurrentDataOnPicker() {
    if currentIntervalValue > maxIntervalValue {
      selectedMinute = currentIntervalValue/maxIntervalValue
      selectedSecond = currentIntervalValue - selectedMinute*maxIntervalValue
    } else {
      selectedMinute = 0
      selectedSecond = currentIntervalValue
    }
    intervalPicker.selectRow(selectedMinute, inComponent: 0, animated: false)
    intervalPicker.selectRow(selectedSecond, inComponent: 1, animated: false)
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
  
}
