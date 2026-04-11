//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import DesignSystem
import DomainLayerInterface
import Localization
import SwiftUI

public struct DrinkWaterView: View {
    private var viewModel: DrinkWaterViewModel

    public init(viewModel: DrinkWaterViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                GeometryReader { proxy in
                    WaterDropView(
                        appearance: viewModel.mainIcon,
                        progress: viewModel.progress,
                        offset: viewModel.offset
                    )
                    .animation(
                        .linear(duration: 2.0).repeatForever(autoreverses: false),
                        value: viewModel.offset
                    )
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height,
                        alignment: .center
                    )
                }
                .frame(height: 450)

                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                            .font(.title)
                        Text("\(viewModel.mililiters)")
                            .font(.callout)
                    }

                    HStack(alignment: .firstTextBaseline) {
                        Text(L10n.tr("drinkWaterGoalFormat", Int(viewModel.dailyLimit.rounded())))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if viewModel.isLimitReached {
                            Text(L10n.tr("drinkWaterCompleteLabel"))
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()

                nextActionCard
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                HStack {
                    Button {
                        Task {
                            await viewModel.drinkWater()
                        }
                    } label: {
                        Text(
                            viewModel.isLimitReached ?
                            L10n.tr("drinkWaterButtonReachedTitle") :
                            L10n.tr("drinkWaterButtonTitle")
                        )
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(viewModel.isLimitReached ? Color.gray : Color.accent)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.isLimitReached)

                    Button {
                        Task {
                            await viewModel.reset()
                        }
                    } label: {
                        Text(L10n.tr("commonResetTitle"))
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .task {
            // Refresh data when view appears to catch any Widget changes.
            await viewModel.loadInitialState()
        }
        .task {
            // Start the repeating wave after the initial frame is committed.
            viewModel.resetAnimation()
            await Task.yield()
            viewModel.startAnimation()
        }
    }

    private var nextActionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.semibold))

                Text(viewModel.nextActionBadgeText)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(.accentColor)

            Text(viewModel.nextActionHeadline)
                .font(.headline)
                .foregroundColor(.primary)

            Text(viewModel.nextActionDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.accent.opacity(0.12))
        )
    }
}

fileprivate struct WaterDropView: View {
    let appearance: MainIcon
    let progress: CGFloat
    let offset: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: appearance.fillSystemImage)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .scaleEffect(x: 1.1, y: 1.1)
                .offset(y: -1)

            WaterWaveView(
                progress: progress,
                waveHeight: 0.1,
                offset: offset
            )
            .fill(.teal)
            .waterDropGlareEffect()
            .mask {
                Image(systemName: appearance.fillSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}
