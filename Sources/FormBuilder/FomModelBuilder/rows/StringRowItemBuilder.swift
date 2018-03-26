//
//  StringRowItemBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 29/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// String form item builder
public protocol StringRowItemBuilderProtocol: RowItemVisibleBuilderProtocol, RowItemBaseBuilderProtocol,
RowItemValidationBuilderProtocol, RowItemValueBuilderProtocol {
  func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, isPassword: Bool, keyboardType: ALFB.FBKeyboardType?, autocapitalizationType: ALFB.FBAutocapitalizationType?, keyboardOptions: ALFB.TextConstraintType, showEye: Bool?)
}

public class StringRowItemBuilder: RowItemBuilder, StringRowItemBuilderProtocol {
  var visualization = ALFB.Visualization(placeholderText: "", placeholderTopText: nil, detailsText: nil, isPassword: false, keyboardType: .defaultKeyboard, autocapitalizationType: .none, keyboardOptions: .none, showEye: nil)
  
  public override init() {
    
  }
  
  public func defineVisualization(placeholderText: String, placeholderTopText: String?, detailsText: String?, isPassword: Bool, keyboardType: ALFB.FBKeyboardType?, autocapitalizationType: ALFB.FBAutocapitalizationType?, keyboardOptions: ALFB.TextConstraintType, showEye: Bool?){
    visualization = ALFB.Visualization(placeholderText: placeholderText, placeholderTopText: placeholderTopText, detailsText: detailsText, isPassword: isPassword, keyboardType: keyboardType, autocapitalizationType: autocapitalizationType, keyboardOptions: keyboardOptions, showEye: showEye)
  }
  
  public override func result() -> FormItemCompositeProtocol {
    let baseComposite = BaseFormComposite(identifier: identifier, level: level)
    baseComposite.customData = customData
    return RowFormTextComposite(composite: baseComposite, value: self.value, validation: validation,
                                visualisation: visualization, visible: visibleSetting, base: base)
  }
}
