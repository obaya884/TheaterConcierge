//
//  MovieReviewMemoViewController.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Firebase

final class MovieReviewMemoViewController: UIViewController {

    private let firebaseManager = FirebaseManager.shared
    
    private let movieInfoArray = FirebaseManager.shared.movieInfoArray
    private let movieListOrder: Int = Defaults[.movieListOrder]
    
    let placeholderLabel = UILabel(frame: CGRect(x: 6.0, y: 6.0, width: 0.0, height: 0.0))
    
    @IBOutlet private var reviewTextView: UITextView!
    // 編集中のTextViewを保持する変数
    private var activeTextField: UITextView? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewTextView.delegate = self
        reviewTextView.text = movieInfoArray[movieListOrder].reviewMemo
        
        // TextViewにプレースホルダーを付ける
        placeholderLabel.text = "映画はどうでしたか？\n感想を書いてみましょう。"
        placeholderLabel.sizeToFit()  // 省略不可
        placeholderLabel.textColor = UIColor.gray
        reviewTextView.addSubview(placeholderLabel)
        placeholderLabel.isHidden = reviewTextView.text.isEmpty ? false : true
        
        // TextViewのキーボードにDONEボタンを付ける
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(commitButtonTapped))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        reviewTextView.inputAccessoryView = toolBar
        
        reviewTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Notificationを設定する
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func commitButtonTapped() {
        self.view.endEditing(true)
    }
    
    // 画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }

}

extension MovieReviewMemoViewController: UITextViewDelegate {
    
    // 入力がある場合はプレースホルダーを非表示にする
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = textView.text.isEmpty ? false : true
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // 編集対象のTextFieldを保存する
        activeTextField = textView
        return true
    }
    
    // 編集終了後に更新内容をfirestoreにポスト
    func textViewDidEndEditing(_ textView: UITextView) {
        let preMovieInfo = movieInfoArray[movieListOrder]
        let reviewEditedMovieInfo = MovieInformation(
                                        movieTitle: preMovieInfo.movieTitle,
                                        appreciationDate: preMovieInfo.appreciationDate,
                                        appreciationTime: preMovieInfo.appreciationTime,
                                        theaterName: preMovieInfo.theaterName,
                                        sheetNumber: preMovieInfo.sheetNumber,
                                        confirmationNumber: preMovieInfo.confirmationNumber,
                                        reviewMemo: textView.text)
        firebaseManager.updateReviewMemo(movieInfo: reviewEditedMovieInfo)
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
