//
//  ViewController.swift
//  ALFormBuilder
//
//  Created by Lobanov Aleksey on 25/10/2017.
//  Copyright © 2017 Lobanov Aleksey. All rights reserved.
//

import UIKit

enum TestCells: FBUniversalCellProtocol {
  case defaultCell, multilineCell
  
  var type: UITableViewCell.Type {
    switch self {
    case .defaultCell:
      return TestTableViewCell.self
    case .multilineCell:
      return ALFBTextMultilineViewCell.self
    }
  }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var tableView: UITableView!
  
  var item: FromItemCompositeProtocol = SectionFormComposite(composite: BaseFormComposite(identifier: "asd", level: .root))
  var fb: ALFormBuilderProtocol!
  
  let logger = Atlantis.Logger()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.item = test2()
    
    self.tableView.reloadData()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @discardableResult func test2() -> FromItemCompositeProtocol {
    let root = BaseFormComposite()
    
    // all sections
    let section1 = SectionFormComposite(composite: BaseFormComposite(identifier: "Common section", level: .section), header: "Common header", footer: "Common footer")
    let section2 = SectionFormComposite(composite: BaseFormComposite(identifier: "Settings section", level: .section), header: "Settings header", footer: "Settings footer")
    
    // all items
    /// MAIL
    let value = ALStringValue(value: "lobanov.aw@gmail.com")
    let validation = ALFB.Validation(validationType: .regexp("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"),
                                              state: .typing,
                                              valueKeyPath: "mail", errorText: "Ошибка почты", maxLength: nil)
    let base1 = ALFB.Base(cellType: TestCells.defaultCell, dataType: .string)
    
    let vsbl = ALFB.Visible(interpreter: ALInterpreterConditions())
    let vsl = ALFB.Visualization(placeholderText: "Почта",
                                          placeholderTopText: nil,
                                          detailsText: nil,
                                          isPassword: false,
                                          keyboardType: .defaultKeyboard,
                                          autocapitalizationType: .none, keyboardOptions: .none)
    
    let baseMailComposite = BaseFormComposite(identifier: "Mail row", level: .item)
    let mail = RowFormTextComposite(composite: baseMailComposite, value: value, validation: validation, visualisation: vsl, visible: vsbl, base: base1)
    
    /// PASS
    let passValue = ALStringValue(value: "1234")
    let validationPass = ALFB.Validation(validationType: .regexp("^[A-Za-z\\d$@$!%*?&_]{4,}$"), state: .typing, valueKeyPath: "common.pass", errorText: "Ошибка Пароля", maxLength: nil)
    let vsblPass = ALFB.Visible(interpreter: ALInterpreterConditions(), visible: "@model.mail == `lobanov.aw@gmail.com1`", mandatory: "true", disable: "false")
    let vslPass = ALFB.Visualization(placeholderText: "Пароль",
                                              placeholderTopText: nil,
                                              detailsText: nil,
                                              isPassword: true,
                                              keyboardType: .defaultKeyboard,
                                              autocapitalizationType: .none, keyboardOptions: .none)
    
    let base2 = ALFB.Base(cellType: TestCells.defaultCell, dataType: .string)
    
    let basePassComposite = BaseFormComposite(identifier: "Pass row", level: .item)
    let pass = RowFormTextComposite(composite: basePassComposite, value: passValue, validation: validationPass, visualisation: vslPass, visible: vsblPass, base: base2)
    
    /// PHONE
    let phoneValue = ALStringValue(value: "8480209")
    let validationPhone = ALFB.Validation(validationType: .regexp("(^$|^[+]?[0-9]{11}$)"), state: .typing, valueKeyPath: "phone", errorText: "Ошибка Phone", maxLength: nil)
    let vsblPhone = ALFB.Visible(interpreter: ALInterpreterConditions())
    let vslPhone = ALFB.Visualization(placeholderText: "Введите телефонный номер",
                                               placeholderTopText: nil,
                                               detailsText: nil,
                                               isPassword: true,
                                               keyboardType: .defaultKeyboard,
                                               autocapitalizationType: .none, keyboardOptions: .none)
    
    let base3 = ALFB.Base(cellType: TestCells.defaultCell, dataType: .string)
    
    let basePhoneComposite = BaseFormComposite(identifier: "Phone row", level: .item)
    let phone = RowFormTextComposite(composite: basePhoneComposite, value: phoneValue, validation: validationPhone, visualisation: vslPhone, visible: vsblPhone, base: base3)
    
    root.add(section1, section2)
    section1.add(mail, pass)
    section2.add(phone)
    
    logger.debug("test 2: \(root.isValid())")
    
    let fbJson = ALFormJSONBuilder(predefinedObject: [:])
    self.fb = ALFormBuilder(compositeFormData: root, jsonBuilder: fbJson)
    
    self.fb.prepareDatasource()
    logger.debug(fb.object(withoutNull: false))
    
    return root
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if let section = self.item.datasource[section] as? SectionFormComposite {
      return section.header
    } else {
      return ""
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let section = self.item.datasource[section]
    return section.datasource.count
  }
  
  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    if let section = self.item.datasource[section] as? SectionFormComposite {
      return section.footer
    } else {
      return ""
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = self.item.datasource[indexPath.section]
    if let cellModel = section.datasource[indexPath.row] as? RowFormTextComposite {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.base.cellType.type.cellIdentifier, for: indexPath)
      cell.textLabel?.text = cellModel.value.transformForDisplay()
      cell.detailTextLabel?.text = cellModel.visualisation.placeholderText
      return cell
    }
    
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = self.item.datasource[indexPath.section]
    if let cellModel = section.datasource[indexPath.row] as? RowFormTextComposite {
      if cellModel.identifier == "Mail row" {
        cellModel.validate(value: ALStringValue(value: "lobanov.aw@gmail.com1"))
      }
    }
    
    logger.debug(fb.object(withoutNull: false))
    self.tableView.reloadData()
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return self.item.datasource.count
  }
}

