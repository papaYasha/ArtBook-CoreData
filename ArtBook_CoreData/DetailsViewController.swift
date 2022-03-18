//
//  DetailsViewController.swift
//  ArtBook_CoreData
//
//  Created by Macbook on 18.03.22.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var topCnsrtntMainStack: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        configTapGestureRecognizer()
        configTextField()
    }
    
    private func configTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func configTextField() {
        nameTextField.delegate = self
        authorTextField.delegate = self
        yearTextField.delegate = self
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
    }
    
}

extension DetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        topCnsrtntMainStack.constant = -200
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        topCnsrtntMainStack.constant = 40
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}
