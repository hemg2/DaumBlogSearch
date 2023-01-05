//
//  DKBlog.swift
//  SearchBlog
//
//  Created by 1 on 2023/01/05.
//

import Foundation


struct DKBlog: Decodable {
    let documents: [DKDocument]
}

struct DKDocument: Decodable {
    let title: String?
    let name: String?
    let thumbnail: String?
    let datetime: Date?
    
    enum CodingKeys: String, CodingKey {
        case title, thumbnail, datetime
        case name = "blogname"
    }
    
    init(from decoder: Decoder) throws {
        let valuse = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.title = try? valuse.decode(String?.self, forKey: .title)
        self.name = try? valuse.decode(String.self, forKey: .name)
        self.thumbnail = try? valuse.decode(String.self, forKey: .thumbnail)
        self.datetime = Date.parse(valuse, key: .datetime)
    }
}


extension Date {
    static func parse<K: CodingKey>(_ valuse: KeyedDecodingContainer<K>, key: K) -> Date? {
        guard let dateString = try? valuse.decode(String.self, forKey: key),
              let date = from(dateString: dateString) else {
            return nil
        }
        return date
    }
    
    static func from(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy=MM-dd'T'HH:mm:ss.SSSXXXXX"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        if let date = dateFormatter.date(from: dateString) {
            return date
        }
        return nil
    }
}
