//
//  AnimatedIcon.swift
//  PlantPulse
//
//  Created by Kevin Shook on 11/21/24.
//

import SwiftUI

struct AnimatedIcon: View {
    let metric: String
    @State private var animate = false
    
    var body: some View {
        Group {
            switch metric {
                case "temperature":
                    Image(systemName: "thermometer")
                        .foregroundColor(.red)
                        .rotationEffect(Angle(degrees: animate ? 10 : -10))
                        .animation(Animation.easeInOut(duration: 1), value: animate)
                        .onAppear {
                            animate = true
                        }
                case "humidity":
                    Image(systemName: "humidity.fill")
                        .foregroundColor(.blue)
                        .opacity(animate ? 0.5 : 1.0)
                        .animation(Animation.easeInOut(duration: 1), value: animate)
                        .onAppear {
                            animate = true
                        }
                case "soilMoisture":
                    if #available(iOS 17.0, *) {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                            .onAppear {
                                animate = true
                            }
                    } else {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.blue)
                            .opacity(animate ? 0.5 : 1.0)
                            .animation(Animation.easeInOut(duration: 1), value: animate)
                            .onAppear {
                                animate = true
                            }
                    }
                case "uvA", "uvB", "uvC":
                    if #available(iOS 17.0, *) {
                        Image(systemName: "sun.max.trianglebadge.exclamationmark.fill")
                            .resizable()
                            .foregroundColor(.yellow)
                            .symbolEffect(.bounce.up.byLayer, options: .nonRepeating)
                            .onAppear {
                                animate = true
                            }
                    } else {
                        Image(systemName: "sun.max.trianglebadge.exclamationmark.fill")
                            .resizable()
                            .foregroundColor(.yellow)
                            .animation(Animation.easeInOut(duration: 1), value: animate)
                            .onAppear {
                                animate = true
                            }
                    }
                case "light":
                    Image(systemName: "sun.max.fill")
                        .resizable()
                        .foregroundColor(.yellow)
                        .scaleEffect(animate ? 1.1 : 0.9)
                        .animation(Animation.easeInOut(duration: 1), value: animate)
                        .onAppear {
                            animate = true
                        }
                default:
                    Image(systemName: "bell.fill")
                        .resizable()
                        .foregroundColor(.yellow)
            }
        }
    }
}
