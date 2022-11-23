//
//  View.swift
//  BigLapTimer (iOS)
//
//  Created by 林宏樹 on 2022/01/22.
//

import SwiftUI

struct TextView: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.system(size: 70, weight: .black, design: .rounded))
            .bold()
            .frame(width: 300, height: 200, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .stroke(Color.blue, lineWidth: 10)
            )
            .foregroundColor(.black)
    }
}

struct TextViewPin: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.system(size: 70, weight: .black, design: .rounded))
            .bold()
            .frame(width: 300, height: 200, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .stroke(Color("ColorPink"), lineWidth: 10)
            )
            .foregroundColor(.black)
    }
}

struct TextViewGre: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.system(size: 70, weight: .black, design: .rounded))
            .bold()
            .frame(width: 300, height: 200, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 200)
                    .stroke(Color("ColorGreen"), lineWidth: 10)
            )
            .foregroundColor(.black)
    }
}

struct TextView2: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.title2)
            .frame(width: 100, height: 20)
            .foregroundColor(Color(.white))
            .padding(.all)
            .background(Color(.blue))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
    }
}
struct TextView3: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.title2)
            .frame(width: 100, height: 20)
            .foregroundColor(Color(.white))
            .padding(.all)
            .background(Color(.gray))
            .cornerRadius(20)
            .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
    }
}

struct TextView4: View {
    
    var label : String
    
    var body: some View {
        Text(label)
            .font(.title2)
            .frame(width: 160, height: 30)
            .foregroundColor(Color(.white))
            .padding(.all)
            .background(Color(.blue))
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.6), radius: 4, x: 10, y: 10)
    }
}


struct MyButtonStyle2: ButtonStyle {
  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
}
}

