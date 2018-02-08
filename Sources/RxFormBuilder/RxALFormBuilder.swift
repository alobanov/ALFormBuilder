//
//  RxFormBuilder.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 28/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation
import RxSwift

public protocol RxALFormBuilderProtocol {
  var rxDidDatasource: Observable<[RxSectionModel]> {get}
  var rxDidChangeFormModel: Observable<FormItemCompositeProtocol> {get}
  var rxDidChangeCompletelyValidation: Observable<Bool> {get}
  var rxDidChangeFormState: Observable<Bool> {get}
  
  // Подготовить билдер данные для отображения, после вызова форма отрисуется
  func prepareDatasource()
  
  // Динамически сформированый словарь с введенными данными
  func object(withoutNull: Bool) -> [String: Any]
  
  // Запросить модель по уникальному идентификатору
  func model(by identifier: String) -> FormItemCompositeProtocol?
  
  // Конфигурируем
  func configure(compositeFormData: FormItemCompositeProtocol)
}

public class RxALFormBuilder: ALFormBuilder, RxALFormBuilderProtocol {
  public var rxDidDatasource: Observable<[RxSectionModel]> {
    return _rxDidDatasource.asObservable()
  }
  
  private let _rxDidDatasource = BehaviorSubject<[RxSectionModel]>(value: [])
  
  public var rxDidChangeFormModel: Observable<FormItemCompositeProtocol> {
    return _didChangeFormModel.asObservable()
  }
  
  private let _didChangeFormModel = PublishSubject<FormItemCompositeProtocol>()
  
  public var rxDidChangeCompletelyValidation: Observable<Bool> {
    return _didChangeCompletelyValidation.asObservable()
  }
  
  private let _didChangeCompletelyValidation = BehaviorSubject<Bool>(value: false)
  
  public var rxDidChangeFormState: Observable<Bool> {
    return _didChangeFormState.asObservable()
  }
  
  private let _didChangeFormState = BehaviorSubject<Bool>(value: false)
  
  public override init(compositeFormData: FormItemCompositeProtocol, jsonBuilder: ALFormJSONBuilderProtocol) {
    super.init(compositeFormData: compositeFormData, jsonBuilder: jsonBuilder)
    defineRx()
  }
  
  private func defineRx() {
    self.didChangeCompletelyValidation = { [weak self] isValid in
      self?._didChangeCompletelyValidation.onNext(isValid)
    }
    
    self.didChangeFormModel = { [weak self] model in
      self?._didChangeFormModel.onNext(model)
    }
    
    self.didDatasource = { [weak self] model in
      if let sections = self?.buildRxDataSource(item: model) {
        self?._rxDidDatasource.onNext(sections)
      }
    }
    
    self.didChangeFormState = { [weak self] isChanged in
      self?._didChangeFormState.onNext(isChanged)
    }
  }
  
  private func buildRxDataSource(item: FormItemCompositeProtocol) -> [RxSectionModel] {
    /// Sections
    var sections: [RxSectionModel] = []
    for section in item.datasource {
      if let sectionModel = section as? SectionFormComposite {
         sections.append(RxSectionModel(item: sectionModel))
      }
    }
    
    return sections
  }
}
