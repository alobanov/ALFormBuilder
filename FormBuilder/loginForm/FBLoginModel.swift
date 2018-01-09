//
//  FBLoginModel.swift
//  Puls
//
//  Created by NVV on 15/12/2017.
//  Copyright © 2017 MOPC. All rights reserved.
//

import Foundation
import ObjectMapper

struct FBLoginModel: Mappable {
  
  struct Fields {
    static let login = "login"
    static let password = "password"
  }
  
  struct Actions {
    static let login = "loginAction"
    static let forgotPassword = "forgotPasswordAction"
    static let register = "registerAction"
  }
  
  var login =  ""
  var password = ""
  
  init?(map: Map) {}
  
  // Mappable
  mutating func mapping(map: Map) {
    login <- map[Fields.login]
    password <- map[Fields.password]
  }
  
}

