//
//  StringRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// String form item builder
protocol StringRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, isPassword: Bool, keyboardType: ALFB.FBKeyboardType?, autocapitalizationType: ALFB.FBAutocapitalizationType?, keyboardOptions: ALFB.TextConstraintType)
}

class StringRowItemBuilder: RowItemBuilder, StringRowItemBuilderProtocol {
  var visualization = ALFB.Visualization(placeholderText: "", placeholderTopText: nil, detailsText: nil, isPassword: false, keyboardType: .defaultKeyboard, autocapitalizationType: .none, keyboardOptions: .none)
  
  func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, isPassword: Bool, keyboardType: ALFB.FBKeyboardType?, autocapitalizationType: ALFB.FBAutocapitalizationType?, keyboardOptions: ALFB.TextConstraintType){
    visualization = ALFB.Visualization(placeholderText: placeholderText, placeholderTopText: placeholderTopText, detailsText: detailsText, isPassword: isPassword, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, keyboardOptions: keyboardOptions)
  }
  
  override func result() -> FromItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    return RowFormTextComposite(composite: baseComposite, value: self.value, validation: validation,
                                visualisation: visualization, visible: visibleSetting, base: base)
  }
}
