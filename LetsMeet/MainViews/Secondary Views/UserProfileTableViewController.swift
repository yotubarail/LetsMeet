//
//  UserProfileTableViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/08.
//

import UIKit
import SKPhotoBrowser

class UserProfileTableViewController: UITableViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var sectionOneView: UIView!
    @IBOutlet weak var sectionTwoView: UIView!
    @IBOutlet weak var sectionThreeView: UIView!
    @IBOutlet weak var sectionFourView: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicater: UIActivityIndicatorView!
    
    @IBOutlet weak var aboutTextView: UITextView!
    
    @IBOutlet weak var professionLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var lookingForLabel: UILabel!
    
    //MARK: -　Vars
    var userObject: FUser?
    var allImages: [UIImage] = []
    private let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        if userObject != nil {
            updateLikeButtonStatus()
            showUserDetails()
            loadImages()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgrounds()
        hideActivityIndicater()
    }
    
    //MARK: - IBActions
    @IBAction func dislikeButtonPressed(_ sender: Any) {
        dismissView()
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
        saveLikeToUser(userId: userObject!.objectId)
        dismissView()
    }
    
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    //MARK: -  Setup UI
    
    private func setupBackgrounds() {
        sectionOneView.clipsToBounds = true
        sectionOneView.layer.cornerRadius = 30
        sectionOneView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        sectionTwoView.layer.cornerRadius = 10
        sectionThreeView.layer.cornerRadius = 10
        sectionFourView.layer.cornerRadius = 10
    }
    
    //MARK: - Show User Profile
    private func showUserDetails() {
        aboutTextView.text = userObject!.about
        professionLabel.text = userObject!.profession
        jobLabel.text = userObject!.jobTitle
        genderLabel.text = userObject!.isMale ? "男性" : "女性"
        heightLabel.text = String(format: "%.2f", userObject!.height)
        lookingForLabel.text = userObject!.lookingFor
    }
    
    //MARK: - Activity Indicater
    private func showActivityIndicater() {
        self.activityIndicater.startAnimating()
        self.activityIndicater.isHidden = false
    }
    
    private func hideActivityIndicater() {
        self.activityIndicater.stopAnimating()
        self.activityIndicater.isHidden = true
    }
    
    //MARK: - Load Images
    private func loadImages() {
        let placeholder = userObject!.isMale ? "mPlaceholder" : "fPlaceholder"
        let avatar = userObject!.avatar ?? UIImage(named: placeholder)
        
        allImages = [avatar!]
        self.setPageControlPages()
        self.collectionView.reloadData()
        
        if userObject!.imageLinks != nil && userObject!.imageLinks!.count > 0{
            showActivityIndicater()
            
            FileStorage.downloadImages(imageUrls: userObject!.imageLinks!) { (returnedImages) in
                self.allImages += returnedImages as! [UIImage]
                
                DispatchQueue.main.async {
                    self.setPageControlPages()
                    self.hideActivityIndicater()
                    self.collectionView.reloadData()
                }
            }
        } else {
            hideActivityIndicater()
        }
    }
    
    //MARK: - Page Control
    private func setPageControlPages() {
        self.pageControl.numberOfPages = self.allImages.count
    }
    
    private func setSelectPageTo(page: Int) {
        self.pageControl.currentPage = page
    }
    
    //MARK: -SKPhotoBrowse
    private func showImages(_ images: [UIImage], startIndex: Int) {
        var SKImages: [SKPhoto] = []
        
        for image in images {
            let photo = SKPhoto.photoWithImage(image)
            SKImages.append(photo)
        }
        let browser = SKPhotoBrowser(photos: SKImages, initialPageIndex: startIndex)
        self.present(browser, animated: true, completion: nil)
    }
    
    //MARK: - Update UI
    private func updateLikeButtonStatus() {
        likeButtonOutlet.isEnabled = !(FUser.currentUser()!.likedIdArray!.contains(userObject!.objectId))
    }
    
    //MARK: - Helers
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Save Like
    private func saveLikeToUser(userId: String) {
        if let currentUser = FUser.currentUser() {
            if !(currentUser.likedIdArray!.contains(userId)) {
                currentUser.likedIdArray!.append(userId)
                currentUser.updateCurrentUserInFirestore(withValues: [kLIKEDIDARRAY: currentUser.likedIdArray!]) { (error) in
                    print("Uodated current user with error", error?.localizedDescription)
                }
            }
        }
    }
}


extension UserProfileTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        let countryCity = userObject!.country + "," + userObject!.city
        let nameAge = userObject!.username + "," + "\(abs(userObject!.dateOfBirth.interval(ofComponent: .year, fromDate: Date())))"
        
        cell.setupCell(image: allImages[indexPath.row], country: countryCity, nameAge: nameAge, indexPath: indexPath)
        
        return cell
    }
    
    
}

extension UserProfileTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showImages(allImages, startIndex: indexPath.row)
    }
}

extension UserProfileTableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 453)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        setSelectPageTo(page: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
