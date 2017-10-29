//
//  FormBuilder.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation


protocol FormBuilderProtocol {
  var didChangeFormModel: FormBuilder.DidChangeFormModel? {set get}
  var didChangeCompletelyValidation: FormBuilder.DidChangeCompletelyValidation? {set get}
  var didChangeFormState: FormBuilder.DidChangeFormState? {set get}
  
  // Подготовить билдер данные для отображения, после вызова форма отрисуется
  func prepareDatasource()
  
  // Динамически сформированый словарь с введенными данными
  func object(withoutNull: Bool) -> [String: Any]
  
  // Запросить модель по уникальному идентификатору
  func model(by identifier: String) -> FromItemCompositeProtocol?
  
  // Конфигурируем
  func configure(compositeFormData: FromItemCompositeProtocol)
}

class FormBuilder: FormBuilderProtocol {
  typealias DidChangeFormModel = (FromItemCompositeProtocol) -> Void
  typealias DidChangeCompletelyValidation = (Bool) -> Void
  typealias DidChangeFormState = (Bool) -> Void
  
  var didChangeFormModel: FormBuilder.DidChangeFormModel?
  var didChangeCompletelyValidation: FormBuilder.DidChangeCompletelyValidation?
  var didChangeFormState: FormBuilder.DidChangeFormState?
  
  private var jsonBuilder: FormJSONBuilderProtocol
  private var compositeFormData: FromItemCompositeProtocol?
  
  // Состояния
  private var completelyValidation: Bool = false
  private var formWasModify: Bool = false
  
  let logger = Atlantis.Logger()
  
  // Инициализация с подготовленой структурой данных для таблицы
  // и зависимость в виде билдера для JSON
  init(compositeFormData: FromItemCompositeProtocol, jsonBuilder: FormJSONBuilderProtocol) {
    self.jsonBuilder = jsonBuilder
    
    if compositeFormData.level == .root {
      configure(compositeFormData: compositeFormData)
    }
  }
  
  // Ручная конфигурация с новой структурой
  // Метод перезапускает инициализацию FormJSONBuilder
  // Также выполняется подписка на изменение всех полей в форме
  func configure(compositeFormData: FromItemCompositeProtocol) {
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
  func prepareDatasource() {
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
  private func rebuildFields() {
    guard let item = self.compositeFormData else {
      return
    }
    
    // reload table if needed
    let isChanged = checkAllStates(in: item)
    let isChangedInCommonState = checkCommonFormState(in: item)
    
    if isChanged || isChangedInCommonState {
      reloadDataSource()
    }
    
    logger.debug(self.object(withoutNull: false))
  }
  
  // Проврка всех состояний во всех полях таблицы, возвращает значение нужна ли перезагрузка таблицы или нет
  @discardableResult private func checkAllStates(in compositeFormData: FromItemCompositeProtocol) -> Bool {
    var needReload = false
    let obj = jsonBuilder.object(withoutNull: false)
    
    guard let rows = compositeFormData.leaves
      .filter({ $0 is RowCompositeVisibleSetting }) as? [RowCompositeVisibleSetting] else {
      return needReload
    }
    
    for row in rows  {
      let isChanged = row.checkStates(by: obj)
      
      if isChanged {
        row.base.needReloadModel()
        needReload = true
      }
    }
    
    return needReload
  }
  
  // Получить словарь со сформированной структурой по данным таблицы
  func object(withoutNull: Bool) -> [String: Any] {
    return jsonBuilder.object(withoutNull: withoutNull)
  }
  
  // Обновить значение в JOSN передав просто композит модели ячейки
  private func updateChanged(item: FromItemCompositeProtocol) {
    jsonBuilder.updateValue(item: item)
    rebuildFields()
  }
  
  // Получить модель по уникальному идентификатору
  func model(by identifier: String) -> FromItemCompositeProtocol? {
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
      didChangeFormModel?(composite)
    }
  }
  
  @discardableResult private func itemsWithFullValidation(in item: FromItemCompositeProtocol, isFullValidState: Bool) -> Bool {
    guard let fullValidationItems = item.leaves.filter({$0 is RowCompositeVisibleSetting}) as? [RowCompositeVisibleSetting] else {
      return false
    }
    
    for field in fullValidationItems where field.visible.disabledExp == RowSettings.Visible.fullValidation {
      field.base.needReloadModel()
      field.visible.changeDisabled(state: !completelyValidation)
    }
    
    return true
  }
  
  deinit {
    print("FormBuilder are dead")
  }
}
