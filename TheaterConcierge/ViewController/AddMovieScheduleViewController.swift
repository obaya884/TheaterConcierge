//
//  AddScheduleViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit

final class AddMovieScheduleViewController: UIViewController {
    
    private let firebaseManager = FirebaseManager.shared
    
    @IBOutlet private var movieTitleTextField: UITextField!
    @IBOutlet private var appreciationDateTextField: UITextField!
    @IBOutlet private var appreciationTimeTextField: UITextField!
    @IBOutlet private var theaterNameTextField: UITextField!
    @IBOutlet private var sheetNumberTextField: UITextField!
    @IBOutlet private var confirmationNumberTextField: UITextField!
    
    // 編集中のTextFieldを保持する変数
    private var activeTextField: UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        movieTitleTextField.delegate = self
        appreciationDateTextField.delegate = self
        appreciationTimeTextField.delegate = self
        theaterNameTextField.delegate = self
        sheetNumberTextField.delegate = self
        confirmationNumberTextField.delegate = self
        
        movieTitleTextField.returnKeyType = .next
        appreciationDateTextField.returnKeyType = .next
        appreciationTimeTextField.returnKeyType = .next
        theaterNameTextField.returnKeyType = .next
        sheetNumberTextField.returnKeyType = .next
        confirmationNumberTextField.returnKeyType = .done

        movieTitleTextField.keyboardType = .default
        appreciationDateTextField.keyboardType = .default
        appreciationTimeTextField.keyboardType = .default
        theaterNameTextField.keyboardType = .default
        sheetNumberTextField.keyboardType = .default
        confirmationNumberTextField.keyboardType = .numberPad
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Notificationを設定する
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebaseManager.fetchMovieInfo(){
            NotificationCenter.default.post(name: .firestoreInitialLoadingFinishNotification, object: nil)
        }
    }
    
    @IBAction func addMovieSchedule() {

        var postAvailableFlag: Bool = true

        // 日付と時刻を正規表現でマッチング
        let appreciationDate = appreciationDateTextField.text!
        let appreciationTime = appreciationTimeTextField.text!
        
        // TODO: この記法なんだ
        let dateCheckResult = appreciationDate.range(of: "^\\d{4}\\/\\d{2}\\/\\d{2}$", options: .regularExpression) != nil
        let timeCheckResult = appreciationTime.range(of: "^\\d{2}:\\d{2}$", options: .regularExpression) != nil
        
        if !dateCheckResult {
            postAvailableFlag = false
            appreciationDateTextField.backgroundColor = .red
        }
        else {
            appreciationDateTextField.backgroundColor = .white
        }
        
        if !timeCheckResult {
            postAvailableFlag = false
            appreciationTimeTextField.backgroundColor = .red
        }
        else {
            appreciationTimeTextField.backgroundColor = .white
        }
        
        // その他入力項目が空文字でないかチェック
        if movieTitleTextField.text == "" {
            postAvailableFlag = false
            movieTitleTextField.backgroundColor = .red
        }
        else {
            movieTitleTextField.backgroundColor = .white
        }
        
        if theaterNameTextField.text == "" {
            postAvailableFlag = false
            theaterNameTextField.backgroundColor = .red
        }
        else {
            theaterNameTextField.backgroundColor = .white
        }
        
        if sheetNumberTextField.text == "" {
            postAvailableFlag = false
            sheetNumberTextField.backgroundColor = .red
        }
        else {
            sheetNumberTextField.backgroundColor = .white
        }
        
        if confirmationNumberTextField.text == "" {
            postAvailableFlag = false
            confirmationNumberTextField.backgroundColor = .red
        }
        else {
            confirmationNumberTextField.backgroundColor = .white
        }
        
        if postAvailableFlag {
            let newMovieInfo = MovieInformation(movieTitle: movieTitleTextField.text!,
                                                appreciationDate: appreciationDateTextField.text!,
                                                appreciationTime: appreciationTimeTextField.text!,
                                                theaterName: theaterNameTextField.text!,
                                                sheetNumber: sheetNumberTextField.text!,
                                                confirmationNumber: confirmationNumberTextField.text!,
                                                reviewMemo: "")
            print(newMovieInfo)
            firebaseManager.postMovieInfo(movieInfo: newMovieInfo)
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension AddMovieScheduleViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 編集対象のTextFieldを保存する
        activeTextField = textField
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        let angleUpButton = UIButton()
        angleUpButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 17)
        angleUpButton.setTitle("angle-up", for: .normal)
        angleUpButton.setTitleColor(.systemBlue, for: .normal)
        angleUpButton.sizeToFit()
        angleUpButton.addTarget(self, action: #selector(tapLeft), for: .touchUpInside)
        
        let angleDownButton = UIButton()
        angleDownButton.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 17)
        angleDownButton.setTitle("angle-down", for: .normal)
        angleDownButton.setTitleColor(.systemBlue, for: .normal)
        angleDownButton.sizeToFit()
        angleDownButton.addTarget(self, action: #selector(tapRight), for: .touchUpInside)

        let left = UIBarButtonItem(customView: angleUpButton)
        let right = UIBarButtonItem(customView: angleDownButton)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDone))

        toolBar.items = [left, right, space, done]

        textField.inputAccessoryView = toolBar

        return true
    }
    
    @objc func tapDone(){
        self.view.endEditing(true)
    }

    @objc func tapLeft(){
        guard let tag = activeTextField?.tag, let nextTextField = self.view.viewWithTag(tag - 1) else{
            return
        }
        activeTextField?.resignFirstResponder()
        nextTextField.becomeFirstResponder()
    }

    @objc func tapRight(){
        guard let tag = activeTextField?.tag, let nextTextField = self.view.viewWithTag(tag + 1) else {
            return
        }
        activeTextField?.resignFirstResponder()
        nextTextField.becomeFirstResponder()
    }

    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo //この中にキーボードの情報がある
        let keyboardSize = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height //画面全体の高さ - キーボードの高さ = キーボードが被らない高さ
        let editingTextFieldY: CGFloat = (self.activeTextField?.frame.origin.y)!
        if editingTextFieldY > keyboardY - 60 {
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
                self.view.frame = CGRect(x: 0, y: self.view.frame.origin.y - (editingTextFieldY - (keyboardY - 60)), width: self.view.bounds.width, height: self.view.bounds.height)
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
}
