//
//  ALFormBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ALFormBuilderProtocol {
  var didDatasource: ALFormBuilder.DidDatasource? {set get}
  var didChangeFormModel: ALFormBuilder.DidChangeFormModel? {set get}
  var didChangeCompletelyValidation: ALFormBuilder.DidChangeCompletelyValidation? {set get}
  var didChangeFormState: ALFormBuilder.DidChangeFormState? {set get}
  
  // Подготовить билдер данные для отображения, после вызова форма отрисуется
  func prepareDatasource()
  
  // Динамически сформированый словарь с введенными данными
  func object(withoutNull: Bool) -> [String: Any]
  
  // Запросить модель по уникальному идентификатору
  func model(by identifier: String) -> FromItemCompositeProtocol?
  
  // Конфигурируем
  func configure(compositeFormData: FromItemCompositeProtocol)
  
  func apply(errors: [String: String]) -> Bool
  
  //маппинг динамического словаря в модель
  func mappedObject<T: Mappable>(parameters: [String: Any]?) -> T?
}

public class ALFormBuilder: ALFormBuilderProtocol {
  public typealias DidDatasource = (FromItemCompositeProtocol) -> Void
  public typealias DidChangeFormModel = (FromItemCompositeProtocol) -> Void
  public typealias DidChangeCompletelyValidation = (Bool) -> Void
  public typealias DidChangeFormState = (Bool) -> Void
  
  public var didDatasource: ALFormBuilder.DidDatasource?
  public var didChangeFormModel: ALFormBuilder.DidChangeFormModel?
  public var didChangeCompletelyValidation: ALFormBuilder.DidChangeCompletelyValidation?
  public var didChangeFormState: ALFormBuilder.DidChangeFormState?
  
  private var jsonBuilder: ALFormJSONBuilderProtocol
  private var compositeFormData: FromItemCompositeProtocol?
  
  // Состояния
  private var completelyValidation: Bool = false
  private var formWasModify: Bool = false
  
  // Инициализация с подготовленой структурой данных для таблицы
  // и зависимость в виде билдера для JSON
  public init(compositeFormData: FromItemCompositeProtocol, jsonBuilder: ALFormJSONBuilderProtocol) {
    self.jsonBuilder = jsonBuilder
    
    if compositeFormData.level == .root {
      configure(compositeFormData: compositeFormData)
    }
  }
  
  // Ручная конфигурация с новой структурой
  // Метод перезапускает инициализацию FormJSONBuilder
  // Также выполняется подписка на изменение всех полей в форме
  public func configure(compositeFormData: FromItemCompositeProtocol) {
    self.compositeFormData = compositeFormData
    self.jsonBuilder.prepareObject(tree: compositeFormData)
    
    guard let rows = compositeFormData.leaves
      .filter({ $0 is RowCompositeValueTransformable }) as? [RowCompositeValueTransformable] else {
      return
    }
    
    for row in rows {
      row.didChangeData = { [weak self] f in
        self?.updateChanged(item: f)
      }
    }
  }
  
  // Подготовка данных и формирование данных для таблицы
  public func prepareDatasource() {
    guard let item = self.compositeFormData else {
      return
    }
    
    // Проверка всех состоянийв полях (обязательность, видимость и блокировка)
    checkAllStates(in: item)
    // Проверка состояний всей таблицы (изменение, полная валидация)
    checkCommonFormState(in: item)
    // Установка значения по умолчанию для полей которые требуют полной валидации
    itemsWithFullValidation(in: item, isFullValidState: completelyValidation)
    // Формирование всех элементов для таблицы
    reloadDataSource()
  }

  // Проверка всех состояний в моделях таблицы и пересозлание
  private func rebuildFields(item1: FromItemCompositeProtocol) {
    guard let item = self.compositeFormData else {
      return
    }
    
    // reload table if needed
    let isChanged = checkAllStates(in: item)
    let isChangedInCommonState = checkCommonFormState(in: item)
    
    if isChanged || isChangedInCommonState {
      reloadDataSource()
    }
  }
  
  // Проврка всех состояний во всех полях таблицы, возвращает значение нужна ли перезагрузка таблицы или нет
  @discardableResult private func checkAllStates(in compositeFormData: FromItemCompositeProtocol) -> Bool {
    var needReload = false
    let obj = jsonBuilder.object(withoutNull: false)
    
    guard let rows = compositeFormData.leaves
      .filter({ $0 is RowCompositeVisibleSetting & FromItemCompositeProtocol }) as? [RowCompositeVisibleSetting & FromItemCompositeProtocol] else {
      return needReload
    }
    
    for row in rows  {      
      if row.checkStates(by: obj) {
        row.base.needReloadModel()
        needReload = true
      }
    }
    
    for row in rows where row is RowCompositeValidationSetting  {
      guard let validatebleRow = row as? RowCompositeValidationSetting else {
        continue
      }
      
      let prew = validatebleRow.validation.state
      let new = validatebleRow.validate(value: validatebleRow.value)
      if !(prew == new) {
        validatebleRow.validation.change(state: new)
        if let block = validatebleRow.didChangeValidation[row.identifier] {
          block?()
        }
      }
    }
    
    return needReload
  }
  
  // Получить словарь со сформированной структурой по данным таблицы
  public func object(withoutNull: Bool) -> [String: Any] {
    return jsonBuilder.object(withoutNull: withoutNull)
  }
  
  // Обновить значение в JOSN передав просто композит модели ячейки
  private func updateChanged(item: FromItemCompositeProtocol) {
    jsonBuilder.updateValue(item: item)
    didChangeFormModel?(item)
    rebuildFields(item1: item)
  }
  
  // Получить модель по уникальному идентификатору
  public func model(by identifier: String) -> FromItemCompositeProtocol? {
    guard let rows = self.compositeFormData?.leaves else {
      return nil
    }
    
    for row in rows where row.identifier == identifier  {
      return row
    }
    
    return nil
  }
  
  @discardableResult private func checkCommonFormState(in item: FromItemCompositeProtocol) -> Bool {
    var needReload = false
    
    if item.wasChanged() != formWasModify {
      formWasModify = !formWasModify
      didChangeFormState?(formWasModify)
    }
    
    if item.isValid() != completelyValidation {
      completelyValidation = !completelyValidation
      didChangeCompletelyValidation?(completelyValidation)
      needReload = itemsWithFullValidation(in: item, isFullValidState: completelyValidation)
    }
    
    return needReload
  }
  
  // Формирование нового datasource для перерисовки (упрощенный вызов)
  private func reloadDataSource() {
    if let composite = self.compositeFormData  {
      didDatasource?(composite)
    }
  }
  
  @discardableResult private func itemsWithFullValidation(in item: FromItemCompositeProtocol, isFullValidState: Bool) -> Bool {
    guard let fullValidationItems = item.leaves.filter({$0 is RowCompositeVisibleSetting}) as? [RowCompositeVisibleSetting] else {
      return false
    }
    
    for field in fullValidationItems where field.visible.disabledExp == ALFB.Visible.fullValidation {
      field.base.needReloadModel()
      field.visible.changeDisabled(state: !completelyValidation)
    }
    
    return true
  }
  
  public func mappedObject<T: Mappable>(parameters: [String: Any]?) -> T? {
    return jsonBuilder.mappedObject(parameters: parameters)
  }
  
  public func apply(errors: [String: String]) -> Bool {
    var isContainError = false
    
    for (formItentifier, message) in errors {
      guard let model = model(by: formItentifier) as? RowCompositeValidationSetting else {
        continue
      }
      
      model.validation.change(state: .failed(message: message))
      isContainError = true
    }
    
    if isContainError {
      didChangeCompletelyValidation?(!isContainError)
    }
    return isContainError
  }
  
  deinit {
    print("FormBuilder are dead")
  }
}
