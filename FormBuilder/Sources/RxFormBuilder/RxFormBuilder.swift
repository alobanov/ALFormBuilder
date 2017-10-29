//
//  RxFormBuilder.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 28/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

protocol RxFormBuilderProtocol {
  var rxDidChangeFormModel: Observable<[RxSectionModel]> {get}
  var rxDidChangeCompletelyValidation: Observable<Bool> {get}
  var rxDidChangeFormState: Observable<Bool> {get}
  
  // Подготовить билдер данные для отображения, после вызова форма отрисуется
  func prepareDatasource()
  
  // Динамически сформированый словарь с введенными данными
  func object(withoutNull: Bool) -> [String: Any]
  
  // Запросить модель по уникальному идентификатору
  func model(by identifier: String) -> FromItemCompositeProtocol?
  
  // Конфигурируем
  func configure(compositeFormData: FromItemCompositeProtocol)
}

class RxFormBuilder: FormBuilder, RxFormBuilderProtocol {
  var rxDidChangeFormModel: Observable<[RxSectionModel]> {
    return _didChangeFormModel.asObservable()
  }
  
  let _didChangeFormModel = BehaviorSubject<[RxSectionModel]>(value: [])
  
  var rxDidChangeCompletelyValidation: Observable<Bool> {
    return _didChangeCompletelyValidation.asObservable()
  }
  
  let _didChangeCompletelyValidation = BehaviorSubject<Bool>(value: false)
  
  var rxDidChangeFormState: Observable<Bool> {
    return _didChangeFormState.asObservable()
  }
  
  let _didChangeFormState = BehaviorSubject<Bool>(value: false)
  
  override init(compositeFormData: FromItemCompositeProtocol, jsonBuilder: FormJSONBuilderProtocol) {
    super.init(compositeFormData: compositeFormData, jsonBuilder: jsonBuilder)
    defineRx()
  }
  
  func defineRx() {
    self.didChangeCompletelyValidation = { [weak self] isValid in
      self?._didChangeCompletelyValidation.onNext(isValid)
    }
    
    self.didChangeFormModel = { [weak self] model in
      if let sections = self?.buildRxDataSource(item: model) {
        self?._didChangeFormModel.onNext(sections)
      }
    }
    
    self.didChangeFormState = { [weak self] isChanged in
      self?._didChangeFormState.onNext(isChanged)
    }
  }
  
  private func buildRxDataSource(item: FromItemCompositeProtocol) -> [RxSectionModel] {
    /// Sections
    var sections: [RxSectionModel] = []
    for section in item.datasource {
      
      var renderItemsData: [RxSectionItemModel] = []
      for row in section.datasource {
        if let rowModel = row as? RxCellModelDatasoursable {
          renderItemsData.append(RxSectionItemModel(model: rowModel))
        }
      }
      
      if let sectionModel = section as? SectionFormComposite {
        sections.append(RxSectionModel(items: renderItemsData, model: sectionModel))
      }
    }
    
    return sections
  }
}
