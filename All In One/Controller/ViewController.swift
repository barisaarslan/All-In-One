//
//  ViewController.swift
//  All In One
//
//  Created by Barış Arslan on 12.09.2023.
//
import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class ViewController: UIViewController {

    @IBOutlet weak var signupOutlet: UIButton!
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupOutlet.layer.cornerRadius = 25.0
        loginOutlet.layer.cornerRadius = 25.0
        
    }

    @IBAction func loginButton(_ sender: UIButton) {
        
    }
    
    @IBAction func signupButton(_ sender: UIButton) {
    }
}

