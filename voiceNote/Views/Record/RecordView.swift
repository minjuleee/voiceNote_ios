import SwiftUI

struct RecordView: View {
    @StateObject private var viewModel = RecordViewModel()
    @State private var selectedTab: Tab = .record
    @State private var isHomeActive: Bool = false
    @Environment(\.dismiss) private var dismiss
    

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                // 🔹 상단 바
                HStack {
                    Button(action: {
                        isHomeActive = true
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Spacer().frame(width: 30)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // 🔹 상태 텍스트
                Text(viewModel.isRecording ? "녹음 중..." : "녹음을 시작하세요")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 🔹 웨이브폼 + 실시간 텍스트
                ZStack {
//                    WaveformView(volumes: viewModel.volumeHistory)
//                        .padding()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .foregroundColor(.white)

                    ScrollView {
                        Text(viewModel.liveText)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
                .frame(height: 400)
                .background(.blue)
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // 🔹 하단 탭바
                TabBar(
                    selectedTab: $selectedTab,
                    isRecording: $viewModel.isRecording,
                    onToggleRecording: {
                        print("viewModel.toggleRecording 호출")
                        viewModel.toggleRecording()
                    }
                )
            }
            // 🔹 홈 이동
            .navigationDestination(isPresented: $isHomeActive) {
                HomeView()
            }
            // 🔹 녹음 종료 시 상세 페이지 이동
            .navigationDestination(isPresented: $viewModel.navigateToDetail) {
                if let memo = viewModel.lastMemo {
                    DetailView(memo: memo)
                }
            }
            // 🔹 탭 전환
            .onChange(of: selectedTab) { tab in
                switch tab {
                case .home:
                    isHomeActive = true
                case .record:
                    break
                case .detail:
                    break
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    RecordView()
}
