//
//  PinTextField.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 23/11/2017.
//  Copyright © 2017 Syed Uzair Ahmed. All rights reserved.
//

import UIKit

//FIXME: - Controll is not complete

@IBDesignable
class PinTextField: UIStackView {
    //MARK: Properties
    private var pinTextFields = [UITextField]()

    var pinText : String {
        
        get {
            return getText()
        }
        
    }

    @IBInspectable var textFieldSize: CGSize = CGSize(width: 40.0, height: 40.0) {
        didSet {
            setupTextFields()
        }
    }

    @IBInspectable var textFieldCount: Int = 6 {
        didSet {
            setupTextFields()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextFields()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupTextFields()
    }

    private func setupTextFields() {

        // clear any existing buttons
        for textFields in pinTextFields {
            removeArrangedSubview(textFields)
            textFields.removeFromSuperview()
        }
        pinTextFields.removeAll()


        for index in 0..<textFieldCount {
            // Create the UITextField
            let textField = UITextField()

            // Set the textField
            textField.layer.borderColor = UIColor.white.cgColor
            textField.layer.borderWidth = 2
            textField.layer.masksToBounds = true
            textField.textAlignment = .center
            textField.isSecureTextEntry = true
            textField.tintColor = .white
            textField.textColor = .white
            textField.keyboardType = .alphabet

            textField.tag = index

            // Add constraints
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.heightAnchor.constraint(equalToConstant: textFieldSize.height).isActive = true
            textField.widthAnchor.constraint(equalToConstant: textFieldSize.width).isActive = true


            // Setup the button action
            textField.addTarget(self, action: #selector(PinTextField.textFieldStartEditing(textField:)), for: .editingDidBegin)
            textField.addTarget(self, action: #selector(PinTextField.textFieldEditingChanged(textField:)), for: .editingChanged)
            

            // Add the button to the stack
            addArrangedSubview(textField)

            // Add the new button to the rating button array
            pinTextFields.append(textField)
            
        }

//        updateTextFieldText()
    }

    //MARK: Button Action
    
    @objc func textFieldStartEditing(textField: UITextField) {
        guard let index = pinTextFields.index(of: textField) else {
            fatalError("The button, \(textField), is not in the ratingButtons array: \(pinTextFields)")
        }

    }

    @objc func textFieldEditingChanged(textField: UITextField) {

        if let  char = textField.text?.cString(using: String.Encoding.utf8) {

            let isBackSpace = strcmp(char, "\\b")

            if (isBackSpace == -92) {

                selcteTextField(at: (textField.tag - 1) )
                
            } else {

                let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: textField.text ?? "")

                if textField.text?.count ?? 0 <= 1 && allowedCharacters.isSuperset(of: characterSet) {
                    updateTextFieldText()
                } else {
                    textField.text = ""
                }
            }
        } else {
            updateTextFieldText()
        }
    }

    private func updateTextFieldText() {

        //        for index in 0..<textFieldCount {
        for (index, textField) in pinTextFields.enumerated(){

            //            let textField = pinTextFields[index]

            if textField.text?.isEmpty ?? true {
                textField.becomeFirstResponder()
                break
            } else {
                textField.resignFirstResponder()
            }
        }
        
    }

    private func selcteTextField(at selectIndex: Int) {

        for (index, textField) in pinTextFields.enumerated() {

            if index == selectIndex {

                textField.becomeFirstResponder()

                break
            } else {
                textField.resignFirstResponder()
            }

        }
    }

    private func getText() -> String {

        var text : String = ""
        pinTextFields.forEach { (aTextField) in
            text = text + (aTextField.text ?? "")
        }
        return text
    }
    
}
