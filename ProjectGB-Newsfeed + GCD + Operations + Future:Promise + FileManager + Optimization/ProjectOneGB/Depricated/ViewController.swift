//
//  ViewController.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 08.10.2021.
//



import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var loginLable: UILabel!
    @IBOutlet weak var passwordLable: UILabel!
    
    func addShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 8, height: 8)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
    }
    
    func animateTitlesAppearing() {
        let offset = view.bounds.width
        loginLable.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordLable.transform = CGAffineTransform(translationX: -offset, y: 0)
        
        UIView.animate(withDuration: 0.5,
                       delay: 1,
                       options: .curveEaseOut,
                       animations: {
                           self.loginLable.transform = .identity
                           self.passwordLable.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateTitleAppearing() {
        self.titleLable.transform = CGAffineTransform(translationX: 0,
                                                     y: -self.view.bounds.height/2)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                           self.titleLable.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateLogoAppearing() {
        self.titleImage.transform = CGAffineTransform(translationX: 0,
                                                     y: -self.view.bounds.height/2)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                           self.titleImage.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateFieldsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 1
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginTextField.layer.add(fadeInAnimation, forKey: nil)
        self.passwordTextField.layer.add(fadeInAnimation, forKey: nil)
    }
    
    func animateAuthButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 1
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginButton.layer.add(animation, forKey: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animateTitlesAppearing()
        animateTitleAppearing()
        animateFieldsAppearing()
        animateAuthButton()
        animateLogoAppearing()
        
        //        распознавание жестов и скрытие клавиатуры
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.view.addGestureRecognizer(tapRecognizer)
        
        addShadow(view: loginTextField)
        addShadow(view: passwordTextField)
        addShadow(view: loginButton)
        loginButton.layer.cornerRadius = 15
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemCyan.cgColor, UIColor.systemBlue.cgColor, UIColor.systemMint.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.view.bounds
        gradientLayer.zPosition = 0
        self.view.layer.addSublayer(gradientLayer)
        
        loginButton.layer.zPosition = 1
        loginTextField.layer.zPosition = 1
        passwordTextField.layer.zPosition = 1
        titleImage.layer.zPosition = 1
        titleLable.layer.zPosition = 1
        passwordLable.layer.zPosition = 1
        loginLable.layer.zPosition = 1
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    
    //    скрываем клавиатуру
    @objc func tapFunction() {
        self.view.endEditing(true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // Проверяем данные пользователя
        let checkResult = checkUserData()
        
        // Если данные не верны, покажем ошибку
        if !checkResult {
            showLoginError()
        }
        
        // Вернем результат
        return checkResult
    }
    
    // проверяем данные пользователя
    func checkUserData() -> Bool {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return false }
        
        if !(login.isEmpty && password.isEmpty) && login == "root" && password == "123"  {
            print("Welcome %username%!")
            print("login success")
            loginTextField.backgroundColor = .systemGreen
            passwordTextField.backgroundColor = .systemGreen
            return true
        } else {
            loginTextField.backgroundColor = .systemRed
            passwordTextField.backgroundColor = .systemRed
            return false
        }
    }
    
    //    проверяем корректность ввода данных логина и пароля
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    
}

