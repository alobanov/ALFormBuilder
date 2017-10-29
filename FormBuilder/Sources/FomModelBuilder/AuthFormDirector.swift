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
                             state: .typing, valueKeyPath: "mail")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Mail", level: .item)
    builder.defineVisualization(placeholderText: "Почта", placeholderTopText: "Введите почту",
                                detailsText: "Например example@gmail.com", dataType: .string, isPassword: false,
                                errorText: "Ошибка почты",
                                keyboardType: .emailAddress, autocapitalizationType: .none)
  }
  
  func pass(builder: StringRowItemBuilderProtocol) {
    builder.define(value: StringValue(value: nil))
    builder.defineValidation(validationType: .regexp("^[A-Za-z\\d$@$!%*?&_]{4,}$"),
                             state: .typing, valueKeyPath: "pass")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Pass", level: .item)
    builder.defineVisualization(placeholderText: "Пароль", placeholderTopText: "Пароль",
                                detailsText: "Должен быть длиннее 4 семволов", dataType: .string, isPassword: true,
                                errorText: "Ошибка пароля",
                                keyboardType: .defaultKeyboard, autocapitalizationType: .none)
  }
  
  func phone(builder: StringRowItemBuilderProtocol) {
    builder.define(value: StringValue(value: nil))
    builder.defineValidation(validationType: .regexp("(^$|^[+]?[0-9]{11}$)"),
                             state: .typing, valueKeyPath: "phone")
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "@model.mail != null",
                          mandatory: "true", disable: "false")
    builder.defineBase(cellType: FormBuilderCells.editField, identifier: "Phone", level: .item)
    builder.defineVisualization(placeholderText: "Введите телефонный номер", placeholderTopText: "Введите телефонный номер",
                                detailsText: "Например 89634480209", dataType: .string, isPassword: false,
                                errorText: "Ошибка телефона",
                                keyboardType: .phonePad, autocapitalizationType: .none)
  }
  
  func login(builder: ButtonRowItemBuilderProtocol) {
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true",
                          disable: RowSettings.Visible.fullValidation)
    builder.defineBase(cellType: FormBuilderCells.buttonField, identifier: "loginbtn", level: .item)
  }
  
  func agreements(builder: BoolRowItemBuilderProtocol) {
    builder.defineBase(cellType: FormBuilderCells.boolField, identifier: "Agreements", level: .item)
    builder.defineVisible(interpreter: InterpreterConditions(), visible: "true", mandatory: "true", disable: "false")
    builder.defineVisualization(placeholderText: "Включить уведомления", placeholderTopText: nil, detailsText: nil, dataType: RowSettings.DataType.bool, isPassword: false, errorText: nil, keyboardType: .defaultKeyboard, autocapitalizationType: .none)
    builder.defineValidation(validationType: .none, state: .typing, valueKeyPath: "agreements")
    builder.define(value: BoolValue(value: false))
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
    
    let secBuilder1 = SectionItemBuilder()
    director.sectionFirst(builder: secBuilder1)
    let authSection = secBuilder1.result()
    
    let secBuilder2 = SectionItemBuilder()
    director.sectionSecond(builder: secBuilder2)
    let buttonSection = secBuilder2.result()
    
    let mail = StringRowItemBuilder()
    director.mail(builder: mail)
    
    let password = StringRowItemBuilder()
    director.pass(builder: password)
    
    let phone = StringRowItemBuilder()
    director.phone(builder: phone)
    
    let login = ButtonRowItemBuilder(title: "Войти")
    director.login(builder: login)
    
    let agreement = BoolRowItemBuilder()
    director.agreements(builder: agreement)
    
    root.add(authSection, buttonSection)
    authSection.add(mail.result(), phone.result(), password.result(), agreement.result())
    buttonSection.add(login.result())
    
    return root
  }
}
