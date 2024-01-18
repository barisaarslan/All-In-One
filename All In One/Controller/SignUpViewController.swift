//
//  SignUpViewController.swift
//  All In One
//
//  Created by Barış Arslan on 12.09.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var errorMesagge = ""
    var alertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        
        
        if let email = email, let password = password, let confirmPassword = confirmPassword {
            
            if checkRegisterInfo(email: email, password: password, confirmPassword: confirmPassword) {
                
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    if let error = error {
                        
                        self.presentAlert(title: "Warning", message: error.localizedDescription, cancelButtonTitle: "Cancel")
                        
                    } else {
                        print("kayıt başarılı")
                        
                        
                        if let user = Auth.auth().currentUser {
                            
                            user.sendEmailVerification(completion: { (error) in
                                if let error = error {
                                    print("E-posta doğrulama e-postası gönderme hatası: \(error.localizedDescription)")
                                } else {
                                    print("E-posta doğrulama e-postası gönderildi.")
                                    self.presentAlert(title: "Success", message: "Confirmation e-mail has been sent to the address", cancelButtonTitle: "Okey")
                                    // Kullanıcıyı bilgilendirin
                                }
                            })
                        }
                        
                        
                    }
                }
            }else {
                presentAlert(title: "Warning", message: errorMesagge, preferredStyle: .alert, cancelButtonTitle: "Kapat", isTextFieldAvaible: false)
                
            }
            
        }else {
            print("error")
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

extension SignUpViewController {
    
    //MARK: - Girilen kullanıcı bilgilerin doğru formatta olup olmadığını kontrol eden metodlar
    
    //Regex kullanılarak girilen email'in email formatında olup olmadığını kontrol eder ve girilen iki password'ün aynı olup olmadığını kontrol eder
    
    func checkRegisterInfo(email: String, password: String, confirmPassword: String) -> Bool{
        errorMesagge = ""
        var bolen: Bool
        bolen = isEmailValid(email: email)
        if bolen == false {
            errorMesagge += "Email is not valid format"
            return false
        } else if !isPasswordValid(password: password, confirmEmail: confirmPassword){
            errorMesagge += "Passwords not equal"
            return false
        }else {
            return true
        }
    }
    
    func isEmailValid(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isPasswordValid(password: String, confirmEmail: String) -> Bool{
        if password == confirmEmail{
            return true
        }else {
            return false
        }
    }
}

extension SignUpViewController{
    //MARK: - UI Alert Controller'ları oluşturup kullanıcıya gösteren metodlar
    
    //buradaki present alert fonksiyonu istenilen şekile göre özelleştirilmiştir. Normal bir hata mesajı yazdırmanın dışında içine opsiyonel olarak bir text field ve bu text field'ın yazısını kontrol etmek için bir handler yollanabilir
    
    func presentAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert, defaultButtonTitle: String? = nil,  cancelButtonTitle: String?, isTextFieldAvaible: Bool = false,defaultButtonHandler: ((UIAlertAction) -> Void)? = nil){
        
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: preferredStyle)
        
        if defaultButtonTitle != nil{
            let defaultButton = UIAlertAction(title: defaultButtonTitle, style: .default, handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
        
        
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        
        if isTextFieldAvaible{
            alertController.addTextField()
        }
        
        
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
        
    }
}
