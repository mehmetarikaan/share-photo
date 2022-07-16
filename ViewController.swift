//
//  ViewController.swift
//  SharePhotoApp
//
//  Created by Mehmet Arıkan on 19.06.2022.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func girisYapTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: sifreTextField.text!) { autdataresult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata!", messageInput: error!.localizedDescription)
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        } else {
            self.hataMesaji(titleInput: "Hata", messageInput: "Email ve şifre giriniz")
        }
        
        
    }
    
    @IBAction func kayitOlTiklandi(_ sender: Any) {
        
        if emailTextField.text != "" && sifreTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: sifreTextField.text!) { authDataResult, error in
                if error != nil {
                    self.hataMesaji(titleInput: "Hata", messageInput: error!.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else { // kullanıcı adı şifre boşsa göster
            hataMesaji(titleInput: "Hata!", messageInput: "Email ve Şifre Giriniz!")
        }
    }
    
    func hataMesaji(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

