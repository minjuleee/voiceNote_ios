//
//  Memo.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Foundation

struct Memo: Identifiable, Hashable {
    let id: String           // ✅ Firestore 문서 ID
    let title: String
    let summary: String
    let date: String         // 포맷팅된 날짜 문자열
    let rawText: String
//    var audioUrl: String
}
