//
//  FormJSONBuilder.swift
//  Puls
//
//  Created by MOPC on 22/06/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol FormJSONBuilderProtocol {
  
  /// Подготовить JSON билдер на основе моделей билдера форм
  ///
  /// - Parameter items: Array<FormItemModel>
  /// - Returns: Void
  mutating func prepareObject(tree: FromItemCompositeProtocol)
  
  /// Обновить значение в словаре по пути
  ///
  /// - Parameters:
  ///   - byPath: путь до значения ("test.node.id")
  ///   - value: Значение
  /// - Returns: Void
  mutating func updateValue(byPath: String, value: Any?)
  
  /// /// Обновить значение в словаре по модели
  ///
  /// - Parameter item: модель билдера форм FormItemModel
  /// - Returns: Void
  mutating func updateValue(item: FromItemCompositeProtocol)
  
  /// Динамически формируемый словарь на основе моделей билдера форм
  ///
  /// - Returns: Словарь
  func object(withoutNull: Bool) -> [String: Any]
  
  /// Маппинг динамического словаря в модель
  ///
  /// - Parameter parameters: словарь с нчальными данными, перетрет данные, сформированные форм билдером, в случае совпадения
  /// - Returns: модель
  func mappedObject<T: Mappable>(parameters: [String: Any]?) -> T?
}

struct FormJSONBuilder: FormJSONBuilderProtocol {
  private var creationObject: [String: Any]
  
  init(predefinedObject: [String: Any] = [:]) {
    creationObject = predefinedObject
  }
  
  mutating func prepareObject(tree: FromItemCompositeProtocol) {
    for item in tree.leaves {
      if let i = item as? RowCompositeValidationSetting & RowCompositeValueTransformable {
        let value = prepare(item: i)
        if let valueKeyPath = i.validation.valueKeyPath {
          updateValue(byPath: valueKeyPath, value: value)
        }
      }
    }
  }
  
  mutating func updateValue(item: FromItemCompositeProtocol) {
    
    guard let field = item as? RowCompositeValidationSetting & RowCompositeValueTransformable else {
      return
    }
    
    let value = prepare(item: field)
    if let valueKeyPath = field.validation.valueKeyPath {
      updateValue(byPath: valueKeyPath, value: value)
    }
  }
  
  mutating func updateValue(byPath: String, value: Any?) {
    self.creationObject = creationObject.setOrUpdate(value: value ?? NSNull(), path: byPath)
  }
  
  func object(withoutNull: Bool) -> [String: Any] {
    if withoutNull {
      if let jsonWithoutNull = creationObject.nullKeyRemoval() as? [String: Any] {
        return jsonWithoutNull
      }
    }
    
    return creationObject
  }
  
  func mappedObject<T: Mappable>(parameters: [String: Any]?) -> T? {
    var obj = self.object(withoutNull: false)
    if let parameters = parameters {
      for (key, element) in parameters {
        obj[key] = element
      }
    }
    return Mapper<T>().map(JSON: obj)
  }
  
  private func prepare(item: RowCompositeValueTransformable) -> Any {
    return item.value.transformForJSON()
  }
  
  private func filter(by item: RowFormComposite) -> Bool {
    switch item.visualisation.dataType {
    case .radio:
      return true
    default:
      return true
    }
  }
}
