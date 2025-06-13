//
//  SignupViewModel.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Foundation
import FirebaseAuth

class SignupViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isSignedUp: Bool = false
    
    func signup() {
        // 입력값 확인
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "이메일과 비밀번호를 입력해주세요."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let nsError = error as? NSError {
                switch AuthErrorCode.Code(rawValue: nsError.code) {
                case .emailAlreadyInUse:
                    self.errorMessage = "이미 등록된 이메일입니다."
                case .invalidEmail:
                    self.errorMessage = "이메일 형식이 올바르지 않습니다."
                case .weakPassword:
                    self.errorMessage = "비밀번호가 너무 약합니다 (6자 이상)."
                default:
                    self.errorMessage = nsError.localizedDescription
                }
                return
            }
            
            self.errorMessage = "회원가입에 성공하셨습니다."
            self.isSignedUp = true
        }
    }
}





