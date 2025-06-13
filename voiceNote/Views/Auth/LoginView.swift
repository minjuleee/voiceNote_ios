//
//  LoginView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            // 로고 이미지 (임시 시스템 아이콘으로 대체, 실제 앱에서는 이미지 자산으로 교체)
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.blue)
                .padding(.bottom, 20)
            
            // LOG IN 텍스트
            Text("LOG IN")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding(.bottom, 40)
            
            // 아이디 입력
            TextField("이메일", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 30)
            
            // 비밀번호 입력
            SecureField("비밀번호", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            
            // 로그인 버튼
            Button(action: {
                // 로그인 로직 연결
            }) {
                Text("로그인")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            
            // 회원가입 링크
            HStack {
                Text("아직 회원이 아니신가요?")
                
                NavigationLink(destination: SignupView()) {
                    Text("회원가입하기")
                        .foregroundColor(.blue)
                        .underline()
                }
            }

            .padding(.bottom, 40)
            
            Spacer()
            
            // 하단 footer
            VStack {
                Text("VoiceNote+")
                    .font(.headline)
                    .foregroundColor(.blue)
                Text("made by minjuleee")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    LoginView()
}

