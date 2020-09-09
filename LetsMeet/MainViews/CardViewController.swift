//
//  CardViewController.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/04.
//

import UIKit
import Shuffle_iOS
import Firebase
import ProgressHUD

class CardViewController: UIViewController {
    
    //MARK: - Vars
    private let cardStack = SwipeCardStack()
    private var initialCardModels: [UserCardModel] = []
    private var secondCardModel: [UserCardModel] = []
    private var userObjects: [FUser] = []
    
    var lastDocumentSnapshot: DocumentSnapshot?
    var isInitialLoad = true
    var showReserve = false
    
    var numberOfCards = 0
    var initialLoadNumber = 3

    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createUsers()
        
        downloadInitialUsers()
    }
    
    //MARK: - Layour cards
    private func layoutCardStackView() {
        cardStack.delegate = self
        cardStack.dataSource = self
        
        view.addSubview(cardStack)
        
        cardStack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.safeAreaLayoutGuide.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    //MARK: - Download Users
    private func downloadInitialUsers() {
        
        ProgressHUD.show()
        FirebaseListner.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: initialLoadNumber, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            if allUsers.count == 0 {
                ProgressHUD.dismiss()
            }
            self.lastDocumentSnapshot = snapshot
            self.isInitialLoad = false
            self.initialCardModels = []
            
            self.userObjects = allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirebase { (didSet) in
                    let cardModel = UserCardModel(id: user.objectId, name: user.username, age: abs(user.dateOfBirth.interval(ofComponent: .year, fromDate: Date())), occupation: user.profession, image: user.avatar)
                    
                    self.initialCardModels.append(cardModel)
                    self.numberOfCards += 1
                    
                    if self.numberOfCards == allUsers.count {
                        print("reload")
                        
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                            self.layoutCardStackView()
                        }
                    }
                }
            }
            print("initial \(allUsers.count) received")
            self.downloadMoreUsersInBackground()
        }
    }
    
    private func downloadMoreUsersInBackground() {
        FirebaseListner.shared.downloadUsersFromFirebase(isInitialLoad: isInitialLoad, limit: 1000, lastDocumentSnapshot: lastDocumentSnapshot) { (allUsers, snapshot) in
            self.lastDocumentSnapshot = snapshot
            self.secondCardModel = []
            
            self.userObjects += allUsers
            
            for user in allUsers {
                user.getUserAvatarFromFirebase { (didSet) in
                    let cardModel = UserCardModel(id: user.objectId, name: user.username, age: abs(user.dateOfBirth.interval(ofComponent: .year, fromDate: Date())), occupation: user.profession, image: user.avatar)
                    
                    self.secondCardModel.append(cardModel)
                }
            }
        }
    }
    
    //MARK: - Navigation
    private func showUserProfileFor(userId: String) {
        let profileView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ProfileTableView") as! UserProfileTableViewController
        
        profileView.userObject = getUserWithId(userId: userId)
        self.present(profileView, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    private func getUserWithId(userId: String) -> FUser? {
        for user in userObjects {
            if user.objectId == userId {
                return user
            }
        }
        return nil
    }
}

extension CardViewController: SwipeCardStackDelegate, SwipeCardStackDataSource {
    
    //MARK: - DataSource
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = UserCard()
        card.footerHeight = 80
        card.swipeDirections = [.left, .right]
        
        for direction in card.swipeDirections {
            card.setOverlay(UserCardOverlay(direction: direction), forDirection: direction)
        }
        
        card.configure(withModel: showReserve ? secondCardModel[index] : initialCardModels[index])
        
        return card
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return showReserve ? secondCardModel.count : initialCardModels.count
    }
    
    //MARK: - Delegates
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        initialCardModels = []
        
        if showReserve {
            secondCardModel = []
        }
        showReserve = true
        layoutCardStackView()
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt ihndex: Int, with direction: SwipeDirection) {
        print("Swipe to", direction)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        let userId = showReserve ? secondCardModel[index].id : initialCardModels[index].id
        showUserProfileFor(userId: userId)
        
    }
}
