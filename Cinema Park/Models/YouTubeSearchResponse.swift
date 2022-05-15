//
//  YouTubeSearchResponse.swift
//  Cinema Park
//
//  Created by Pavel Andreev on 5/3/22.
//

import Foundation

/*
 {
etag = "8oIpKU54mfAr-DbYlx01F7zsX6o";
id =             {
 kind = "youtube#video";
 videoId = "k4j_Uw5Ot6o";
};
kind = "youtube#searchResult";
},
 */

struct YouTubeSearchResponse: Codable {
    
    let items: [VideoElement]
}

struct VideoElement: Codable {
    
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    
    let kind: String
    let videoId: String
}
