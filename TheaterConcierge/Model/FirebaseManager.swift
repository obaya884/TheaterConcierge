//
//  FirebaseManager.swift
//  TheaterConcierge
//
//  Created by 大林拓実 on 2019/10/07.
//  Copyright © 2019 大林拓実. All rights reserved.
//

import Foundation
import UIKit
import Firebase

final class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    let db = Firestore.firestore().collection("Users")
    
    var movieInfoArray: [MovieInformation] = []
    var userId: String = ""
    
    // 匿名ログイン
    func anonymousLogIn(_ completion: @escaping () -> Void) {
        Auth.auth().signInAnonymously{ [unowned self](auth, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            print("login succeed")
            // UserIdを記録
            self.userId = (auth?.user.uid)!
            completion()
        }
    }
    
    // 鑑賞情報のポスト
    func postMovieInfo(movieInfo: MovieInformation) {
        var ref: DocumentReference? = nil
        
        ref = db.document(userId).collection("MovieList")
                .addDocument(data: ["MovieTitle": movieInfo.movieTitle,
                                    "AppreciationDate": movieInfo.appreciationDate,
                                    "AppreciationTime": movieInfo.appreciationTime,
                                    "TheaterName": movieInfo.theaterName,
                                    "SheetNumber": movieInfo.sheetNumber,
                                    "ConfirmationNumber": movieInfo.confirmationNumber,
                                    "ReviewMemo": movieInfo.reviewMemo])
                { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
    }
    
    // 鑑賞情報の取得
    func fetchMovieInfo(_ completion: @escaping () -> Void) {
        // 保持している鑑賞情報をリセット
        movieInfoArray.removeAll()
        
        // firestoreからデータ取得、配列に追加
        db.document(userId).collection("MovieList").order(by: "AppreciationDate", descending: true).getDocuments{ [unowned self](querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let data = document.data()
                    let movieInfo = MovieInformation(
                                        movieTitle: data["MovieTitle"] as! String,
                                        appreciationDate: data["AppreciationDate"] as! String,
                                        appreciationTime: data["AppreciationTime"] as! String,
                                        theaterName: data["TheaterName"] as! String,
                                        sheetNumber: data["SheetNumber"] as! String,
                                        confirmationNumber: data["ConfirmationNumber"] as! String,
                                        reviewMemo: data["ReviewMemo"] as! String)
                    self.movieInfoArray.append(movieInfo)
                }
            }
            completion()
        }
    }
    
    //TODO: ガチガチクエリ検索にしてるけどどこかでid取れてる方が良いのかも
    // 編集レビューの更新
    func updateReviewMemo(movieInfo: MovieInformation) {
        // 編集されたものと同一のドキュメントをクエリ検索
        db.document(userId).collection("MovieList")
            .whereField("MovieTitle", isEqualTo: movieInfo.movieTitle)
            .whereField("AppreciationDate", isEqualTo: movieInfo.appreciationDate)
            .whereField("AppreciationTime", isEqualTo: movieInfo.appreciationTime)
            .whereField("TheaterName", isEqualTo: movieInfo.theaterName)
            .whereField("SheetNumber", isEqualTo: movieInfo.sheetNumber)
            .whereField("ConfirmationNumber", isEqualTo: movieInfo.confirmationNumber)
            .getDocuments{ [unowned self](querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        // 更新
                        self.db.document(self.userId)
                            .collection("MovieList")
                            .document(document.documentID)
                            .updateData(["ReviewMemo": movieInfo.reviewMemo])
                            { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                    }
                }
        }
    }
}
