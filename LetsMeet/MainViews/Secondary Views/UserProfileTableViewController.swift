//
//  UserProfileTableViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/08.
//

import UIKit

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
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        pageControl.hidesForSinglePage = true
        if userObject != nil {
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
    }
    @IBAction func likeButtonPressed(_ sender: Any) {
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
                self.setPageControlPages()
                
                DispatchQueue.main.async {
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
    
}
