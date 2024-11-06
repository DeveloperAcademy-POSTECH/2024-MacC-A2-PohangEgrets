//
//  Empty.swift
//  AsyncC
//
//  Created by LeeWanJae on 11/6/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirebaseRepository: FirebaseRepositoryProtocol
{
    func setUserAppData(
        id: String,
        appName: String,
        epochSeconds: Int
    ) {
        let db = Firestore.firestore()
        db.collection("userAppData").document(id).setData([
            "userID": id,
            "appData": ["appName": appName, "timeStamp": epochSeconds]
        ])
    }
    
}
