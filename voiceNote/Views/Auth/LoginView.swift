//
//  LoginView.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()  // ✅ ViewModel 인스턴스 생성
    
    var body: some View {
        NavigationStack {  // ✅ NavigationStack으로 감싸주기
            VStack {
                Spacer()
                
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
                
                // 이메일 입력
                TextField("이메일", text: $viewModel.email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                
                // 비밀번호 입력
                SecureField("비밀번호", text: $viewModel.password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 20)
                
                // 로그인 버튼 (✅ 인스턴스의 login() 호출)
                Button(action: {
                    viewModel.login()
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
                
                // 에러메시지 출력
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                
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
            // ✅ 로그인 성공 시 홈으로 이동
            .navigationDestination(isPresented: $viewModel.isLoggedIn) {
                HomeView()
            }
        }
    }
}

#Preview {
    LoginView()
}

