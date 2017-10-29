//
//  CCRegValidationTextField.swift
//  Pulse
//
//  Created by MOPC on 08.08.16.
//  Copyright © 2016 MOPC Lab. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol TextFieldValidateble {
  func validate(_ validState: RowSettings.ValidationState)
}

extension TextFieldValidateble where Self: UITextField {
  var rx_validationResult: AnyObserver<RowSettings.ValidationState> {
    return UIBindingObserver(UIElement: self) { textField, result in
      textField.validate(result)
      }.asObserver()
  }
}

class CCRegValidationTextField: UITextField, TextFieldValidateble {
  
  private let animationDuration = 0.3
  private let topPlaceholder: UILabel = {
    let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 240, height: 20))
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor.gray
    label.text = "Example of warning text"
    label.textAlignment = NSTextAlignment.left
    label.backgroundColor = UIColor.clear
    label.adjustsFontSizeToFitWidth = true
    label.numberOfLines = 1
    label.baselineAdjustment = UIBaselineAdjustment.alignCenters
    label.alpha = 0
    return label
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.configurate()
  }
  
  var textPlaceholder:String? {
    didSet {
      topPlaceholder.text = textPlaceholder
//      topPlaceholder.sizeToFit()
    }
  }
  
  var hintYPadding:CGFloat = -7.0
  var titleYPadding:CGFloat = -20.0
  
  func configurate() {
    self.borderStyle = UITextBorderStyle.none
    self.clipsToBounds = false
    
    topPlaceholder.frame = CGRect(x: 0, y: -8, width: self.frame.width, height: 20)
    addSubview(topPlaceholder)
  }
  
  func validate(_ validState: RowSettings.ValidationState) {
    var color: UIColor
    switch validState {
    case .failed(_):
      color = UIColor.red
    case .valid:
      color = UIColor.green
    case .typing:
      color = UIColor.lightGray
    }
    
    topPlaceholder.textColor = color
  }
  
  // MARK: - Overrides
  override func layoutSubviews() {
    super.layoutSubviews()
    let isResp = isFirstResponder
    if let txt = text , !txt.isEmpty { //&& isResp {
      // topPlaceholder.textColor = UIColor.gray
    } else {
      // topPlaceholder.textColor = UIColor.grayColor()
    }
    // Should we show or hide the title label?
    if let txt = text , txt.isEmpty {
      // Hide
      hideTitle(isResp)
    } else {
      // Show
      showTitle(isResp)
    }
  }
  
  private func showTitle(_ animated:Bool) {
    let dur = animated ? animationDuration : 0
    UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseOut], animations:{
      // Animation
      self.topPlaceholder.alpha = 1.0
      var r = self.topPlaceholder.frame
      r.origin.y = self.titleYPadding
      self.topPlaceholder.frame = r
      }, completion:nil)
  }
  
  private func hideTitle(_ animated:Bool) {
    let dur = animated ? animationDuration : 0
    UIView.animate(withDuration: dur, delay:0, options: [UIViewAnimationOptions.beginFromCurrentState, UIViewAnimationOptions.curveEaseIn], animations:{
      // Animation
      self.topPlaceholder.alpha = 0.0
      var r = self.topPlaceholder.frame
      r.origin.y = self.topPlaceholder.font.lineHeight + self.hintYPadding
      self.topPlaceholder.frame = r
      }, completion:nil)
  }
}
