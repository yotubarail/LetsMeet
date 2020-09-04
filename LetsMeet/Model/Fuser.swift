//
//  Fuser.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/08/26.
//

import Foundation
import Firebase
import UIKit

class Fuser: Equatable {
    static func == (lhs: Fuser, rhs: Fuser) -> Bool {
        lhs.objectId == rhs.objectId
    }
    
    let objectId: String
    var email: String
    var username: String
    var dateOfBirth: Date
    var isMale: Bool
    var avatar: UIImage?
    var profession: String
    var jobTitle: String
    var about: String
    var city: String
    var country: String
    var height: Double
    var lookingFor: String
    var avatarLink: String
    
    var likedIdArray: [String]?
    var imageLinks: [String]?
    let registeredDate = Date()
    var pushId: String?
    
    var userDictionary: NSDictionary {
        return NSDictionary(objects: [
            self.objectId,
            self.email,
            self.username,
            self.dateOfBirth,
            self.isMale,
            self.profession,
            self.jobTitle,
            self.about,
            self.city,
            self.country,
            self.height,
            self.lookingFor,
            self.avatarLink,
            self.likedIdArray ?? [],
            self.imageLinks ?? [],
            self.registeredDate,
            self.pushId ?? ""
        ], forKeys: [kOBJECTID as NSCopying,
                     kEMAIL as NSCopying,
                     kUSERNAME as NSCopying,
                     kDATEOFBIRTH as NSCopying,
                     kISMALE as NSCopying,
                     kPROFESSION as NSCopying,
                     kJOBTITLE as NSCopying,
                     kABOUT as NSCopying,
                     kCITY as NSCopying,
                     kCOUNTRY as NSCopying,
                     kHEIGHT as NSCopying,
                     kLOOKINGFOR as NSCopying,
                     kAVATARLINK as NSCopying,
                     kLIKEDIDARRAY as NSCopying,
                     kIMAGELINKS as NSCopying,
                     kREGISTEREDDATE as NSCopying,
                     kPUSHID as NSCopying])
    }
    
    
    //MARK: - Inits
    
    init(_objectId: String, _email: String, _username: String, _city: String, _dateOfBirth: Date, _isMale: Bool, _avatarLink: String = "") {
        objectId = _objectId
        email = _email
        username = _username
        dateOfBirth = _dateOfBirth
        isMale = _isMale
        profession = ""
        jobTitle = ""
        about = ""
        city = _city
        country = ""
        height = 0.0
        lookingFor = ""
        avatarLink = _avatarLink
        likedIdArray = []
        imageLinks = []
    }
    
    init(_dictionary: NSDictionary) {
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        email = _dictionary[kEMAIL] as? String ?? ""
        username = _dictionary[kUSERNAME] as? String ?? ""
        
        isMale = _dictionary[kISMALE] as? Bool ?? true
        profession = _dictionary[kPROFESSION] as? String ?? ""
        jobTitle = _dictionary[kJOBTITLE] as? String ?? ""
        about = _dictionary[kABOUT] as? String ?? ""
        city = _dictionary[kCITY] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        height = _dictionary[kHEIGHT] as? Double ?? 0.0
        lookingFor = _dictionary[kLOOKINGFOR] as? String ?? ""
        avatarLink = _dictionary[kAVATARLINK] as? String ?? ""
        likedIdArray = _dictionary[kLIKEDIDARRAY] as? [String]
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        
        if let date = _dictionary[kDATEOFBIRTH] as? Timestamp {
            dateOfBirth = date.dateValue()
        } else {
            dateOfBirth = _dictionary[kDATEOFBIRTH] as? Date ?? Date()
        }
        let placeHolder = isMale ? "mPlaceholder" : "fPlaceholder"
        avatar = UIImage(contentsOfFile: fileInDocumentDirectory(filename: self.objectId)) ?? UIImage(named: placeHolder)
    }
    
    //MARK: - Returning current user
    class func currentID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser()-> Fuser? {
        if Auth.auth().currentUser != nil {
            if let userDictionary = userDefaults.object(forKey: kCURRENTUSER) {
                return Fuser(_dictionary: userDictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    func getUserAvatarFromFirebase(completion: @escaping (_ didset: Bool) -> Void) {
        FileStorage.downloadImage(imageUrl: self.avatarLink) { (avatarImage) in
            let placeHolder = self.isMale ? "mPlaceholder" : "fPlaceholder"
            self.avatar = avatarImage ?? UIImage(named: placeHolder)
            completion(true)
        }
    }
    
    //MARK: - Login
    
    class func loginUserWith(email: String, password: String,completion: @escaping(_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    FirebaseListner.shared.downloadCurrentUserFromFirebase(userId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    print("メール確認できない")
                    completion(error, false)
                }
            } else {
                completion(error,false)
            }
        }
    }
    
    //MARK: - register
    
    class func registerUserWith(email: String, password: String, userName: String, city: String, isMale: Bool, dateOfBirth: Date, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
           
            completion(error)
            
            if error == nil {
                authData!.user.sendEmailVerification { error in
                    print("auth email verification sent", error?.localizedDescription)
                }
                if authData?.user != nil {
                    let user = Fuser(_objectId: authData!.user.uid, _email: email, _username: userName, _city: city, _dateOfBirth: dateOfBirth, _isMale: isMale)
                    
                    user.saveUserLobally()
                }
            }
        }
    }
    
    //MARK: - Edit User profile
    func updateUserEmail(newEmail: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
            Fuser.resendVerificationEmail(email: newEmail) { (error) in
                
                }
            completion(error)
        })
    }
    
    //MARK: - Resend Links
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: {(error) in
            Auth.auth().currentUser?.sendEmailVerification(completion: {(error) in
                completion(error)
            })
        })
    }
    
    class func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) {(error) in
            completion(error)
        }
    }
    
    //MARK: - logout currentuser
    class func logoutCurrentUser(completion: @escaping (_ error: Error? ) -> Void) {
        
        do {
            try Auth.auth().signOut()
            userDefaults.removeObject(forKey: kCURRENTUSER)
            userDefaults.synchronize()
            completion(nil)
        } catch let error as NSError {
            completion(error)
        }
            
    }
    
    //MARK: - save user funcs
    
    func saveUserLobally() {
        userDefaults.setValue(self.userDictionary as! [String: Any], forKey: kCURRENTUSER)
        userDefaults.synchronize()
    }
    
    func saveUserToFirestore() {
        FirebaseReference(.User).document(self.objectId).setData(self.userDictionary as! [String : Any]) {(error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}
