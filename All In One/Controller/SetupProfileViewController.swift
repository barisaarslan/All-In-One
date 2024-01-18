//
//  SetupProfileViewController.swift
//  All In One
//
//  Created by Barış Arslan on 12.09.2023.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class SetupProfileViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var mailLabel: UILabel!
    
    @IBOutlet weak var userNameSurNameTextField: UITextField!
    
    var userEmail: String?
    var userNameSurName: String?
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.navigationItem.hidesBackButton = true//giriş yapıldıktan sonra navigation bar'daki geri buttonuyla geri gelinemesin diye saklanıyor
        
        if user != nil {
            print("Kullanıcı oturum açtı")
            
        } else {
            print("Kullanıcı oturum açmadı")
        }
        
        mailLabel.text! += user?.email ?? ""
        

    }
    
    
    @IBAction func saveDataButton(_ sender: UIButton) {
                
        
        if let name = userNameSurNameTextField.text {
            
            if let userID = user?.uid{
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(userID) // Kullanıcının UID'siyle belge oluşturun

                // Kullanıcı adını yeni belgenin içine ekleyin
                userRef.setData(["isim": name]) { error in
                    if let error = error {
                        // Belgeyi oluştururken hata oluştu
                        print("Belge oluşturma hatası: \(error.localizedDescription)")
                    } else {
                        // Belge başarıyla oluşturuldu
                        print("Belge başarıyla oluşturuldu.")
                    }
                }
            }
//            performSegue(withIdentifier: "goToAccount2", sender: nil)
  
            
            
            
            
            
            
            // Veri eklemek
//            let userRef = db.collection("users").document("1")
//            userRef.setData(["name": "John", "email": "john@example.com"])

        }else {
            print("HATA")
        }
        
        // Firestore veritabanı referansı alın


//         Veriyi güncellemek
//        userRef.updateData(["name": "Jane"])

        // Veriyi silmek
//        userRef.delete()
        
    }
    
    
    
    @IBAction func logoutButton(_ sender: UIButton) {
       
        
//        var ref: DocumentReference? = nil
//        ref = AppDelegate.shared.  db.collection("users").addDocument(data: [
//            "first": "Ada",
//            "last": "Lovelace",
//            "born": 1815
//        ]) { err in
//            if let err = err {
//                print("Error adding document: \(err)")
//            } else {
//                print("Document added with ID: \(ref!.documentID)")
//            }
//        }
        
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("çıkış yapıldı")
            self.navigationController?.popToRootViewController(animated: true) // ilk view controller'a geri döndürür

        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
        
    }
    
}
