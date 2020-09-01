//
//  FileStorage.swift
//  LetsMeet
//
//  Created by 滝浪翔太 on 2020/09/01.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

class FileStorage {
    class func uploadImage(_ image: UIImage, directory: String, completion: @escaping (_ documentLink: String?) -> Void) {
        let storageRef = storage.reference(forURL: kFILEREFERENCE).child(directory)
        let imageData = image.jpegData(compressionQuality: 0.6)
        var task: StorageUploadTask!
        
        task = storageRef.putData(imageData!, metadata: nil, completion: { ( metaData, error) in
            task.removeAllObservers()
            
            if error != nil {
                print("Error uploading Image", error!.localizedDescription)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadUrl = url else{
                    completion(nil)
                    return
                }
                print(downloadUrl.absoluteString, "に画像をアップロードしました")
                completion(downloadUrl.absoluteString)
            }
        })
    }
}
