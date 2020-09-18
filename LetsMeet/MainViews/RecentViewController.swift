//
//  RecentViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/16.
//

import UIKit

class RecentViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    

    //MARK: - Vars
    var recentMatches: [FUser] = []
    
    //MARK: - View lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        
        downloadMatches()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       downloadMatches()
    }
    

    //MARK: - Download
    private func downloadMatches() {
        FirebaseListener.shared.downloadUserMatches { matchedUserIds in
            if matchedUserIds.count > 0 {
                FirebaseListener.shared.downloadUsersFromFirebase(withIds: matchedUserIds) { allUsers in
                    self.recentMatches = allUsers
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            } else {
                print("no matches")
            }
        }
    }

    //MARK: - Navigation
    private func showUserProfileFor(user: FUser) {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController
        
        profileView.userObject = user
        profileView.isMatchedUser = true
        self.navigationController?.pushViewController(profileView, animated: true)
    }
}

extension RecentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}

extension RecentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recentMatches.count > 0 ? recentMatches.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewMatchCollectionViewCell
        
        if recentMatches.count > 0{
            cell.setupCell(avatarLink: recentMatches[indexPath.row].avatarLink)
        }
        return cell
    }
}

extension RecentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if recentMatches.count > 0 {
            showUserProfileFor(user: recentMatches[indexPath.row])
        }
    }
}
