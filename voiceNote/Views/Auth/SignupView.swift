//
//  SignupView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct SignupView: View {
    
    @StateObject private var viewModel = SignupViewModel()
    @Environment(\.dismiss) var dismiss  // 뒤로가기, 로그인페이지로 복귀
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.bottom, 20)
            
            Text("SIGN UP")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
                .padding(.bottom, 40)
            
            TextField("이메일", text: $viewModel.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 30)
            
            SecureField("비밀번호", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            
            // 🔥 핵심: ViewModel의 signup 호출
            Button(action: {
                viewModel.signup()
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
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
            
            HStack {
                Text("회원이신가요?")
                
                NavigationLink(destination: SignupView()) {
                    Text("로그인하기")
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
        // 🔥 회원가입 성공 시 자동으로 뒤로가기 (로그인 화면으로)
        .onChange(of: viewModel.isSignedUp) { isSignedUp in
            if isSignedUp {
                dismiss()  // 로그인 페이지로 돌아감
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SignupView()
}
