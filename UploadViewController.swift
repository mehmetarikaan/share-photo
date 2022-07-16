//
//  UploadViewController.swift
//  SharePhotoApp
//
//  Created by Mehmet Arıkan on 20.06.2022.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var yorumTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true // kullanıcı işlem yapabilir imageview ile
        let gestureReco = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureReco)
    }
    @objc func gorselSec(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { (storagemetadata, error) in
                if error != nil {
                    self.hata(title: "Hata", message: error!.localizedDescription)
                } else {
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            if let imageURL = imageURL {
                                let firestoreDatabase = Firestore.firestore()
                                
                                let firestorePost = ["gorselurl": imageURL, "yorum": self.yorumTextField.text!, "email" : Auth.auth().currentUser!.email, "tarih": FieldValue.serverTimestamp()] as [String : Any]
                                
                                firestoreDatabase.collection("Post").addDocument(data: firestorePost) { (error) in
                                    if error != nil {
                                        self.hata(title: "hata", message: error!.localizedDescription)
                                    } else{
                                        
                                        self.yorumTextField.text = ""
                                        self.imageView.image = UIImage(named: "template")
                                        self.tabBarController?.selectedIndex = 0
                                        
                                        
                                        
                                    }
                                }
                            
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    func hata(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
