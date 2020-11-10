//
//  Character.swift
//  MarvelMVVM
//
//  Created by Rodrigo Alejandro Velazquez Alcantara on 09/11/20.
//  Copyright © 2020 Rodrigo Alejandro Velazquez Alcantara. All rights reserved.
//

import Foundation

struct Character: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var resourceURI: String?
    var urls: [Url]?
    var thumbnail: Image?
    var comics: ComicList?
    var stories: StoryList?
    var events: EventList?
    var series: SeriesList?
}

struct Url: Codable {
    var type: String?
    var url: String?
}

struct Image: Codable {
    var path: String?
    var `extension`: String?
}

struct ComicList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [ComicSummary]?
    
    struct ComicSummary: Codable {
        var resourceURI: String?
        var name: String?
        var type: String?
    }
}

struct StoryList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [StorySummary]?
    
    struct StorySummary: Codable {
        var resourceURI: String?
        var name: String?
        var type: String?
    }
}

struct EventList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [EventSummary]?
    
    struct EventSummary: Codable {
        var resourceURI: String?
        var name: String?
    }
}

struct SeriesList: Codable {
    var available: Int?
    var returned: Int?
    var collectionURI: String?
    var items: [SeriesSummary]?
    
    struct SeriesSummary: Codable {
        var resourceURI: String?
        var name: String?
    }
}
