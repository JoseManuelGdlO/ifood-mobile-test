//
//  SentimientoModelo.swift
//  HappyTweet
//
//  Created by Jose Manuel Garcia de la O on 6/9/19.
//  Copyright © 2019 Jose Manuel Garcia de la O. All rights reserved.
//

import Foundation

struct SantimientoModelo: Decodable {
    let documentSentiment: DocumentSentiment?
}

struct DocumentSentiment : Decodable {
    let score : Float
}
