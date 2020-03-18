//
//  IntervalPicker.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 21/11/19.
//  Copyright © 2019 prad. All rights reserved.
//

import Foundation
import UIKit

class IntervalPickerViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  @IBOutlet weak var workIntervalPicker: UIPickerView!
  
  var pickerData = [[Int]]()
  
  var selectedMinute = 0
  var selectedSecond = DEFAULT_WORK_INTERVAL
  override func viewDidLoad() {
    super.viewDidLoad()

    //Insert 2 arrays for minutes and seconds values
    pickerData = [[Int](),[Int]()]
    for i in 0..<60 {
      pickerData[0].append(i)
      pickerData[1].append(i)
    }
    workIntervalPicker.dataSource = self
    workIntervalPicker.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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
     selectedMinute = component
    default:
      selectedSecond = row
    }
  }
  
}
