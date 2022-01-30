//
//  BooksListViewCell.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 29.01.2022.
//

import UIKit

class BooksListViewCell: UITableViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    func configureWithItem(item: BooksListModelItem) {
       // setImageWithURL(url: item.avatarImageURL)
        guard let title = item.title, let date = item.date else { return }
        titleLabel.text = title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YY"
        dateLabel.text = dateFormatter.string(from: date)
    }
    
    func recolorOutDate() {
        dateLabel.textColor = UIColor.red
    }
    
    func recolorActual() {
        dateLabel.textColor = UIColor.black.withAlphaComponent(0.5)
    }
    
}
