//
//  CompositeProtocols.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

/// Протокол отвечающий за возможность пределить правила видимости для элемента таблицы
protocol RowCompositeVisibleSetting: class {
  var visible: RowSettings.Visible {set get}
  var base: RowSettings.Base {set get}
  var cellType: UniversalCellProtocol {get}
  func checkStates(by source: [String: Any]) -> Bool
}

extension RowCompositeVisibleSetting {
  var cellType: UniversalCellProtocol {
    return self.base.cellType
  }
  
  func checkStates(by source: [String: Any]) -> Bool {
    let isChangeVisible = visible.checkVisibleState(model: source)
    let isChangeMandatory = visible.checkMandatoryState(model: source)
    let isChangeDisable = visible.checkDisableState(model: source)
    return (isChangeVisible || isChangeMandatory || isChangeDisable) || base.isStrictReload
  }
}

/// Протокол отвечающий за настройки и хранение статических данных для отображения
protocol RowCompositeVisualizationSetting {
  var visualisation: RowSettings.Visualization {get}
}

/// Протокол отвечающий за возможность валидации
protocol RowCompositeValidationSetting: class {
  var validation: RowSettings.Validation {get}
  @discardableResult func validate(value: ValueTransformable) -> RowSettings.ValidationState
}

typealias DidChange = (FromItemCompositeProtocol) -> Void

/// Протокол отвечающий за возможность хранить заначение типа ValueTransformable
protocol RowCompositeValueTransformable: class {
  var value: ValueTransformable {get}
  var didChangeData: DidChange? {set get}
}
