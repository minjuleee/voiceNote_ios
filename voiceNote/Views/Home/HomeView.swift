import SwiftUI

struct HomeView: View {
    
    @State private var searchText: String = ""
    @State private var selectedTab: Tab = .home
    @State private var isRecording: Bool = false
    @State private var isRecordActive: Bool = false
    @State private var memos: [Memo] = []
    
    var filteredMemos: [Memo] {
        if searchText.isEmpty {
            return memos
        } else {
            return memos.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // 검색바
                HStack {
                    TextField("검색어를 입력하세요", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(20)
                    
                    Image(systemName: "magnifyingglass")
                        .font(.title2)
                        .padding(.leading, 5)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Divider()
                    .padding(.vertical, 10)
                
                // 리스트
                List {
                    ForEach(filteredMemos, id: \.id) { memo in
                        NavigationLink(destination: DetailView(memo: memo)) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text(memo.title)
                                    .font(.headline)
                                Text(memo.summary)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(memo.date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .onDelete(perform: deleteMemo)
                }
                .listStyle(.plain)
                
                Spacer()
                
                // 하단 탭바
                TabBar(
                    selectedTab: $selectedTab,
                    isRecording: $isRecording,
                    onToggleRecording: {}
                )
            }
            .navigationDestination(isPresented: $isRecordActive) {
                RecordView()
            }
            .onAppear {
                FirestoreService().fetchMemos { fetched in
                    self.memos = fetched
                }
            }
            .onChange(of: selectedTab) { tab in
                switch tab {
                case .home: break
                case .record: isRecordActive = true
                case .detail: break
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    // ✅ audioUrl 제거된 삭제 함수
    private func deleteMemo(at offsets: IndexSet) {
        for index in offsets {
            let memo = filteredMemos[index]
            FirestoreService().deleteMemo(memoId: memo.id) { result in
                switch result {
                case .success():
                    if let idx = memos.firstIndex(where: { $0.id == memo.id }) {
                        memos.remove(at: idx)
                    }
                case .failure(let error):
                    print("❌ 삭제 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
