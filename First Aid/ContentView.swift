//
//  ContentView.swift
//  First Aid
//
//  Created by Michaela Arleo Thompson on 3/4/26.
//

import SwiftUI

struct HomeScreen: View {
    let mainColor = Color(red: 20/255, green: 28/255, blue: 58/255)
    let accentColor = Color(red: 48/255, green: 105/255, blue: 240/255)
    
    var body: some View {
        
        ZStack{
            
            mainColor.ignoresSafeArea()
            
            VStack{
                Spacer().frame(height: 20)
                Spacer().frame(height: 20)
                Text("*Disclaimer: This app was not made by medical professionals. Please consult a medical professional for any emergencies.*")
                    .font(.system(size: 15)).bold().foregroundColor(.white)
                   .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text("First Aid")
                    .font(.system(size: 65)).bold().foregroundColor(.red)
                    .shadow(color: .white, radius: 1)
                    .shadow(color: .accentColor, radius: 1)
                    .shadow(color: .accentColor, radius: 1)
                    .shadow(color: .accentColor, radius: 1)
                    .shadow(color: .accentColor, radius: 1)
                
                Image("BandAid") // Use the name from your Asset Catalog
                    .resizable()     // Allows the image to be resized
                    .scaledToFit()   // Maintains aspect ratio
                    .frame(width: 300, height: 200)
                Spacer()
                Spacer()
                HStack{
                    
                    
                    NavigationLink (destination: Cuts()){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .border(Color.red, width: 5)
                            .cornerRadius(20)
                            .overlay(
                                Text("CUTS")
                                    .font(.system(size: 30)).bold().foregroundColor(.accentColor)
                            )
                    }
                    
                    NavigationLink (destination: Burns()){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .border(Color.red, width: 5)
                            .cornerRadius(20)
                            .overlay(
                                Text("BURNS")
                                    .font(.system(size: 30)).bold().foregroundColor(.accentColor)
                            )
                    }
                }
                HStack{
                    NavigationLink (destination: Illness()){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .border(Color.red, width: 5)
                            .cornerRadius(20)
                            .overlay(
                                Text("ILLNESS")
                                    .font(.system(size: 30)).bold().foregroundColor(.accentColor)
                            )}
                    NavigationLink(destination: ImageAssist()){
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 150, height: 150)
                            .border(Color.red, width: 5)
                            .cornerRadius(20)
                            .overlay(
                                Text("IMAGE ASSIST")
                                    .font(.system(size: 30)).bold().foregroundColor(.accentColor)
                            )
                        
                    }
                }
                
                
                
            }
        }
        
        
    }
}
struct Preview: PreviewProvider {
    static var previews: some View{
        HomeScreen()
    }
}
