//
//  Validator.swift
//  LeagueSocial
//
//  Created by Arpit Williams on 03/04/25.
//

enum Validator {
    
    /// Checks if the user's email ends with a valid domain extension (.com, .net, or .biz).
    static func isValidEmailDomain(_ email: String) -> Bool {
        guard let ext = email.split(separator: ".").last?.lowercased() else { return false }
        return ["com", "net", "biz"].contains(ext)
    }
}
