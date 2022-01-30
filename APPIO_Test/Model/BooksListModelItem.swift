//
//  BooksListModelItem.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 29.01.2022.
//

import Foundation

class BooksListModelItem {
    var item: BookItem?
    var title: String?
    var date: Date?
    
    init?(data: BookItem) {
        self.item = data
        self.title = data.name
        self.date = data.date
    }
}
