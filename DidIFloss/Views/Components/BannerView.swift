//
//  BannerView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 24/01/24.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        
        VStack {
            HStack {
                ToothView(style: .pink, size: 70)
                
                Spacer()
                
                ToothView(style: .yellow, size: 70)
                
                Spacer()
                
                ToothView(style: .pink, size: 70)
            }
            
            
            HStack {
                Spacer()
                
                ToothView(style: .yellow, size: 70)
                
                Spacer()
                
                ToothView(style: .pink, size: 70)
                
                Spacer()
            }
        }
        
        .background(Color("sky-blue"))
        
    }
}

#Preview {
    BannerView()
}
