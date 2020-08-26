//
//  RegisterViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/26.
//

import UIKit

class RegisterViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailtextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var genderSegmentOutlet: UISegmentedControl!
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - IBActions
    @IBAction func backButtonPressed(_ sender: Any) {
    }
    @IBAction func registerButtonPressed(_ sender: Any) {
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
    
}
