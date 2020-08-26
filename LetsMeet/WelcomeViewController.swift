//
//  WelcomeViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/25.
//

import UIKit
import ProgressHUD

class WelcomeViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        setupBackgroundTouch()
    }

    //MARK: - IBActions
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if emailTextField.text != "" {
            
        } else {
            ProgressHUD.showError("メールアドレスを入力してください")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            
        } else {
            ProgressHUD.showError("すべての項目に入力してください")
        }
    }
    
    //MARK: - setup
    private func setupBackgroundTouch() {
        backgroundImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(backgroundTap))
        backgroundImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    
    private func dismissKeyboard() {
        view.endEditing(false)
    }
}

