//
//  forms.swift
//  Pods
//
//  Created by Haizhen Lee on 15/11/30.
//
//

import Foundation

public typealias BXParams = [String:AnyObject]

public class BXField{
  public let name:String
  public let valueType:String
  public var value:AnyObject?
  
  public init(name:String,valueType:String){
    self.name = name
    self.valueType = valueType
  }
  
  public static func fieldsAsParams(fields:[BXField]) -> BXParams{
    var params = BXParams()
    for field in fields{
      if let value = field.value{
        params[field.name] = value
      }
    }
    return params
  }
}

public enum ValidateError:ErrorType{
  case TextIsBlank
  case UnsupportValueType
  case WrongValueType
  case NoValue
}

public struct InvalidFieldError:ErrorType{
  let field:BXField
  let error:ValidateError
  public init(field:BXField,error:ValidateError){
    self.field = field
    self.error = error
  }
}

public struct Validators {
  public static  func checkText(text:String) throws {
    if text.isEmpty{
      throw ValidateError.TextIsBlank
    }
  }
  
  public static func checkField(field:BXField) throws {
    do{
      try checkText(field.value as! String)
    }catch let error as ValidateError{
      throw InvalidFieldError(field: field, error: error)
    }
  }
}