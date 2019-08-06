import Foundation

extension Data {
  
  func toJSON() -> Any {
    do {
      let json = try JSONSerialization.jsonObject(with: self, options: [])
      return json
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
      return [:]
    }
  }
}
