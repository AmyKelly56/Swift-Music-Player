//
//  Album.swift
//  App
//
//  Created by Amy Kelly on 28/02/2017.
//  Copyright © 2017 Amy Kelly. All rights reserved.
//

import Foundation

public struct AlbumKeys
{
    static let title = "title"
    static let description = "description"
    static let coverImageName = "coverImageName"
    static let songs = "songs"
}

class Album
{
    var title: String?
    var description: String?
    var coverImageName: String?
    var songs: [String]?
    
    init(index: Int)
    {
        if index >= 0 && index < ColdplayLibrary().albums.count {
            let album = ColdplayLibrary().albums[index]
            
            title = album[AlbumKeys.title] as? String
            description = album[AlbumKeys.description] as? String
            coverImageName = album[AlbumKeys.coverImageName] as? String
            songs = album[AlbumKeys.songs] as? [String]
            
        }
    }
}
