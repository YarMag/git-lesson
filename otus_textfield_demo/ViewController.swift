//
//  ViewController.swift
//  otus_textfield_demo
//
//  Created by Yaroslav Magin on 08.02.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var multilineInput = UITextView()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        
        datePicker.addTarget(self, action: #selector(didChangeDate(sender:)), for: .valueChanged)
        datePicker.timeZone = .current
        
        return datePicker
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter name"
        textField.keyboardType = .alphabet
        textField.textAlignment = .center
        textField.returnKeyType = .next
        textField.delegate = self
        textField.isSecureTextEntry = false
        
        return textField
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .bezel
        textField.placeholder = "Enter address"
        textField.textAlignment = .center
        textField.keyboardType = .alphabet
        textField.returnKeyType = .done
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter date:"
        textField.inputView = datePicker
        
        return textField
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // анимация на постепенный показ
        nameTextField.alpha = 0
        UIView.animate(withDuration: 3, delay: 0, options: [], animations: {
            self.nameTextField.alpha = 1
        }, completion: nil)
        
        // делаем текстфилд активным при показе экрана
        //nameTextField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        
        let backgroundTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap))
        scrollView.addGestureRecognizer(backgroundTapGestureRecognizer)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(dateTextField)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -24),
            nameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            addressTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            addressTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            addressTextField.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
            
            dateTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            dateTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            dateTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            dateTextField.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func onBackgroundTap() {
        view.endEditing(true)
    }
    
    @objc private func willShowKeyboard(notification: NSNotification) {
        print(notification.userInfo!)
        guard let frame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect else {
            return
        }
        print(frame.height)
        
        scrollView.setContentOffset(CGPoint(x: 0, y: 48), animated: true)
    }
    
    @objc private func willHideKeyboard(notification: NSNotification) {
        print("Keyboard hidden")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc private func didChangeDate(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd:MM:YYYY, HH--mm"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            return true
        }
    
        var resultString = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        if let range = resultString.range(of: "React Native") {
            resultString = resultString.replacingCharacters(in: range, with: "***** ******")
        }
        textField.text = resultString
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === nameTextField {
            addressTextField.becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}
