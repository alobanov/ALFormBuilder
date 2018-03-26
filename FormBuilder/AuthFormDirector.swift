//
//  AuthFormModelDirector.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class AuthFormDirector {
  
  let interpreter = ALInterpreterConditions()
  
  func decimalField(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALFloatValue(value: 34.5, maximumFractionDigits: 2))
    let validation = ALFBClosureValidation(closure: { value -> Bool in
      let number = Float(value ?? "") ?? 0.0
      if number > 10.0 {
        return true
      }
      return false
    }, error: "Неверное значение") //
    builder.defineValidation(validationType: .closure(validation),
                             validateAtCreation: true,
                             valueKeyPath: "decimal", errorText: "Ошибка", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: "decimal", level: .item, dataType: .decimal)
    builder.defineVisualization(placeholderText: "Число", placeholderTopText: "Введите число",
                                detailsText: "Например 1.0", isPassword: false,
                                keyboardType: .numbersAndPunctuation, autocapitalizationType: .none, keyboardOptions: .onlyDecimals(maxFractionDigits: 2))
  }
  
  func decimalField2(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALFloatValue(value: 34.5, maximumFractionDigits: 2))
    builder.defineValidation(validationType: .none,
                             validateAtCreation: false,
                             valueKeyPath: "decimal2", errorText: "Ошибка", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: "@model.decimal == <null> || @model.decimal < @model.decimal2")
    builder.defineBase(cellType: ALFBCells.textField, identifier: "decimal2", level: .item, dataType: .decimal)
    builder.defineVisualization(placeholderText: "Число", placeholderTopText: "Введите число",
                                detailsText: "Например 1.0", isPassword: false,
                                keyboardType: .numbersAndPunctuation, autocapitalizationType: .none, keyboardOptions: .onlyDecimals(maxFractionDigits: 2))
  }
  
  func intField(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALIntValue(value: 34))
    builder.defineValidation(validationType: .nonNil,
                             validateAtCreation: true,
                             valueKeyPath: "int", errorText: "Ошибка", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: "int", level: .item, dataType: .integer)
    builder.defineVisualization(placeholderText: "Число", placeholderTopText: "Введите число",
                                detailsText: "Например 1", isPassword: false,
                                keyboardType: .numbersAndPunctuation, autocapitalizationType: .none, keyboardOptions: .onlyNumbers)
  }
  
  func mail(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: nil))
    builder.defineValidation(validationType: .regexp("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"),
                             validateAtCreation: true, valueKeyPath: "mail", errorText: "Ошибка почты", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: "@model.decimal > 32")
    builder.defineBase(cellType: ALFBCells.textField, identifier: "Mail", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Почта", placeholderTopText: "Введите почту",
                                detailsText: "Например example@gmail.com", isPassword: false,
                                keyboardType: .emailAddress, autocapitalizationType: .none, keyboardOptions: .removeWhitespaces)
  }
  
  func pass(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: nil))
    builder.defineValidation(validationType: .regexp("^[A-Za-z\\d$@$!%*?&_]{4,}$"),
                             validateAtCreation: false, valueKeyPath: "pass", errorText: "Ошибка пароля", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: "Pass", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Пароль", placeholderTopText: "Пароль",
                                detailsText: "Должен быть длиннее 4 семволов", isPassword: true,
                                keyboardType: .defaultKeyboard, autocapitalizationType: .none, keyboardOptions: .removeWhitespaces)
  }
  
  func phone(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: nil))
    builder.defineValidation(validationType: .regexp("(^$|^[+]?[0-9]{11}$)"),
                             validateAtCreation: false, valueKeyPath: "phone", errorText: "Ошибка телефона", maxLength: 11)
    builder.defineVisible(interpreter: interpreter, visible: "@model.mail != null",
                          mandatory: "@model.mail == `al@al.ru`", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.textField, identifier: "Phone", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Введите телефонный номер", placeholderTopText: "Введите телефонный номер",
                                detailsText: "Например 89634480209", isPassword: false,
                                keyboardType: .phonePad, autocapitalizationType: .none, keyboardOptions: .phoneNumber)
  }
  
  func login(builder: ButtonRowItemBuilderProtocol) {
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true",
                          disable: ALFB.Condition.fullValidation, valid: nil)
    builder.define(title: "Войти")
    builder.defineBase(cellType: ALFBCells.buttonField, identifier: "loginbtn", level: .item, dataType: .button)
  }
  
  func agreements(builder: BoolRowItemBuilderProtocol) {
    builder.defineBase(cellType: ALFBCells.boolField, identifier: "Agreements", level: .item, dataType: .bool)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineValidation(validationType: .none, validateAtCreation: false, valueKeyPath: "agreements", errorText: nil, maxLength: nil)
    builder.define(title: "Включить уведомления")
    builder.define(value: ALBoolValue(value: false))
  }
  
  func agreements2(builder: BoolRowItemBuilderProtocol) {
    builder.defineBase(cellType: ALFBCells.boolField, identifier: "Agreements2", level: .item, dataType: .bool)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineValidation(validationType: .none, validateAtCreation: false, valueKeyPath: "agreements2", errorText: nil, maxLength: nil)
    builder.define(title: "Включить уведомления 2")
    builder.define(value: ALBoolValue(value: false))
  }
  
  func town(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALTitledValue(value: nil))
    builder.defineValidation(validationType: .none, validateAtCreation: true, valueKeyPath: "area.town", errorText: "Обязательно выберите город", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.pickerField, identifier: "Town", level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "Выберите город", placeholderTopText: nil,
                                detailsText: "Нажмите на поле", isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil, keyboardOptions: .removeWhitespaces)
  }
  
  func phoneCustom(builder: PhoneRowItemBuilder) {
    builder.define(value: ALStringValue(value: "343"))
    builder.defineValidation(validationType: .phone,
                             validateAtCreation: false, valueKeyPath: "phoneCustom", errorText: "Ошибка Телефона", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.phoneField, identifier: "Phone2", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Телефон", placeholderTopText: "Введите телефон",
                                detailsText: "Например 343 355 25 90", isPassword: false,
                                keyboardType: .phonePad, autocapitalizationType: .none, keyboardOptions: .onlyNumbers)
  }
  
  func descrInfo(builder: CustomRowItemBuilderProtocol) {
    builder.define(title: "Protocols can be adopted by classes, structs and enums. Base classes and inheritance are restricted to class types. Protocols can be adopted by classes, structs and enums.")
    builder.defineBase(cellType: ALFBCells.staticText, identifier: "Descr info", level: .item, dataType: .informationContent)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "false", disable: "@model.agreements == true", valid: nil)
  }
  
  func multiline(builder: StringRowItemBuilderProtocol) {
    builder.define(value: ALStringValue(value: nil))
    builder.defineValidation(validationType: .nonNil,
                             validateAtCreation: false, valueKeyPath: "multiline", errorText: "Ошибка поля", maxLength: 100)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "true", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.multilineTextField, identifier: "Multiline", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Описание", placeholderTopText: "Введите описание",
                                detailsText: "Например example@gmail.com", isPassword: false,
                                keyboardType: .defaultKeyboard, autocapitalizationType: .sentences, keyboardOptions: .none)
  }
  
  func html(builder: StringRowItemBuilderProtocol) {
//    let html = "<!DOCTYPE html><html><body><p>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor sit amet, ante.</p></body></html>"
    let html = "<html><p>овазовfglbjnfglbjnflgbknflgkbnflkgbnldgkbndlkbndlfkbndlfk bndflbkndlfbkndlkbndlfkbndlkbndlfbkndlfkbndflkb</p><html/>"
    builder.define(value: ALStringValue(value:html))
    builder.defineValidation(validationType: .none,
                             validateAtCreation: false, valueKeyPath: "html", errorText: "Ошибка поля", maxLength: nil)
    builder.defineVisible(interpreter: interpreter, visible: "true", mandatory: "false", disable: "false", valid: nil)
    builder.defineBase(cellType: ALFBCells.htmlText, identifier: "html", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "HTML", placeholderTopText: "HTML",
                                detailsText: nil, isPassword: false,
                                keyboardType: .defaultKeyboard, autocapitalizationType: .sentences, keyboardOptions: .none)
  }
  
  func sectionFirst(builder: SectionItemBuilderProtocol) {
    builder.define(identifier: "Common section", header: "Авторизация", footer: nil)
  }
  
  func sectionSecond(builder: SectionItemBuilderProtocol) {
    builder.define(identifier: "Settings section", header: nil, footer: "123")
  }
  
  static func build() -> FormItemCompositeProtocol {
    let director = AuthFormDirector()
    
    let root = BaseFormComposite()
    
    // Sections
    let secBuilder1 = SectionItemBuilder()
    director.sectionFirst(builder: secBuilder1)
    let section1 = secBuilder1.result()
    
    let secBuilder2 = SectionItemBuilder()
    director.sectionSecond(builder: secBuilder2)
    let section2 = secBuilder2.result()
    
    // Fields
    let mail = StringRowItemBuilder()
    director.mail(builder: mail)

    let password = StringRowItemBuilder()
    director.pass(builder: password)

    let decimalField = StringRowItemBuilder()
    director.decimalField(builder: decimalField)

    let decimalField2 = StringRowItemBuilder()
    director.decimalField2(builder: decimalField2)

    let phone = StringRowItemBuilder()
    director.phone(builder: phone)

    let login = ButtonRowItemBuilder()
    director.login(builder: login)

    let agreement = BoolRowItemBuilder()
    director.agreements(builder: agreement)
    
    let agreement2 = BoolRowItemBuilder()
    director.agreements2(builder: agreement2)

    let town = StringRowItemBuilder()
    director.town(builder: town)

    let descr = CustomRowItemBuilder()
    director.descrInfo(builder: descr)

    let phone2 = PhoneRowItemBuilder()
    director.phoneCustom(builder: phone2)

    let multiline = StringRowItemBuilder()
    director.multiline(builder: multiline)
    
    let html = StringRowItemBuilder()
    director.html(builder: html)
    
    let int = StringRowItemBuilder()
    director.intField(builder: int)

    root.add(section1)
//    section1.add(decimalField.result())
    section1.add(descr.result(),
                 agreement.result(),
                 agreement2.result(),
                 mail.result(),
                 decimalField.result(),
                 decimalField2.result(),
                 int.result(),
                 phone.result(),
                 password.result(),
                 town.result(),
                 phone2.result(),
                 multiline.result())
    
//    section2.add(html.result())
    
    return root
  }
}
