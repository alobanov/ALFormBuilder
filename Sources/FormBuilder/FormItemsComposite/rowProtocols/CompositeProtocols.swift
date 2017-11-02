//
//  CompositeProtocols.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Протокол отвечающий за возможность пределить правила видимости для элемента таблицы
public protocol RowCompositeVisibleSetting: class {
  var visible: ALFB.Visible {set get}
  var base: ALFB.Base {set get}
  var cellType: FBUniversalCellProtocol {get}
  func checkStates(by source: [String: Any]) -> Bool
}

extension RowCompositeVisibleSetting {
  public var cellType: FBUniversalCellProtocol {
    return self.base.cellType
  }
  
  public func checkStates(by source: [String: Any]) -> Bool {
    let isChangeVisible = visible.checkVisibleState(model: source)
    let isChangeMandatory = visible.checkMandatoryState(model: source)
    let isChangeDisable = visible.checkDisableState(model: source)
    let isChangeValid = visible.checkValidState(model: source)
    return (isChangeVisible || isChangeMandatory || isChangeDisable || isChangeValid) || base.isStrictReload
  }
}

/// Протокол отвечающий за возможность валидации
public protocol RowCompositeValidationSetting: RowCompositeValueTransformable {
  var validation: ALFB.Validation {set get}
  func update(value: ALValueTransformable)
  func updateAndReload(value: ALValueTransformable)
  @discardableResult func validate(value: ALValueTransformable) -> ALFB.ValidationState
}

extension RowCompositeValidationSetting where Self: FromItemCompositeProtocol & RowCompositeVisibleSetting {
  public func updateAndReload(value: ALValueTransformable) {
    self.base.needReloadModel()
    self.update(value: value)
  }
  
  public func update(value: ALValueTransformable) {
    if self.value.transformForDisplay() != value.transformForDisplay() {
      self.value.change(originalValue: value.retriveOriginalValue())
      didChangeData?(self)
    }
  }
}

public typealias DidChange = (FromItemCompositeProtocol) -> Void
public typealias DidChangeValidation = () -> Void

/// Протокол отвечающий за возможность хранить заначение типа ValueTransformable
public protocol RowCompositeValueTransformable: class {
  var value: ALValueTransformable {get}
  var didChangeData: DidChange? {set get}
  var didChangeValidation: [String: DidChangeValidation?] {set get}
}
