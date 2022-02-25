//
//  JoinViewController.swift
//  Test
//
//  Created by Le Minh Hai on 23/02/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore


class JoinViewController: UIViewController {
    
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var IDCheckButton: UIButton!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var PasswordCheckTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var Birth: UIDatePicker!
    @IBOutlet weak var JoinButton: UIButton!
    @IBOutlet weak var BackButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
    }
    
    func validateFields() -> String? {
        
        if IDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            PasswordCheckTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            EmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            self.showError("Please fill in all fields")
            return "Please fill in all fields"
        }
        
        if PasswordCheckTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != PasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            self.showError("Passwork not match")
            return "Passwork not match"
        }
        
        return nil
    }
    
    @IBAction func CheckIDTapped(){
        
        let userEmail = Auth.auth().currentUser?.email
        
        if IDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == userEmail {
            
            self.showError("ID duplicate")
        } else {
            
            return self.showError("ID validate")
        }
    }
    
    @IBAction func BackTapped(){
        
        self.dismiss(animated: true)
    }
    
    @IBAction func JoinTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil {
            
            // There's something wrong with the fields, show error message
            showError(error!)
        }
        else {
            
            let ID = IDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let Password = PasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let Birth = Birth.description.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let Email = EmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: Email, password: Password) { (result, err) in
                
                if err != nil {
                    
                    // There was an error creating the user
                    self.showError("Error creating user")
                }
                else {
                    
                    // User was created successfully, now store the first name and last name
                    let db = Firestore.firestore()
                    
                    db.collection("users").addDocument(data: ["ID":ID, "Pass":Password, "E-mail":Email, "Birth":Birth, "uid": result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            // Show error message
                            self.showError("Error saving user data")
                        }
                    }
                    self.backToLogin()
                }
            }
        }
    }
    
    func showError(_ message:String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func backToLogin() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
        
    }
}
