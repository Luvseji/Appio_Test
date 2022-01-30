//
//  BooksListViewController.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 28.01.2022.
//

import UIKit

class BooksListViewController: UIViewController {
    
    @IBOutlet private weak var sortButton: UIBarButtonItem!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyTitle: UILabel!
    
    private let actual = "actual"
    private let outDate = "outDate"
    
    private var isDateSort = true
    
    private var dataSource = BooksListDataModel() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private var booksList = [BooksListSectionModelItem]()
    
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsets.zero
        dataSource.delegate = self
        tableView?.delegate = self
        tableView?.dataSource = self
        
        setup()
        
        setupLocalization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource.getAllItems()
        tableView?.reloadData()
    }
    
    @IBAction func sortAction(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil,
                                                      message: nil,
                                                      preferredStyle: .actionSheet)
        
        let firstAction: UIAlertAction = UIAlertAction(title: "sortName".localized, style: .default) { action -> Void in
            self.isDateSort = false
            DispatchQueue.main.async {
                self.dataSource.getAllItems()
                self.tableView?.reloadData()
            }
        }
        let secondAction: UIAlertAction = UIAlertAction(title: "sortDate".localized, style: .default) { action -> Void in            self.isDateSort = true
            DispatchQueue.main.async {
                self.dataSource.getAllItems()
                self.tableView?.reloadData()
            }
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view
        
        present(actionSheetController, animated: true)
    }
}

private extension BooksListViewController {
    
    func updateUserElements() {
        var showElements = false
        
        if booksList.count == 1 || booksList.count == 2,
           let actual = booksList[0].items, actual.count > 1 {
            showElements = true
        } else if booksList.count == 2, let outDate = booksList[1].items, outDate.count > 1 {
            showElements = true
        }
        if !showElements {
            updateForNonBooks()
        } else {
            sortButton.isEnabled = true
            sortButton.tintColor = .systemBlue
            sortBooks()
        }
    }
    
    func sortBooks() {
        
        for (index, section) in booksList.enumerated() {
            guard var items = section.items else {  return }
            if isDateSort {
                items = items.sorted(by: { $0.date?.compare($1.date ?? Date()) == .orderedAscending })
                booksList[index].items = items
            } else {
                items = items.sorted(by: { $0.title?.compare($1.title ?? "") == .orderedAscending })
                booksList[index].items = items
            }
        }
    }
    
    func updateForNonBooks() {
        tableView.isHidden = true
        sortButton.isEnabled = false
        sortButton.tintColor = .clear
    }
    
    
    func setup() {
        tableView.register(BooksListViewCell.nib,
                           forCellReuseIdentifier: BooksListViewCell.identifier)
        
        
    }
    
    func setupLocalization() {
        emptyTitle.text = "emptyTitle".localized
        self.title = "booksListTitle".localized
    }
}

// MARK: - BooksListDataModelDelegate

extension BooksListViewController: BooksListDataModelDelegate {
    
    func didFailDataUpdateWithError(error: Error) {
        print(error)
    }
    
    func didRecieveDataUpdate(data: [BooksListModelItem]) {
        booksList = []
        var actualArr = [BooksListModelItem]()
        var outDateArr = [BooksListModelItem]()
        for book in data {
            if let date = book.date {
                let order = Calendar.current.compare(Date(),
                                                     to: date,
                                                     toGranularity: .day)
                if order == .orderedDescending {
                    outDateArr.append(book)
                    continue
                }
            }
            actualArr.append(book)
        }
            if !actualArr.isEmpty {
                booksList.append(BooksListSectionModelItem(title: actual,
                                                                items: actualArr))
            }
            if !outDateArr.isEmpty {
                booksList.append(BooksListSectionModelItem(title: outDate,
                                                                items: outDateArr))
            }
            updateUserElements()
        tableView.reloadData()
    }
}

// MARK: - Table Delegats

extension BooksListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return booksList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if booksList.count > 0 {
            tableView.isHidden = false
        }
        return booksList[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        BooksListViewCell.identifier, for: indexPath) as? BooksListViewCell,
           let items = booksList[indexPath.section].items {
            cell.configureWithItem(item: items[indexPath.row])
            if booksList[indexPath.section].title == outDate {
                cell.recolorOutDate()
            } else {
                cell.recolorActual()
            }
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: BooksListViewCell.identifier,
                                             for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let addBookVC = storyBoard.instantiateViewController(withIdentifier: "addBook")
                as? AddBookViewController else { return }
        addBookVC.item = booksList[indexPath.section].items?[indexPath.row].item
        addBookVC.name = booksList[indexPath.section].items?[indexPath.row].title
        addBookVC.date = booksList[indexPath.section].items?[indexPath.row].date
        self.navigationController?.pushViewController(addBookVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if booksList[section].title == outDate {
            return outDate.localized
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if booksList[section].title == outDate {
            return 30
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        
        if (cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins))) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        if (cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let items = booksList[indexPath.section].items,
                  let item = items[indexPath.row].item else { return }
            
            self.tableView.beginUpdates()
            if
                booksList[indexPath.section].items?.count == 1 {
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.booksList.remove(at: indexPath.section)
                let indexSet = IndexSet(arrayLiteral: indexPath.section)
                tableView.deleteSections(indexSet, with: .automatic)
                dataSource.deleteItem(item: item)
            } else {
                dataSource.deleteItem(item: item)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            self.tableView.endUpdates()        }
    }
}
