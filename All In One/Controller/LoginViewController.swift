//
//  LoginViewController.swift
//  All In One
//
//  Created by Barış Arslan on 12.09.2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToAccountPage" {
//            if let destinationVC = segue.destination as? AccountViewController {
//                destinationVC.userEmail = emailTextField.text!
//            }
//        }
//    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        let loginEmail = emailTextField.text
        let loginPassword = passwordTextField.text
        
        
        if let email = loginEmail, let password = loginPassword{
            
            //girilen bilgilerin db'de bulunup bulunmadığına bakar
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                if error != nil {
                    print("giriş yapılırken bir hata oluştu")
                    print(error ?? "")
                }else{
                    
                    if let user = Auth.auth().currentUser {
                        if !user.isEmailVerified {
                            // Kullanıcı e-posta adresini doğrulamamışsa giriş yapmasına izin verme
                            print("E-posta doğrulanmadı, giriş yapılmasına izin verilmiyor.")
                        } else {
                            // Kullanıcı e-posta adresini doğrulamışsa giriş yapmasına izin ver
                            let db = Firestore.firestore()
                            let usersCollection = db.collection("users") // "users" koleksiyonuna erişin

                            // Belirli bir UID ile belgeyi sorgulayın
                            usersCollection.document(user.uid).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    // Belge bulundu, hedef kullanıcı kaydı var
                                    self?.performSegue(withIdentifier: "goToAccount", sender: nil)
                                } else {
                                    // Belge bulunamadı veya bir hata oluştu
                                    if let error = error {
                                        print("Belge sorgulama hatası: \(error.localizedDescription)")
                                    } else {
                                        self?.performSegue(withIdentifier: "goToAccountPage", sender: nil)
                                        print("Belge bulunamadı.")
                                    }
                                }
                            }
                            
                            
                            
                            print("Kullanıcı giriş yapabilir.")
                            
                        }
                    }
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
    }
    
    
}
