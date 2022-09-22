//
//  OnboardingView.swift
//  VinIsDiesel
//
//  Created by Josh Wisenbaker on 9/22/22.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)
                .padding(.top)
            Spacer()
            Text("Vin is Diesel lets you scan and decode the Vehicle Identification Number of any vehicle built since 1981, and quite a few from before that.")
                .fontWeight(.semibold)
                .padding(.horizontal)
            Text("""
1. Tap Get Started
2. Tap the + button
3. Scan or enter a VIN to decode it
4. Tap Add Car
""")
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .padding(.top)


            Spacer()
            Button(action: { needsAppOnboarding = false }) {
                Text("Get Started")
                    .font(.title)
                    .padding()
            }
            Spacer()
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
