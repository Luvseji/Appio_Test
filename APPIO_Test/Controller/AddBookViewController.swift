//
//  AddBookViewController.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 29.01.2022.
//

import UIKit

class AddBookViewController: UIViewController {
    
    @IBOutlet private weak var nameBookTextField: UITextField!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var addButton: TapticButton!
    @IBOutlet private weak var addButtonConstraint: NSLayoutConstraint!
    private let addButtonHeightConstant = 30.0
    
    private var dataSource = BooksListDataModel()
    private var isUpdateMode = false
    
    var item: BookItem?
    var name: String?
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameBookTextField.delegate = self
        setup()
        
        if let _ = item, let name = name, let date = date {
            isUpdateMode = true
            nameBookTextField.text = name
            datePicker.setDate(date, animated: false)
            addButton.isEnabled = true
        } else {
            date = Date()
        }
        
        setupLocalization()
    }
    
    @IBAction func datePickerValueChangedAction(_ sender: UIDatePicker) {
        date = sender.date
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        guard dataSaved() else { return }
        self.navigationController?.popViewController(animated: true)
    }
    
}

private extension AddBookViewController {
    
    func setMaxAndMinDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        var comps = DateComponents()
        comps.month = 3
        let maxDate = calendar.date(byAdding: comps, to: Date())
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = Date()
    }
    
    func setup() {
        setMaxAndMinDatePicker()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 1, delay: 0) {
                self.addButtonConstraint.constant = keyboardHeight + self.addButtonHeightConstant
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    func keyboardWillHide() {
        UIView.animate(withDuration: 1, delay: 0) {
            self.addButtonConstraint.constant = self.addButtonHeightConstant * 2
            self.view.layoutIfNeeded()
        }
    }
    
    func recolorBorderError() {
        UIView.animate(withDuration: 0.3, delay: 0.0) {
            self.nameBookTextField.layer.cornerRadius = 5
            self.nameBookTextField.layer.borderWidth = 1
            self.nameBookTextField.layer.borderColor = UIColor.red.cgColor
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 0.2) {
                self.nameBookTextField.layer.borderWidth = 0
            }
        }
        
    }
    
    func dataSaved() -> Bool {
        guard let text = nameBookTextField.text else { return false }
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty,
              let date = date else { return false }
        guard isUpdateMode else {
            dataSource.createItem(name: text, date: date)
            return true
        }
        guard let item = item else { return false }
        dataSource.updateItem(item: item, name: text, date: date)
        return true
    }
    
    func setupLocalization() {
        self.title = isUpdateMode ? "addBookTitleEdit".localized :
        "addBookTitle".localized
        nameBookTextField.placeholder = "addBookPlaceHolder".localized
        addButton.setTitle(isUpdateMode ? "addBookButtonEdit".localized : "addBookButton".localized, for: .normal)
    }
}

// MARK: - UITextFieldDelegate

extension AddBookViewController: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "\n":
            nameBookTextField.resignFirstResponder()
        case "\t":
            return false
        case " ":
            if let text = textField.text,
               text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                recolorBorderError()
                textField.text = ""
                nameBookTextField.placeholder = "addBookPlaceHolder".localized
                return false
            }
        default: break
        }
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if !updatedText.isEmpty && updatedText[updatedText.startIndex] == " " {
                recolorBorderError()
                return false
            }
            if updatedText.isEmpty {
                addButton.isEnabled = false
            } else {
                addButton.isEnabled = true
            }
        }
        return true
    }
}
