//
//  SignupViewController.swift
//  InstagramApp
//
//  Created by Gwinyai on 20/1/2019.
//  Copyright © 2019 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var animatedGradientView: AnimatedGradient!

    @IBOutlet weak var scrollView: UIScrollView!

    var activeField: UITextField?

    var keyboardNotification: NSNotification?

    lazy var touchView: UIView = {

        let _touchView = UIView()

        _touchView.backgroundColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 0.0)

        let touchViewTapped = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        _touchView.addGestureRecognizer(touchViewTapped)

        _touchView.isUserInteractionEnabled = true

        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)

        return _touchView

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        signUpButton.layer.borderWidth = CGFloat(0.5)

        signUpButton.layer.borderColor = UIColor.white.cgColor

        signUpButton.layer.cornerRadius = CGFloat(3.0)

        emailTextField.delegate = self

        usernameTextField.delegate = self

        passwordTextField.delegate = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animatedGradientView.startAnimation()

        registerForKeyboardNotifications()

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        animatedGradientView.stopAnimation()

        deregisterFromKeyboardNotifications()

    }

    func registerForKeyboardNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)

    }

    func deregisterFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)

    }

    @objc func dismissKeyboard() {

        view.endEditing(true)

    }

    @objc func keyboardWasShown(notification: NSNotification) {

        view.addSubview(touchView)

        self.keyboardNotification = notification

        let info: NSDictionary = notification.userInfo! as NSDictionary

        let keyboardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size

        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: (keyboardSize!.height + 10.0), right: 0.0)

        self.scrollView.contentInset = contentInsets

        self.scrollView.scrollIndicatorInsets = contentInsets

        var aRect: CGRect = UIScreen.main.bounds

        aRect.size.height -= keyboardSize!.height

        if activeField != nil {

            if !aRect.contains(activeField!.frame.origin) {

                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)

            }

        }

    }

    @objc func keyboardWillBeHidden(notification: NSNotification) {

        touchView.removeFromSuperview()

        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero

        self.scrollView.contentInset = contentInsets

        self.scrollView.scrollIndicatorInsets = contentInsets

    }

    override var preferredStatusBarStyle: UIStatusBarStyle {

        return .lightContent

    }

    @IBAction func signUpButtonDidTouch(_ sender: Any) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        let spinner = UIViewController.displayLoading(withView: view)
        // FIXME: - Put me behind some Presenter/Controller/ViewModel. This is crazy.
        Auth.auth().createUser(withEmail: email, password: password) { /*[weak self]*/ user, error in
            //            guard let self = self else { return }
            // Check if there was an error creating the user account.
            if let error = error {
                // FIXME: - Sign up error list
                print(error.localizedDescription)
            } else {
                // User created, now login, but do not go past if you cannot get the created
                // userID after checking for error which is lame but this is how safe we are
                // used to safe code things.
                guard let userId = user?.user.uid else { return }
                Auth.auth().signIn(withEmail: email, password: password) { _, error in
                    UIViewController.removeFromLoading(spinner: spinner)
                    // Check for any login related error.
                    if let error = error {
                        print(error.localizedDescription)
                        // FIXME: This is done in login screen, abtract it and make use of DRY.
                    } else {
                        // Successful login, create user's document with set username during signup.
                        // Since we do not own firebase so we cannot pass the set username during signup.
                        let userRef = Firestore.firestore()
                            .collection("users")
                            .document(userId)
                        userRef.setData(["username": username,
                                         "bio": "welcome to my profile"], merge: true) { error in
                            // Any error creating document?
                            // Create a separate screen to force set username for user.
                            // Bad UX but ¯\_(ツ)_/¯
                            if let error = error {
                                // FIXME: - Show an alert for me later.
                                print(error.localizedDescription)
                            }
                        }
                        DispatchQueue.main.async {
                            Helper.login()
                        }
                    }
                }
            }
        }
    }

    @IBAction func alreadyHaveAnAccountButtonDidTouch(_ sender: Any) {

        dismiss(animated: true, completion: nil)

    }

}

extension SignupViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        activeField = nil

    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        activeField = textField

    }

}
