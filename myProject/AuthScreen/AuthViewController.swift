//
//  ViewControllerAuth.swift
//  myProject
//
//  Created by Вадим Сосновский on 02.11.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet private weak var labelSignUp: UILabel!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var labelQuestion: UILabel!
    @IBOutlet private weak var textFieldName: UITextField!
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPass: UITextField!
    @IBOutlet private weak var buttonSignIn: UIButton!
    
    var signUp: Bool = true {
        willSet {
            if newValue {
                labelSignUp.text = "Регистрация"
                labelName.isHidden = false
                textFieldName.isHidden = false
                buttonSignIn.setTitle("Войти", for: .normal)
            } else {
                labelSignUp.text = "Вход"
                labelName.isHidden = true
                textFieldName.isHidden = true
                buttonSignIn.setTitle("Регистрация", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        textFieldName.delegate = self
        textFieldEmail.delegate = self
        textFieldPass.delegate = self
    }    
    @IBAction func buttonSwitch(_ sender: Any) {
        signUp = !signUp
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let name = textFieldName.text!
        let email = textFieldEmail.text!
        let password = textFieldPass.text!
        if(signUp) {
            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                
                Auth.auth().createUser(withEmail: email, password: password) {
                    (result, error) in
                    if error == nil {
                        if let result = result {
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name": name, "email" : email])
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
            } else {
                showAlert()
                }
        } else {
            if (!email.isEmpty && !password.isEmpty) {
                Auth.auth().signIn(withEmail: email, password: password) {
                    (result, error) in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                showAlert()
            }
        }
        return true
    }
}
