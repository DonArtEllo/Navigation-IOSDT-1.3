//
//  LogInViewController.swift
//  Navigation
//
//  Created by Артем on 30.03.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    // MARK: Properties
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
    // MARK: - Login View Content
    // Logo Image
    private let logoImageView: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "Logo")
        
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    // Login Field
    private lazy var logInTextField: UITextField = {
        let logIn = UITextField()
        logIn.textColor = .black
        logIn.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        logIn.tintColor = UIColor(named: "ColorSet")
        logIn.autocapitalizationType = .none
        logIn.placeholder = "Email"
        logIn.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        logIn.leftViewMode = .always
    
        logIn.layer.cornerRadius = 10

        logIn.backgroundColor = .systemGray6
    
        logIn.translatesAutoresizingMaskIntoConstraints = false
        return logIn
    }()
    
    // Password Field
    private lazy var passwordTextField: UITextField = {
        let password = UITextField()
        password.textColor = .black
        password.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        password.tintColor = UIColor(named: "ColorSet")
        password.autocapitalizationType = .none
        password.isSecureTextEntry = true
        password.placeholder = "Password"
        password.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        password.leftViewMode = .always
        
        password.layer.cornerRadius = 10

        password.backgroundColor = .systemGray6
        
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
    }()
    
    private lazy var spacerForStackView: UIView = {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        spacer.backgroundColor = .lightGray
        
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()
    
    private lazy var  logInAndPasswordStackView: UIStackView = {
        let loginPasswordStack = UIStackView()
        loginPasswordStack.axis = .vertical
        loginPasswordStack.spacing = 0
        loginPasswordStack.distribution = .fillProportionally
        
        loginPasswordStack.addArrangedSubview(logInTextField)
        loginPasswordStack.addArrangedSubview(spacerForStackView)
        loginPasswordStack.addArrangedSubview(passwordTextField)
        
        spacerForStackView.widthAnchor.constraint(equalTo: loginPasswordStack.widthAnchor, multiplier: 1).isActive = true

        loginPasswordStack.backgroundColor = .systemGray6
        
        loginPasswordStack.layer.borderColor = UIColor.lightGray.cgColor
        loginPasswordStack.layer.borderWidth = 0.5
        loginPasswordStack.layer.cornerRadius = 10
        
        loginPasswordStack.translatesAutoresizingMaskIntoConstraints = false
        return loginPasswordStack
    }()
    
    // Log In Button
    private lazy var logInButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Sign In Button
    private lazy var signInButton: UIButton  = {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 10
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.darkGray, for: .selected)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: #selector(signInButtonPressed), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func logInButtonSuccessed(enteredUserEmail: String) {
        #if DEBUG
        let userService = TestUserService()
        #else
        let userService = CurrentUserService()
        #endif
        
        let profileViewController = ProfileViewController(userService: userService, userEmail: enteredUserEmail)
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
    @objc private func logInButtonPressed() {
        if let userEmail = logInTextField.text {
            if userEmail.isEmpty {
                // MARK: - S1. b) (1)
                enterEmailAlert()
                return
            }
            
            if let userPassword = passwordTextField.text {
                if userPassword.isEmpty {
                    // MARK: - S1. b) (2)
                    enterPasswordAlert()
                    return
                }

                // MARK: - S1. c) & d)
                Auth.auth().signIn(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    guard error == nil else { return strongSelf.displayError(error) }
            
                    strongSelf.logInButtonSuccessed(enteredUserEmail: userEmail)
                }
                
            } else {
                enterPasswordAlert()
            }
            
        } else {
            enterEmailAlert()
        }
    }
    
    @objc private func signInButtonPressed() {
        if let userEmail = logInTextField.text {
            if userEmail.isEmpty {
                enterEmailAlert()
                return
            }
            
            if let userPassword = passwordTextField.text {
                if userPassword.isEmpty {
                    enterPasswordAlert()
                    return
                }
                
                // MARK: - S1. a)
                Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [weak self] authResult, error in
                    guard let strongSelf = self else { return }
                    guard error == nil else { return strongSelf.displayError(error) }
            
                    let alertController = UIAlertController(title: "Success!", message: "The new user has been created successfully. Now use your email and password to enter the application", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
                    print("No login been texted")
                    }
                    alertController.addAction(okAction)
                    strongSelf.present(alertController, animated: true, completion: nil)
                }
                
            } else {
                enterPasswordAlert()
            }
            
        } else {
            enterEmailAlert()
        }
    }
    
    func enterEmailAlert() {
        let alertController = UIAlertController(title: "Who are you?", message: "Enter your email or register new account", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
        print("No login been texted")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func enterPasswordAlert() {
        let alertController = UIAlertController(title: "Password, please", message: "Enter your password", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
        print("No password been texted")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Keyboard Actions
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentSize.height = view.bounds.height - keyboardSize.height
            scrollView.contentInset.bottom =  view.bounds.height - keyboardSize.height * 1.5
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize.height = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubviews(
            logoImageView,
            logInAndPasswordStackView,
            logInButton,
            signInButton
        )
        
        let constraints = [
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            logInAndPasswordStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            logInAndPasswordStackView.heightAnchor.constraint(equalToConstant: 100),
            logInAndPasswordStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logInAndPasswordStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            logInButton.topAnchor.constraint(equalTo: logInAndPasswordStackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            signInButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.leadingAnchor.constraint(equalTo: logInButton.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: logInButton.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

extension UIViewController {
  public func displayError(_ error: Error?, from function: StaticString = #function) {
    guard let error = error else { return }
    print("ⓧ Error in \(function): \(error.localizedDescription)")
      let message = "\(error.localizedDescription)\n\n Please, try again!"
    let errorAlertController = UIAlertController(
      title: "Error",
      message: message,
      preferredStyle: .alert
    )
    errorAlertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(errorAlertController, animated: true, completion: nil)
  }
}
