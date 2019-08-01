import Foundation

protocol ViewModalType {
  associatedtype InputType
  associatedtype OutputType
  
  func apply(_ input: InputType)
  var output: OutputType { get }
}

