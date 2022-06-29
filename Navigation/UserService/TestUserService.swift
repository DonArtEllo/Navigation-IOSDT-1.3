//
//  TestUserService.swift
//  Navigation
//
//  Created by Артем on 12.06.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import UIKit

class TestUserService: UserService {
    
    let testUser = User(userEmail: "testuser@mail.com", userName: "Test User", userAvatar: #imageLiteral(resourceName: "test_avatar"))
    // Password: Test123
    
    func currentUser(userEmail: String) -> User {
        
        return testUser
    }
    
}
