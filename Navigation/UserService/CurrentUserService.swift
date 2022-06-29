//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Артем on 12.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class CurrentUserService: UserService {
    
    let savedUser = User(userEmail: "h4ckerk1tten@mail.com", userName: "Hacker Kitten", userAvatar: #imageLiteral(resourceName: "cat"))
    // Password: Abc124

    func currentUser(userEmail: String) -> User {
        
        if userEmail == savedUser.userEmail {
            return savedUser
        } else {
            let userNameFromEmail = userEmail.components(separatedBy: "@").first
            return User(userEmail: userEmail, userName: userNameFromEmail ?? userEmail, userAvatar: UIImage())
        }
    }
    
}
