import SwiftUI

struct DetailView: View {
    
    let memo: Memo
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTab: Tab = .detail
    @State private var isRecording: Bool = false
    @State private var isHomeActive: Bool = false
    @State private var isRecordActive: Bool = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // 상단 바
                ZStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }

                    Text(memo.title)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // 날짜
                Text(memo.date)
                    .font(.subheadline)
                    .padding(.horizontal, 20)
                
                // 음성 텍스트
                VStack(alignment: .leading, spacing: 10) {
                    Text("📝 음성 텍스트")
                        .font(.headline)
                    Text(memo.rawText)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                // 요약 텍스트
                VStack(alignment: .leading, spacing: 10) {
                    Text("📌 요약 내용")
                        .font(.headline)
                    Text(memo.summary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // 탭바
                TabBar(
                    selectedTab: $selectedTab,
                    isRecording: $isRecording,
                    onToggleRecording: {}
                )
            }
            // 🔹 홈 이동
            .navigationDestination(isPresented: $isHomeActive) {
                HomeView()
            }
            .navigationDestination(isPresented: $isRecordActive) {
                RecordView()
            }
            .onChange(of: selectedTab) { tab in
                switch tab {
                case .home:
                    isHomeActive = true
                case .record:
                    isRecordActive = true
                case .detail:
                    break
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
