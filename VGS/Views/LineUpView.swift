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
    @State private var showBlue = true
    @State private var showOrange = true
    @State private var showH2H = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                SoccerField()
                
                VStack(alignment: .leading) {
                    
                    Menu(viewModel.team2.name) {
                        ForEach(viewModel.teams) { team in
                            Button(team.name) {
                                viewModel.team2 = team
                                viewModel.lineupPlayers()
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical, 5)
                    .opacity(showOrange ? 1 : 0)
                    
                    
                    Spacer()
                    
                    Menu(viewModel.team1.name) {
                        ForEach(viewModel.teams) { team in
                            Button(team.name) {
                                viewModel.team1 = team
                                viewModel.lineupPlayers()
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.vertical, 5)
                    .opacity(showBlue ? 1 : 0)
                }
                
                TeamLineUpView(team: $viewModel.team1, color: .blue)
                    .opacity(showBlue ? 1 : 0)
                
                TeamLineUpView(team: $viewModel.team2, color: .red)
                    .opacity(showOrange ? 1 : 0)
                
                BallView()
                    .opacity(showBall ? 1 : 0)
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.lineupPlayers()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if viewModel.numberOfTeam != 1 {
                        Button {
                            showH2H.toggle()
                        } label: {
                            Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill")
                        }
                        .sheet(isPresented: $showH2H) {
                            Head2HeadView(showH2H: $showH2H)
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showBlue.toggle()
                    } label: {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(showBlue ? .blue : .blue.opacity(0.5))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showOrange.toggle()
                    } label: {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(showOrange ? .red : .red.opacity(0.5))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showBall.toggle()
                    } label: {
                        Image(systemName: "soccerball.circle")
                            .foregroundStyle(showBall ? .primary : .secondary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.lineupPlayers()
                    } label: {
                        Image(systemName: "figure.soccer")
                    }
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
        .environmentObject(ViewModel())
}
