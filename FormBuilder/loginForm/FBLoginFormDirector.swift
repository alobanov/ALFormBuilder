//
//  FBLoginFormDirector.swift
//  Puls
//
//  Created by NVV on 15/12/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation

class FBLoginFormDirector {
  
  // MARK: - build
  
  static func build(email: String?) -> FormItemCompositeProtocol {
    let director = FBLoginFormDirector()
    let root = BaseFormComposite()
    
    // MARK: - requisits
    let loginSectionB = SectionItemBuilder()
    loginSectionB.define(identifier: "requisits", header: "Авторизация", footer: "Все поля помеченые звездочкой (*) являются обязательными для заполнения")
    let loginSection = loginSectionB.result()
        
    let loginField = StringRowItemBuilder()
    director.login(email, builder: loginField)
    loginSection.add(loginField.result())
    
    let password = StringRowItemBuilder()
    director.password(nil, builder: password)
    loginSection.add(password.result())
    
    // MARK: - make login
    let makeLoginSectionB = SectionItemBuilder()
    makeLoginSectionB.define(identifier: "makeLogin", header: nil, footer: nil)
    let makeLoginSection = makeLoginSectionB.result()
    
    let makeLogin = ButtonRowItemBuilder()
    director.makeLogin(builder: makeLogin)
    makeLoginSection.add(makeLogin.result())
    
    // MARK: - actions
    let actionsSectionB = SectionItemBuilder()
    actionsSectionB.define(identifier: "actions", header: nil, footer: nil)
    let actionsSection = actionsSectionB.result()
    
    let restorePassword = StringRowItemBuilder()
    director.restorePassword(builder: restorePassword)
    actionsSection.add(restorePassword.result())
    
    let register = StringRowItemBuilder()
    director.register(builder: register)
    actionsSection.add(register.result())
    
    let test1 = StringRowItemBuilder()
    director.test1(builder: test1)
    actionsSection.add(test1.result())
    
    let test2 = StringRowItemBuilder()
    director.test2(builder: test2)
    actionsSection.add(test2.result())
    
    let test3 = StringRowItemBuilder()
    director.test3(builder: test3)
    actionsSection.add(test3.result())
    
    root.add(loginSection,
             makeLoginSection,
             actionsSection)
    return root
  }

  func login(_ value: String?, builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: value))
    let validation = FBValidationClosures().phoneOrEmaliValidation()
    builder.defineValidation(validationType: .closure(validation),
                             validateAtCreation: false,
                             valueKeyPath: FBLoginModel.Fields.login,
                             errorText: "Ведите Email или телефон",
                             maxLength: 300)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: FBLoginModel.Fields.login, level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Введите Email или телефон", placeholderTopText: "Введите Email или телефон", detailsText: "Корректный формат example@domain.ru или 89123456789", isPassword: false, keyboardType: .emailAddress, autocapitalizationType: .none, keyboardOptions: .removeWhitespaces)
  }
  
  func password(_ value: String?, builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: value))
    builder.defineValidation(validationType: .regexp("^[A-Za-z\\d$@$!%*?&_]{4,}$"),
                             validateAtCreation: false,
                             valueKeyPath: FBLoginModel.Fields.password,
                             errorText: "Ведите пароль",
                             maxLength: 300)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: FBLoginModel.Fields.password, level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Введите пароль", placeholderTopText: "Пароль", detailsText: "Пароль должен содержать не менее 4 символов", isPassword: true, keyboardType: .defaultKeyboard, autocapitalizationType: .none, keyboardOptions: .none)
  }
  
  func makeLogin(builder: ButtonRowItemBuilderProtocol) {
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "true",
                          disable: ALFB.Condition.fullValidation, valid: nil)
    builder.define(title: "Войти")
    builder.defineBase(cellType: ALFBCells.buttonField, identifier: FBLoginModel.Actions.login, level: .item, dataType: .button)
  }
  
  func restorePassword(builder: StringRowItemBuilderProtocol) {
    let value = ALStringValue(value: "Забыли пароль? Восстановить")
    builder.define(value: value)
    builder.defineValidation(validationType: .none, valueKeyPath: FBLoginModel.Actions.forgotPassword, errorText: "", maxLength: nil)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: FBLoginModel.Actions.forgotPassword, level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "", placeholderTopText: nil,
                                detailsText: nil, isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }
  
  func register(builder: StringRowItemBuilderProtocol) {
    let value = ALStringValue(value: "Зарегистрируйтесь, если у вас нет аккаунта в системе")
    builder.define(value: value)
    builder.defineValidation(validationType: .none, valueKeyPath: FBLoginModel.Actions.register, errorText: "", maxLength: nil)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: FBLoginModel.Actions.register, level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "", placeholderTopText: nil,
                                detailsText: nil, isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }
  
  func test1(builder: StringRowItemBuilderProtocol) {
    let value = ALStringValue(value: "ТЕСТ 1")
    builder.define(value: value)
    builder.defineValidation(validationType: .none, valueKeyPath: "test1", errorText: "", maxLength: nil)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: "test1", level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "", placeholderTopText: nil,
                                detailsText: nil, isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }
  
  func test2(builder: StringRowItemBuilderProtocol) {
    let value = ALStringValue(value: "ТЕСТ 2")
    builder.define(value: value)
    builder.defineValidation(validationType: .none, valueKeyPath: "test2", errorText: "", maxLength: nil)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: "test2", level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "", placeholderTopText: nil,
                                detailsText: nil, isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }

  func test3(builder: StringRowItemBuilderProtocol) {
    let value = ALStringValue(value: "ТЕСТ 3")
    builder.define(value: value)
    builder.defineValidation(validationType: .none, valueKeyPath: "test3", errorText: "", maxLength: nil)
    builder.defineVisible(interpreter: ALInterpreterConditions(), visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: "test3", level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "", placeholderTopText: nil,
                                detailsText: nil, isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }
  
}
