//
//  BooksListDataModel.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 29.01.2022.
//

import Foundation
import UIKit

protocol BooksListDataModelDelegate: AnyObject {
    func didRecieveDataUpdate(data: [BooksListModelItem])
    func didFailDataUpdateWithError(error: Error)
}

class BooksListDataModel {
    
    weak var delegate: BooksListDataModelDelegate?
    private let context = (UIApplication.shared.delegate
                           as? AppDelegate)?.persistentContainer.viewContext
    
    func getAllItems() {
        guard let context = context else { return }
        do {
            let items = try context.fetch(BookItem.fetchRequest())
            setDataWithResponse(response: items)
        } catch {
            print("Error Info: \(error)")
        }
    }
    
    func createItem(name: String, date: Date) {
        guard let context = context else { return }
        let newItem = BookItem(context: context)
        newItem.name = name
        newItem.date = date
        do {
            try context.save()
        } catch {
            print("Error Info: \(error)")
        }
        
    }
    
    func updateItem(item: BookItem, name: String, date: Date) {
        guard let context = context else { return }
        item.name = name
        item.date = date
        do {
            try context.save()
        } catch {
            print("Error Info: \(error)")
        }
    }
    
    func deleteItem(item: BookItem) {
        guard let context = context else { return }
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error Info: \(error)")
        }
        
    }
    
    private func setDataWithResponse(response: [BookItem]) {
        var data = [BooksListModelItem]()
        for item in response {
            if let item = BooksListModelItem(data: item) {
                data.append(item)
            }
        }
        delegate?.didRecieveDataUpdate(data: data)
    }
}
