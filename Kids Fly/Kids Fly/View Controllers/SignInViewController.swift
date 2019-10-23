//
//  SignInViewController.swift
//  Kids Fly
//
//  Created by Marc Jacques on 10/21/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import Foundation

enum LoginType {
    case signUp
    case signIn
}

class SignInViewController: UIViewController {
    // MARK: - Properties
    
    var apiController = APIController()
    var loginType = LoginType.signUp
    
    // MARK: = Outlets
    @IBOutlet weak var googleSignIn: UIButton!
    @IBOutlet weak var facebookSignIn: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInOrSignUpButton: UIButton!
    @IBOutlet weak var loginSignUpText: UILabel!
    @IBOutlet weak var signInOrSignUpControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleButton(button: signInOrSignUpButton)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        changeUI()
    }
    
    func styleButton(button: UIButton) {
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 3
    }
    
    @IBAction func signUpOrSignIn1(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signIn
        } else if sender.selectedSegmentIndex == 1 {
            loginType = .signUp
        }
    }
    
    @IBAction func createAccountOrSignIn(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty,
            !password.isEmpty else { return }
        
        let user = UserRepresentation(email: email, password: password)
        
        if loginType == .signUp {
            apiController.signUp(with: user, completion: { (error) in
                if let error = error {
                    NSLog("Error occurred during sign up: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Sign Up Not Successful", message: "Please try again", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true) {
                            self.changeUI()
                        }
                    }
                }
            })
        } else if loginType == .signIn {
            apiController.login(with: user, completion: { (error) in
                if let error = error {
                    NSLog("Error occurred during login: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "DashboardSegue", sender: self)
                    }
                }
            })
        }
    }
    
    func changeUI() {
        if self.loginType == .signIn {
            signInOrSignUpControl.selectedSegmentIndex = 0
            self.loginSignUpText.text = "Enter your information below to Sign In with your email or your social accounts"
            self.signInOrSignUpButton.setTitle("Sign In", for: .normal)
            self.googleSignIn.titleLabel?.text = "Sign In with Google"
            self.facebookSignIn.titleLabel?.text = "Sign In with Facebook"
        } else {
            self.loginType = .signUp
            signInOrSignUpControl.selectedSegmentIndex = 1
            self.loginSignUpText.text = "Enter your information below to Sign Up with your email or your social accounts"
            self.signInOrSignUpButton.setTitle("Sign Up", for: .normal)
            self.googleSignIn.titleLabel?.text = "Sign Up with Google"
            self.facebookSignIn.titleLabel?.text = "Sign Up with FaceBook"
        }
    }
}

// MARK: - Text Field Delegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            return true
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
}
