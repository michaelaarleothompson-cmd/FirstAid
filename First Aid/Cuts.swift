//
//  Cuts.swift
//  First Aid
//
//  Created by Michaela Arleo Thompson on 3/16/26.
//

import SwiftUI

struct Cuts: View {
    let mainColor = Color(red: 20/255, green: 28/255, blue: 58/255)
    let accentColor = Color(.red)
    let textColor = Color(red: 210/255, green: 210/255, blue: 210/255)
    @State private var causeOfInjury = ""
    @State private var location = ""
    @State private var painLevel = ""
    @State private var bloodPresent: String? = nil
    @State private var size: Double?
    var locationTier1 : [String] = ["leg", "arm"]
    var locationTier2 : [String] = ["foot", "hand", "back"]
    var locationTier3 : [String] = ["face", "neck", "eye", "abdomen", "chest"]
    var adviceText: String {
        var textSoFar = "First Aid Guidance: "
        
        // bleeding
        if bloodPresent == "Yes" {
            textSoFar += "Apply firm pressure."
        } else if bloodPresent == "No" {
            textSoFar += "Clean the wound. "
        }
        // size
        if let size = size {
            if size > 5 {
                textSoFar += "Professional medical attention recommended."
            } else if size > 0 {
                textSoFar += " Apply antiseptic and bandage. "
            }
        }
        
        // pain level
        if let pain = Int(painLevel) {
            if pain >= 8 {
                textSoFar += "Professional medical attention recommended."
            } else if pain >= 4 {
                textSoFar += "Monitor for severe changes in symptoms. "
            } else if pain > 0 {
                textSoFar += "Basic first aid recommended. "
            }
        }
        
        // location
        let locationNormalized = location.lowercased()
        
        if locationTier1.contains(locationNormalized){
            textSoFar += "Cover with sterile bandage. "
        }
        if locationTier2.contains(locationNormalized){
            textSoFar += "Sterilize and cover wound. "
        }
        if locationTier3.contains(locationNormalized){
            textSoFar += "Professional medical attention recommended. "
        }
        
        // cause
        if causeOfInjury.lowercased().contains("wood") {
            textSoFar += "Check wound for small wood splinters."
        }
        if causeOfInjury.lowercased().contains("metal") {
            textSoFar += "Tetanus shot recommended."
        }
        
        if causeOfInjury.lowercased().contains("glass") {
            textSoFar += "Check wound for small glass fragments."
        }
        
        return textSoFar
    }
    
    var body: some View {
        
        ZStack {
            mainColor.ignoresSafeArea()
            // HEADER
                VStack(spacing: 12) {
                    
                    Image("BandAid")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                    
                    Text("CUTS")
                        .font(.system(size: 52, weight: .heavy))
                        .foregroundColor(accentColor)
                    Form {
                        Section {
                            
                            TextField("Size (cm)", value: $size, format: .number)
                                .keyboardType(.decimalPad)
                            Menu {
                                Button("No", action: { bloodPresent = "No" })
                                Button("Yes", action: { bloodPresent = "Yes" })
                                
                            } label: {HStack {
                                Text(bloodPresent ?? "Blood present")
                                    .foregroundColor(textColor)
                                Image(systemName: "chevron.down")
                            }}
                            TextField("Cause of injury", text: $causeOfInjury)
                            
                            TextField("Location", text: $location)
                            
                            TextField("Pain level (1–10)", text: $painLevel)
                            
                            
                        }
                        
                    }.foregroundStyle(textColor)
                    Text(adviceText)
                        .font(.system(size: 20, weight: .heavy))
                        .foregroundColor(accentColor)
                }
            
            .scrollContentBackground(.hidden)
            .background(mainColor)
        }
    }
}

struct CutsPreview: PreviewProvider {
    static var previews: some View {
        Cuts()
    }
}
