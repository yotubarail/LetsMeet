//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/31.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var educationTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    //MARK: - Vars
    
    var editingMode = false
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        updateEditingMode()
    }

    // MARK: - IBAction
    @IBAction func settingButtonPressed(_ sender: Any) {
        showEditOptions()
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showPictureOptions()
    }
    @IBAction func editButtonPressed(_ sender: Any) {
        editingMode.toggle()
        updateEditingMode()
        
        editingMode ? showKeyboard() : hideKeyboard()
        showSaveButton()
    }
    
    @objc func editUserData() {
        
    }
    
    //MARK: - Setup
    private func setupBackgrounds() {
        profileCellBackgroundView.clipsToBounds = true
        profileCellBackgroundView.layer.cornerRadius = 100
        profileCellBackgroundView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        aboutMeTextView.layer.cornerRadius = 10
    }
    
    private func showSaveButton() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editUserData))
        navigationItem.rightBarButtonItem = editingMode ? saveButton : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Editing Mode
    func updateEditingMode() {
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        educationTextField.isUserInteractionEnabled = editingMode
        genderTextField.isUserInteractionEnabled = editingMode
        cityTextField.isUserInteractionEnabled = editingMode
        countryTextField.isUserInteractionEnabled = editingMode
        heightTextField.isUserInteractionEnabled = editingMode
        lookingForTextField.isUserInteractionEnabled = editingMode
    }
    
    //MARK: - Helpers
    private func showKeyboard() {
        self.aboutMeTextView.becomeFirstResponder()
    }
    
    private func hideKeyboard() {
        self.view.endEditing(false)
    }
    
    //MARK: - AlertController
    private func showPictureOptions() {
        let alertController = UIAlertController(title: "画像の変更", message: "プロフィール画像を変えられます", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: {(alert) in
            print("Change Avatar")
        }))
        alertController.addAction(UIAlertAction(title: "アップロード", style: .default, handler: {(alert) in
            print("Upload")
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showEditOptions() {
        let alertController = UIAlertController(title: "アカウント情報の変更", message: "アカウント情報を変えられます", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "メールアドレスを変更", style: .default, handler: {(alert) in
            print("Change Email")
        }))
        alertController.addAction(UIAlertAction(title: "名前を変更", style: .default, handler: {(alert) in
            print("Name")
        }))
        alertController.addAction(UIAlertAction(title: "ログアウト", style: .destructive, handler: {(alert) in
            print("ログアウト")
        }))
        alertController.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }

}
