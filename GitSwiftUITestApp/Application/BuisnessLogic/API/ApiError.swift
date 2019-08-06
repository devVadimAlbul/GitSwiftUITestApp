import Foundation

struct ApiParseError: Error, Decodable, LocalizedError {
  let code = 999
  var massage: String?
  
  enum CodingKeys: String, CodingKey {
    case message
  }
  
  public init(from decoder: Decoder) throws {
     let values = try decoder.container(keyedBy: CodingKeys.self)
     massage = try values.decodeIfPresent(String.self, forKey: .message)
  }
  
  var errorDescription: String? {
    return massage ?? ApiError.dataNotParse.localizedDescription
  }
}

enum ApiError: Error {
  case networkError(Error)
  case dataNotFound
  case networkRequestError(Error?)
  case dataNotParse
}

extension ApiError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .networkError(let error):
      return error.localizedDescription
    case .dataNotFound:
      return "Not found data by request"
    case .networkRequestError(let error):
      return error?.localizedDescription ?? "Network request error"
    case .dataNotParse:
      return "Data not parsing by request."
    }
  }
}

