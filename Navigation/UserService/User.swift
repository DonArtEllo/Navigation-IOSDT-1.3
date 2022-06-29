//
//  UserData.swift
//  Navigation
//
//  Created by Артем on 12.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

protocol UserService {
    
    func currentUser(userEmail: String) -> User
}

class User {
    
    internal let userEmail: String
    internal let userName: String
    internal var userAvatar: UIImage
    
    init(userEmail: String,
         userName: String,
         userAvatar: UIImage) {
        
        self.userEmail = userEmail
        self.userName = userName
        self.userAvatar = userAvatar
    }
}
