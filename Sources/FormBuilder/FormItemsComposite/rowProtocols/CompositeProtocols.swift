//
//  CompositeProtocols.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Протокол отвечающий за возможность пределить правила видимости для элемента таблицы
protocol RowCompositeVisibleSetting: class {
  var visible: ALFB.Visible {set get}
  var base: ALFB.Base {set get}
  var cellType: FBUniversalCellProtocol {get}
  func checkStates(by source: [String: Any]) -> Bool
}

extension RowCompositeVisibleSetting {
  var cellType: FBUniversalCellProtocol {
    return self.base.cellType
  }
  
  func checkStates(by source: [String: Any]) -> Bool {
    let isChangeVisible = visible.checkVisibleState(model: source)
    let isChangeMandatory = visible.checkMandatoryState(model: source)
    let isChangeDisable = visible.checkDisableState(model: source)
    return (isChangeVisible || isChangeMandatory || isChangeDisable) || base.isStrictReload
  }
}

/// Протокол отвечающий за возможность валидации
protocol RowCompositeValidationSetting: class, RowCompositeValueTransformable {
  var validation: ALFB.Validation {set get}
  @discardableResult func validate(value: ALValueTransformable) -> ALFB.ValidationState
  func makeValidation(value: ALValueTransformable) -> ALFB.ValidationState
}

extension RowCompositeValidationSetting where Self: FromItemCompositeProtocol {
  @discardableResult func validate(value: ALValueTransformable) -> ALFB.ValidationState {
    let result = makeValidation(value: value)
    self.validation.change(state: result)
    
    if self.value.transformForDisplay() != value.transformForDisplay() {
      self.value.change(originalValue: value.retriveOriginalValue())
      didChangeData?(self)
    }
    
    return result
  }
}

typealias DidChange = (FromItemCompositeProtocol) -> Void

/// Протокол отвечающий за возможность хранить заначение типа ValueTransformable
protocol RowCompositeValueTransformable: class {
  var value: ALValueTransformable {get}
  var didChangeData: DidChange? {set get}
}
