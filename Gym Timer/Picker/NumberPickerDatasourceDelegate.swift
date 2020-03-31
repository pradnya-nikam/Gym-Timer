//
//  NumberPickerDatasourceDelegate.swift
//  Gym Timer
//
//  Created by Pradnya Nikam on 31/03/20.
//  Copyright © 2020 prad. All rights reserved.
//

import UIKit

class NumberPickerDatasourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
  var selectedValue: Int
  let picker: UIPickerView
  let maxValue = 30
  
  
  init(picker: UIPickerView, selectedValue: Int) {
    self.picker = picker
    self.selectedValue = selectedValue
  }

  func initialiseData() {
    picker.dataSource = self
    picker.delegate = self

    selectCurrentDataOnPicker()
  }
  
  private func selectCurrentDataOnPicker() {
    picker.selectRow(selectedValue - 1, inComponent: 0, animated: false)
  }

  //MARK: UIPickerViewDataSource methods

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return maxValue
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(row + 1)"
  }
  
  //MARK: UIPickerViewDelegate methods
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      selectedValue = row + 1
  }
  
}
