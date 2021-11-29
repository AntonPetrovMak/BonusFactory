
import Foundation

extension Decodable {
    
    /// Initialization for codable object
    init?(from dataDict: Any?) {
        guard let dataDict = dataDict, !(dataDict is NSNull) else { return nil }
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: dataDict, options: [])
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            self = try decoder.decode(Self.self, from: jsonData)
        } catch {
            return nil
        }
    }
    
    static func initArray(from dataDict: Any?) -> [Self]? {
        guard let dataDict = dataDict as? [Any] else { return nil }
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: dataDict, options: [.prettyPrinted])
            let items = try JSONDecoder().decode([Self].self, from: jsonData)
            return items
        } catch {
            return nil
        }
    }
    
    static func initThrowableArray(from dataDict: Any?) -> [Self]? {
        guard let dataDict = dataDict as? [Any] else { return nil }
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: dataDict, options: [.prettyPrinted])
            let items = try JSONDecoder().decode([Throwable<Self>].self, from: jsonData)
            return items.compactMap { $0.value }
        } catch {
            return nil
        }
    }
}

extension Encodable {
    
    var encodeData: Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try? encoder.encode(self)
    }
    
    var encodeString: String? {
        guard let jsonString = self.encodeData?.stringUtf8 else { return nil }
        return jsonString
    }
    
    var encodeParameters: [String: Any]? {
        guard let dict = self.encodeData?.simpleSerialize as? [String: Any] else { return nil }
        return dict
    }
    
    func printDescription() {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        if let str = try? encoder.encode(self).stringUtf8 {
            print(str)
        } else {
            print("Nothing!!!")
        }
    }
    
}

extension Data {
    var simpleSerialize: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }
    
    var stringUtf8: String? {
        return String(data: self, encoding: .utf8)
    }
}

enum Throwable<T: Decodable>: Decodable {
    case success(T)
    case failure(Error)
    
    init(from decoder: Decoder) throws {
        do {
            let decoded = try T(from: decoder)
            self = .success(decoded)
        } catch let error {
            self = .failure(error)
        }
    }
}

extension Throwable {
    var value: T? {
        switch self {
        case .failure(_):
            return nil
        case .success(let value):
            return value
        }
    }
}
