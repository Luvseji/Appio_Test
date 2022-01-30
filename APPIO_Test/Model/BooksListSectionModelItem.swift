//
//  BooksListSectionModelItem.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 30.01.2022.
//

import Foundation

class BooksListSectionModelItem {
    var title: String?
    var items: [BooksListModelItem]?
    
    init(title: String, items: [BooksListModelItem]) {
        self.title = title
        self.items = items
    }
}
