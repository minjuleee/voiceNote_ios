//
//  LoginViewModel.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Foundation
import FirebaseAuth

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    
    func login() {
        // 입력값 확인
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "이메일과 비밀번호를 입력해주세요."
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let nsError = error as? NSError {
                switch AuthErrorCode.Code(rawValue: nsError.code) {
                case .userNotFound:
                    self.errorMessage = "등록되지 않은 이메일입니다."
                case .wrongPassword:
                    self.errorMessage = "비밀번호가 틀렸습니다."
                case .invalidEmail:
                    self.errorMessage = "이메일 형식이 올바르지 않습니다."
                default:
                    self.errorMessage = nsError.localizedDescription
                }
                return
            }
            
            // 로그인 성공
            self.isLoggedIn = true
        }
    }
}




