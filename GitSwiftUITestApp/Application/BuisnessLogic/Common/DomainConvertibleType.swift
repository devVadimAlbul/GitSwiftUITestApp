import Foundation
import CoreData
import Combine

protocol DomainConvertibleType: Identifiable {
    associatedtype DomainType: Identifiable
    
    func asDomain() -> DomainType
}

protocol ApiConvertibleType: Identifiable {
    associatedtype DomainType: Identifiable
    
    init(with domain: DomainType)
}

extension Publisher where Output: Sequence, Output.Iterator.Element: DomainConvertibleType {
    typealias DomainType = Output.Iterator.Element.DomainType

    func mapToDomain() -> Publishers.Map<Self, [DomainType]> {
        return map { sequence -> [DomainType] in
            return sequence.mapToDomain()
        }
    }
}


extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias Element = Iterator.Element
  
    func mapToDomain() -> [Element.DomainType] {
        return map {
            return $0.asDomain()
        }
    }
}
