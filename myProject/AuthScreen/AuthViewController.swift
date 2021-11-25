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
    @IBOutlet private weak var textFieldName: UITextField!
    @IBOutlet private weak var textFieldEmail: UITextField!
    @IBOutlet private weak var textFieldPass: UITextField!
    @IBOutlet private weak var buttonSignIn: UIButton!
    @IBOutlet private weak var buttonSignUp: UIButton!
    @IBOutlet private weak var buttonRegister: UIButton!
    @IBOutlet private weak var buttonQuestion: UIButton!
    
//    var signUp: Bool = false {
//        willSet {
//            if newValue {
//                labelSignUp.text = "Регистрация"
//                labelName.isHidden = false
//                textFieldName.isHidden = false
//                buttonSignIn.isHidden = true
//                buttonSignUp.isHidden = true
//                buttonRegister.isHidden = false
//                buttonQuestion.isHidden = false
//
//            } else {
//                labelSignUp.text = "Вход"
//                labelName.isHidden = true
//                textFieldName.isHidden = true
//                buttonRegister.isHidden = true
//                buttonQuestion.isHidden = true
//                buttonSignIn.isHidden = false
//                buttonSignUp.isHidden = false
//            }
//        }
//    }
    
    var signUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        labelSignUp.text = "Вход"
        labelName.isHidden = true
        textFieldName.isHidden = true
        buttonRegister.isHidden = true
        buttonQuestion.isHidden = true
        
//        textFieldName.delegate = self
//        textFieldEmail.delegate = self
//        textFieldPass.delegate = self
    }    

    @IBAction func buttonSwitch(_ sender: Any) {
        //signUp = !signUp
        
        labelSignUp.text = "Регистрация"
        labelName.isHidden = false
        textFieldName.isHidden = false
        buttonSignIn.isHidden = true
        buttonSignUp.isHidden = true
        buttonRegister.isHidden = false
        buttonQuestion.isHidden = false
    }
    
    @IBAction func signInTap(_ sender: Any) {
        
        let email = textFieldEmail.text!
        let password = textFieldPass.text!
        
        if (!email.isEmpty && !password.isEmpty) {
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                    User.userID = result?.user.uid ?? ""
                    print(User.userID)
                }
            }
        } else {
            showAlert()
        }
    }
    
    @IBAction func registerTap(_ sender: Any) {
        
        print("Tapped")
        signUp = true
        let name = textFieldName.text!
        let email = textFieldEmail.text!
        let password = textFieldPass.text!
        //if(signUp) {
            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
                
                if(password.count >= 6 && email.contains("@mail.ru")) {
                    Auth.auth().createUser(withEmail: email, password: password) {
                        (result, error) in
                        if error == nil {
                            if let result = result {
                                print(result.user.uid)
                                let ref = Database.database().reference().child("users")
                                ref.child(result.user.uid).updateChildValues(["name": name, "email" : email])
                                self.dismiss(animated: true, completion: nil)
                                User.userID = result.user.uid
                                print(User.userID)
                            }
                        }
                    }
                    
                    labelSignUp.text = "Вход"
                    labelName.isHidden = true
                    textFieldName.isHidden = true
                    buttonRegister.isHidden = true
                    buttonQuestion.isHidden = true
                    buttonSignIn.isHidden = false
                    buttonSignUp.isHidden = false
                } else if (password.count < 6){
                    showAlertPassword()
                } else {
                    showAlertEmail()
                }
                                
            } else {
                showAlert()
                }
        //}
        
    }
    @IBAction func questionTap(_ sender: Any) {
        signUp = false
        labelSignUp.text = "Вход"
        labelName.isHidden = true
        textFieldName.isHidden = true
        buttonRegister.isHidden = true
        buttonQuestion.isHidden = true
        buttonSignIn.isHidden = false
        buttonSignUp.isHidden = false
        
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ошибка", message: "Заполните все поля", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertPassword() {
        let alert = UIAlertController(title: "Ошибка", message: "Длина пароля должна быть не менее 6 символов", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertEmail() {
        let alert = UIAlertController(title: "Ошибка", message: "Введите корректный email(например: example@mail.ru)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//extension AuthViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//
//        let name = textFieldName.text!
//        let email = textFieldEmail.text!
//        let password = textFieldPass.text!
//        if(signUp) {
//            if (!name.isEmpty && !email.isEmpty && !password.isEmpty) {
//
//                Auth.auth().createUser(withEmail: email, password: password) {
//                    (result, error) in
//                    if error == nil {
//                        if let result = result {
//                            print(result.user.uid)
//                            let ref = Database.database().reference().child("users")
//                            ref.child(result.user.uid).updateChildValues(["name": name, "email" : email])
//                            self.dismiss(animated: true, completion: nil)
//                            User.userID = result.user.uid
//                            print(User.userID)
//                        }
//                    }
//                }
//
//            } else {
//                showAlert()
//                }
//        } else {
//            if (!email.isEmpty && !password.isEmpty) {
//                Auth.auth().signIn(withEmail: email, password: password) {
//                    (result, error) in
//                    if error == nil {
//                        self.dismiss(animated: true, completion: nil)
//                        User.userID = result?.user.uid ?? ""
//                        print(User.userID)
//                    }
//                }
//            } else {
//                showAlert()
//            }
//        }
//        return true
//    }
//}
