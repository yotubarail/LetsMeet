//
//  ProfileTableViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/31.
//

import UIKit
import Gallery
import ProgressHUD

class ProfileTableViewController: UITableViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var profileCellBackgroundView: UIView!
    @IBOutlet weak var avatarPicture: UIImageView!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var lookingForTextField: UITextField!
    
    //MARK: - Vars
    
    var editingMode = false
    var uploadingAvatar = true
    var avatarImage: UIImage?
    var garelly: GalleryController!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        setupBackgrounds()
        
        if Fuser.currentUser() != nil {
            loadUserData()
        }
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
        let user = Fuser.currentUser()!
        user.about = aboutMeTextView.text
        user.jobTitle = jobTextField.text ?? ""
        user.profession = professionTextField.text ?? ""
        user.isMale = genderTextField.text == "Male"
        user.city = cityTextField.text ?? ""
        user.country = countryTextField.text ?? ""
        user.lookingFor = lookingForTextField.text ?? ""
        user.height = Double(heightTextField.text ?? "") ?? 0.0
        
        if avatarImage != nil {
            uploadAvatar(avatarImage!) {(avatarLink) in
                user.avatarLink = avatarLink ?? ""
                user.avatar = self.avatarImage
                self.saveUserData(user: user)
                self.loadUserData()
                
            }
        } else {
            saveUserData(user: user)
            loadUserData()
        }
        editingMode = false
        updateEditingMode()
        showSaveButton()
    }
    
    private func saveUserData(user: Fuser) {
        user.saveUserLobally()
        user.saveUserToFirestore()
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
    
    //MARK: - Load UserData
    private func loadUserData() {
        let currrentUser = Fuser.currentUser()!
        nameAgeLabel.text = currrentUser.username + ", \(abs(currrentUser.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        cityCountryLabel.text = currrentUser.country + ", " + currrentUser.city
        aboutMeTextView.text = currrentUser.about != "" ? currrentUser.about : "A little bit about me..."
        jobTextField.text = currrentUser.jobTitle
        professionTextField.text = currrentUser.profession
        genderTextField.text = currrentUser.isMale ? "Male" : "Female"
        cityTextField.text = currrentUser.city
        countryTextField.text = currrentUser.country
        heightTextField.text = "\(currrentUser.height)"
        lookingForTextField.text = currrentUser.lookingFor
        avatarPicture.image = UIImage(named: "avatar")
        
        //TODO - set avatarPicture
    }
    
    //MARK: - Editing Mode
    func updateEditingMode() {
        aboutMeTextView.isUserInteractionEnabled = editingMode
        jobTextField.isUserInteractionEnabled = editingMode
        professionTextField.isUserInteractionEnabled = editingMode
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
    
    //MARK: - FileStorage
    private func uploadAvatar(_ image: UIImage, completion: @escaping (_ avatarLink: String?) -> Void) {
        ProgressHUD.show()
        let fileDirectory = "Avatars/_" + Fuser.currentID() + ".jpg"
        FileStorage.uploadImage(image, directory: fileDirectory) {(avatarLink) in
            ProgressHUD.dismiss()
            completion(avatarLink)
        }
    }
    
    private func uploadImages(images:[UIImage?]) {
        ProgressHUD.show()
    }
    
    //MARK: - Garally
    
    private func showGallery(forAvatar: Bool) {
        uploadingAvatar = forAvatar
        self.garelly = GalleryController()
        self.garelly.delegate = self
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = forAvatar ? 1 : 10
        Config.initialTab = .imageTab
        self.present(garelly, animated: true, completion: nil)
    }
    
    //MARK: - AlertController
    private func showPictureOptions() {
        let alertController = UIAlertController(title: "画像の変更", message: "プロフィール画像を変えられます", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "写真を撮る", style: .default, handler: {(alert) in
            self.showGallery(forAvatar: true)
        }))
        alertController.addAction(UIAlertAction(title: "アップロード", style: .default, handler: {(alert) in
            self.showGallery(forAvatar: false)
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

extension ProfileTableViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if images.count  > 0 {
            if uploadingAvatar {
                images.first!.resolve { (icon) in
                    if icon != nil {
                        self.editingMode = true
                        self.showSaveButton()
                        self.avatarPicture.image = icon
                        self.avatarImage = icon
                        
                    } else {
                        ProgressHUD.showError("画像が選択されていません")
                    }
                }
            } else {
                Image.resolve(images:images) { (resolvedImages) in
                    self.uploadImages(images: resolvedImages)
                }
            }
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
