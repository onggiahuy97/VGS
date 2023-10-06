//
//  LineUpView.swift
//  VGS
//
//  Created by Huy Ong on 10/5/23.
//

import SwiftUI

struct LineUpView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showBall = false
    @State private var showTeam1 = true
    @State private var showTeam2 = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                SoccerField()
                
                TeamLineUpView(team: $viewModel.team1, color: .blue)
                    .opacity(showTeam1 ? 1 : 0)
                
                TeamLineUpView(team: $viewModel.team2, color: .orange)
                    .opacity(showTeam2 ? 1 : 0)
                
                BallView()
                    .opacity(showBall ? 1 : 0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.lineupPlayers()
            }
            .toolbar {
                Button {
                    showTeam1.toggle()
                } label: {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(showTeam1 ? .blue : .blue.opacity(0.5))
                }
                
                Button {
                    showTeam2.toggle()
                } label: {
                    Image(systemName: "circle.fill")
                        .foregroundStyle(showTeam2 ? .orange : .orange.opacity(0.5))
                }
                
                Button {
                    showBall.toggle()
                } label: {
                    Image(systemName: "soccerball.circle")
                        .foregroundStyle(showBall ? .primary : .secondary)
                }
                
                Button {
                    viewModel.lineupPlayers()
                } label: {
                    Image(systemName: "figure.soccer")
                }
            }
        }
    }
}

struct BallView: View {
    @State private var position: CGPoint = CGPoint.randomPoint(in: .init(x: 100, y: 500, width: 500, height: 500))
    @State private var isDragging = false
    
    var body: some View {
        GeometryReader { proxy in
            Image(systemName: "soccerball")
                .font(.system(size: 40, weight: .bold))
                .position(position)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.spring) {
                                isDragging = true
                            }
                            position = value.location
                        }
                        .onEnded { _ in
                            withAnimation(.spring) {
                                isDragging = false
                            }
                        }
                )
                .onAppear {
                    let size = proxy.size
                    position = CGPoint(x: size.width / 2, y: size.height / 2)
                }
        }
    }
}

extension LineUpView {
    static let tag: String? = "LineUpView"
}

#Preview {
    LineUpView()
}
