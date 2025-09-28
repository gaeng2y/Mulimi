//
//  SettingMenu.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

public enum SettingMenu: CaseIterable, Identifiable {
    case dailyLimit
    case accentColor
    case mainShape
    
    public var id: Self { self }
    
    public var title: String {
        switch self {
        case .dailyLimit: "하루 목표량"
        case .accentColor: "강조 색상"
        case .mainShape: "메인 화면 모양"
        }
    }
    
    public var systemImage: String {
        switch self {
        case .dailyLimit:
            return "target"
        case .accentColor:
            return "paintpalette"
        case .mainShape:
            return "square.grid.2x2"
        }
    }
    
    public var description: String {
        switch self {
        case .dailyLimit:
            return "하루 동안 마실 물의 목표량을 설정합니다"
        case .accentColor:
            return "앱의 강조 색상을 변경합니다"
        case .mainShape:
            return "메인 화면의 디자인을 선택합니다"
        }
    }
    
    public var settingKey: String {
        switch self {
        case .dailyLimit:
            return "dailyWaterLimit"
        case .accentColor:
            return "appAccentColor"
        case .mainShape:
            return "mainScreenAppearance"
        }
    }
    
    @ViewBuilder
    public var destinationView: some View {
        switch self {
        case .dailyLimit:
            DailyLimitSettingView()
        case .accentColor:
            AccentColorSettingView()
        case .mainShape:
            mainShapeSettingView()
        }
    }
}

// MARK: - Setting Views (Placeholder)
private struct DailyLimitSettingView: View {
    @AppStorage("dailyWaterLimit") private var dailyLimit: Double = 2000
    
    var body: some View {
        VStack(spacing: 20) {
            Text("하루 목표량")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text("\(Int(dailyLimit)) ml")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            Slider(value: $dailyLimit, in: 1000...4000, step: 250) {
                Text("목표량")
            }
            .padding(.horizontal)
            
            HStack {
                Text("1000ml")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("4000ml")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("하루 목표량")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AccentColorSettingView: View {
    @AppStorage("appAccentColor") private var selectedColor: String = "blue"
    
    private let availableColors: [(name: String, color: Color)] = [
        ("blue", .blue),
        ("purple", .purple),
        ("pink", .pink),
        ("red", .red),
        ("orange", .orange),
        ("yellow", .yellow),
        ("green", .green),
        ("teal", .teal),
        ("indigo", .indigo)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("강조 색상")
                .font(.title2)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 20) {
                ForEach(availableColors, id: \.name) { item in
                    Button {
                        selectedColor = item.name
                    } label: {
                        Circle()
                            .fill(item.color)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Circle()
                                    .stroke(Color.primary, lineWidth: selectedColor == item.name ? 3 : 0)
                            )
                            .overlay(
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .opacity(selectedColor == item.name ? 1 : 0)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("강조 색상")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct mainShapeSettingView: View {
    @AppStorage("mainScreenAppearance") private var selectedAppearance: String = "circular"
    
    private let appearances: [(id: String, name: String, systemImage: String)] = [
        ("circular", "원형", "circle"),
        ("wave", "파도", "waveform"),
        ("bottle", "물병", "waterbottle"),
        ("minimal", "미니멀", "square")
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("메인 화면 모양")
                .font(.title2)
                .fontWeight(.bold)
            
            ForEach(appearances, id: \.id) { appearance in
                Button {
                    selectedAppearance = appearance.id
                } label: {
                    HStack {
                        Image(systemName: appearance.systemImage)
                            .font(.title2)
                            .frame(width: 40)
                        
                        Text(appearance.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        if selectedAppearance == appearance.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedAppearance == appearance.id ?
                                  Color.accentColor.opacity(0.1) :
                                    Color(uiColor: .systemGray6))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("메인 화면 모양")
        .navigationBarTitleDisplayMode(.inline)
    }
}
