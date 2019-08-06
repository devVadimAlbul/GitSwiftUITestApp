import SwiftUI
import Combine

protocol ApiRequest {
  associatedtype Response: Decodable
  
  var urlRequest: URLRequest { get }
}


protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: ApiRequest
}

class APIService: APIServiceType {
  
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, Error> where Request: ApiRequest {
  
        var request = request.urlRequest
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decorder = JSONDecoder()
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: request)
            .breakpoint(receiveSubscription: {
                       print("#APIService receiveSubscription", $0)
                       return false
                     }, receiveOutput: { (data, urlResponse) -> Bool in
                       print("#APIService receiveOutput", data.toJSON(), urlResponse)
                        return false
                     }, receiveCompletion: {
                       print("#APIService receiveCompletion", $0)
                       return false
                     })
            .map { data, urlResponse in data }
            .mapError { _ in ApiError.dataNotFound }
            .decode(type: Request.Response.self, decoder: decorder)
            .print("#Response")
            .mapError({$0})
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
