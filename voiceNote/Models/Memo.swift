//
//  Memo.swift
//  voiceNote
//
//  Created by 이민주 on 6/13/25.
//

import Foundation

struct Memo: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let date: String
    let rawText: String
}
