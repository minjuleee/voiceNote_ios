//
//  SignupView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct SignupView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            
            // 로고 이미지
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            // SIGN UP 타이틀
            Text("SIGN UP")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding(.bottom, 40)
            
            // 이름 입력
            TextField("이메일", text: $name)
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
            
            // 회원가입 버튼
            Button(action: {
                // 회원가입 로직
            }) {
                Text("회원가입")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(20)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 10)
            
            // 로그인 이동 링크
            HStack {
                Text("회원이신가요?")
                
                NavigationLink(destination: LoginView()) {
                    Text("로그인하기")
                        .foregroundColor(.blue)
                        .underline()
                }
            }

            .padding(.bottom, 40)
            
            Spacer()
            
            // 하단 푸터
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
    SignupView()
}
