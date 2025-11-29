//
//  SettingDetailView.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import DomainLayerInterface
import WidgetKit
import UIKit

public struct SettingDetailView: View {
    let menu: SettingMenu
    private let viewModel: SettingsViewModel
    
    public init(menu: SettingMenu, viewModel: SettingsViewModel) {
        self.menu = menu
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch menu {
            case .dailyLimit:
                DailyLimitSettingView(viewModel: viewModel)
            case .mainShape:
                MainShapeSettingView(viewModel: viewModel)
            case .withdrawal:
                WithdrawalSettingView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Setting Detail Views
private struct DailyLimitSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(Int(viewModel.dailyWaterLimit.rounded())) ml")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            Slider(value: Binding(
                get: { viewModel.dailyWaterLimit },
                set: {
                    viewModel.dailyWaterLimit = $0
                    // 위젯 즉시 업데이트
                    WidgetCenter.shared.reloadAllTimelines()
                }
            ), in: 1000...4000, step: 250) {
                Text("목표량")
            }
            .padding(.horizontal)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                // 앱이 활성화될 때 위젯 새로고침
                WidgetCenter.shared.reloadAllTimelines()
            }
            
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

private struct MainShapeSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(MainAppearance.allCases) { appearance in
                Button {
                    viewModel.selectMainAppearance(appearance)
                } label: {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: appearance.systemImage)
                                .font(.title2)
                                .frame(width: 40)
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appearance.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(appearance.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            if viewModel.isMainAppearanceSelected(appearance) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.isMainAppearanceSelected(appearance) ?
                                  Color.accentColor.opacity(0.1) :
                                    Color(uiColor: .systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.isMainAppearanceSelected(appearance) ?
                                Color.accentColor.opacity(0.3) :
                                    Color.clear,
                                lineWidth: 1
                            )
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

private struct WithdrawalSettingView: View {
    @Bindable private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)

                Text("회원 탈퇴")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("계정을 삭제하면 모든 데이터가 영구적으로 삭제되며 복구할 수 없습니다.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 40)

            VStack(alignment: .leading, spacing: 12) {
                Label("저장된 물 섭취 기록 삭제", systemImage: "drop.fill")
                Label("개인 설정 정보 삭제", systemImage: "gearshape.fill")
                Label("계정 정보 삭제", systemImage: "person.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray6))
            )
            .padding(.horizontal)

            Spacer()

            Button {
                viewModel.requestWithdrawal()
            } label: {
                Text("회원 탈퇴하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("회원 탈퇴")
        .navigationBarTitleDisplayMode(.inline)
        .alert("정말 탈퇴하시겠습니까?", isPresented: $viewModel.showWithdrawalConfirmation) {
            Button("취소", role: .cancel) {
                viewModel.cancelWithdrawal()
            }
            Button("탈퇴", role: .destructive) {
                Task {
                    await viewModel.confirmWithdrawal()
                }
            }
        } message: {
            Text("이 작업은 되돌릴 수 없습니다. 모든 데이터가 영구적으로 삭제됩니다.")
        }
        .alert("탈퇴 실패", isPresented: .constant(viewModel.withdrawalError != nil)) {
            Button("확인", role: .cancel) {
                viewModel.withdrawalError = nil
            }
        } message: {
            if let error = viewModel.withdrawalError {
                Text(error)
            }
        }
        .overlay {
            if viewModel.isWithdrawing {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView("탈퇴 처리 중...")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .systemBackground))
                        )
                }
            }
        }
    }
}
