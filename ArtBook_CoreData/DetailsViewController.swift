//
//  DetailsViewController.swift
//  ArtBook_CoreData
//
//  Created by Macbook on 18.03.22.
//

import UIKit
import CoreData

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
        configImageView()
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
    
    private func configImageView() {
        imageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: Constants.entityName, into: context)
        entity.setValue(nameTextField.text, forKey: Constants.keyName)
        entity.setValue(authorTextField.text, forKey: Constants.keyAuthor)
        if let year = Int(yearTextField.text!) {
            entity.setValue(year, forKey: Constants.keyYear)
        }
        entity.setValue(UUID(), forKey: Constants.keyID)

        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        entity.setValue(data, forKey: Constants.keyImage)
        do {
            try context.save()
            print("Context saved succsesfully")
        } catch {
            print(error.localizedDescription)
        }
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

extension DetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
