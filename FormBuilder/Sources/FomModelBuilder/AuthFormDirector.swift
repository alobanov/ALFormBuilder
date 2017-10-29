//
//  AuthFormModelDirector.swift
//  FormBuilder
//
//  Created by Lobanov Aleksey on 27/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import Foundation

class AuthFormDirector {  
  func mail(builder: StringRowItemBuilderProtocol) {
    builder.define(value: StringValue(value: nil))
    builder.defineValidation(validationType: .regexp("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"),
                             state: .typing, valueKeyPath: "mail", errorText: "Ошибка почты")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Mail", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Почта", placeholderTopText: "Введите почту",
                                detailsText: "Например example@gmail.com", isPassword: false,
                                keyboardType: .emailAddress, autocapitalizationType: .none)
  }
  
  func pass(builder: StringRowItemBuilderProtocol) {
    builder.define(value: StringValue(value: nil))
    builder.defineValidation(validationType: .regexp("^[A-Za-z\\d$@$!%*?&_]{4,}$"),
                             state: .typing, valueKeyPath: "pass", errorText: "Ошибка пароля")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Pass", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Пароль", placeholderTopText: "Пароль",
                                detailsText: "Должен быть длиннее 4 семволов", isPassword: true,
                                keyboardType: .defaultKeyboard, autocapitalizationType: .none)
  }
  
  func phone(builder: StringRowItemBuilderProtocol) {
    builder.define(value: StringValue(value: nil))
    builder.defineValidation(validationType: .regexp("(^$|^[+]?[0-9]{11}$)"),
                             state: .typing, valueKeyPath: "phone", errorText: "Ошибка телефона")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "@model.mail != null",
                          mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Phone", level: .item, dataType: .string)
    builder.defineVisualization(placeholderText: "Введите телефонный номер", placeholderTopText: "Введите телефонный номер",
                                detailsText: "Например 89634480209", isPassword: false,
                                keyboardType: .phonePad, autocapitalizationType: .none)
  }
  
  func login(builder: ButtonRowItemBuilderProtocol) {
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true",
                          disable: RowSettings.Visible.fullValidation)
    builder.define(title: "Войти")
    builder.defineBase(cellType: FormBuilderCells.buttonField, identifier: "loginbtn", level: .item, dataType: .button)
  }
  
  func agreements(builder: BoolRowItemBuilderProtocol) {
    builder.defineBase(cellType: FormBuilderCells.boolField, identifier: "Agreements", level: .item, dataType: .bool)
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineValidation(validationType: .none, state: .typing, valueKeyPath: "agreements", errorText: nil)
    builder.define(title: "Включить уведомления")
    builder.define(value: BoolValue(value: false))
  }
  
  func town(builder: StringRowItemBuilderProtocol) {
    builder.define(value: PickerValue(value: nil))
    builder.defineValidation(validationType: .none, state: .failed(message: "Выберите город"), valueKeyPath: "area.town", errorText: "Обязательно выберите город")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.pickerField, identifier: "Town", level: .item, dataType: .picker)
    builder.defineVisualization(placeholderText: "Выберите город", placeholderTopText: "Город",
                                detailsText: "Нажмите на поле", isPassword: false,
                                keyboardType: nil, autocapitalizationType: nil)
  }
  
  func descrInfo(builder: CustomRowItemBuilderProtocol) {
    builder.define(title: "Protocols can be adopted by classes, structs and enums. Base classes and inheritance are restricted to class types.")
    builder.defineBase(cellType: FormCustomCells.customField, identifier: "Descr info", level: .item, dataType: .informationContent)
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "@model.mail != null", mandatory: "false", disable: "@model.agreements == true")
  }
  
  func sectionFirst(builder: SectionItemBuilderProtocol) {
    builder.define(identifier: "Common section", header: "Авторизация", footer: "Все поля помеченые звездочко являются обязательными")
  }
  
  func sectionSecond(builder: SectionItemBuilderProtocol) {
    builder.define(identifier: "Settings section", header: "", footer: "")
  }
  
  static func build() -> FromItemCompositeProtocol {
    let director = AuthFormDirector()
    
    let root = BaseFormComposite()
    
    // Sections
    let secBuilder1 = SectionItemBuilder()
    director.sectionFirst(builder: secBuilder1)
    let authSection = secBuilder1.result()
    
    let secBuilder2 = SectionItemBuilder()
    director.sectionSecond(builder: secBuilder2)
    let buttonSection = secBuilder2.result()
    
    // Fields
    let mail = StringRowItemBuilder()
    director.mail(builder: mail)
    
    let password = StringRowItemBuilder()
    director.pass(builder: password)
    
    let phone = StringRowItemBuilder()
    director.phone(builder: phone)
    
    let login = ButtonRowItemBuilder()
    director.login(builder: login)
    
    let agreement = BoolRowItemBuilder()
    director.agreements(builder: agreement)
    
    let town = StringRowItemBuilder()
    director.town(builder: town)
    
    let descr = CustomRowItemBuilder()
    director.descrInfo(builder: descr)
    
    root.add(authSection, buttonSection)
    authSection.add(mail.result(), phone.result(), password.result(), agreement.result(), town.result())
    buttonSection.add(login.result(), descr.result())
    
    return root
  }
}
