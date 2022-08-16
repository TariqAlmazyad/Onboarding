//
//  ContentView.swift
//  Onboarding
//
//  Created by Tariq Almazyad on 15/08/2022.
//

import SwiftUI

struct Onboarding: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let imageName: String
    let title: String
    let description: String
}

final class OnboardingViewModel: ObservableObject {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @Published var onboardingItems: [Onboarding] = [
        .init(imageName: "Success",
              title: "Have a fun",
              description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        .init(imageName: "Searching",
              title: "Search Better",
              description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
        .init(imageName: "Food",
              title: "Rest, Listen",
              description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
    ]
    
    @Published var currentPageIndex: Int = 0
    
}

struct ContentView: View {
    @StateObject var onboardingViewModel = OnboardingViewModel()
    @Namespace var namespace
    @State var colors = [Color(#colorLiteral(red: 0.4755041599, green: 0.3562205434, blue: 0.7511247993, alpha: 1)) , Color(#colorLiteral(red: 0.4822301865, green: 0.7546524405, blue: 0.3559693992, alpha: 1)), Color(#colorLiteral(red: 0.4630121589, green: 0.4826663733, blue: 0.998223722, alpha: 1))]
    var body: some View {
        TabView(selection: $onboardingViewModel.currentPageIndex){
            ForEach(Array(onboardingViewModel.onboardingItems.enumerated()), id:\.element) { index, onboardingItem in
                VStack{
                    Image(onboardingItem.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .animation(.spring(), value: onboardingViewModel.currentPageIndex)
                    Text(onboardingItem.title)
                        .font(.title)
                    Text(onboardingItem.description)
                        .font(.title3)
                        .padding()
                        .multilineTextAlignment(.center)
                }.tag(onboardingViewModel.onboardingItems.firstIndex(of: onboardingItem) ?? 0)
                
            }
        }.frame(width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .overlay(alignment: .bottom) {
            HStack(alignment: .center, spacing: 30) {
                Button {
                    withAnimation(.spring()){
                        if onboardingViewModel.currentPageIndex > 0 {
                            onboardingViewModel.currentPageIndex -= 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .padding()
                }

                Spacer()
                
                ForEach(Array(colors.enumerated()), id:\.element) { index, color in
                    Button {
                        withAnimation(.spring()){
                            onboardingViewModel.currentPageIndex = index
                        }
                    } label: {
                        VStack{
                            Circle()
                                .fill(onboardingViewModel.currentPageIndex == index ? color : Color.clear)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(onboardingViewModel.currentPageIndex != index ? color : Color.clear, lineWidth: 1)
                                )
                                .scaleEffect(onboardingViewModel.currentPageIndex == index ? 1.6 : 0.6)
                        }.animation(.spring(), value: onboardingViewModel.currentPageIndex)
                    }

                }
                Spacer()
                Button {
                    withAnimation(.spring()){
                        if onboardingViewModel.currentPageIndex < 2 {
                            onboardingViewModel.currentPageIndex += 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .padding()
                }

                
            }.padding(.bottom, 34)
                .padding(.horizontal, 24)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
