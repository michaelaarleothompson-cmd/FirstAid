//
//  Illness.swift
//  First Aid
//
//  Created by Michaela Arleo Thompson on 4/25/26.
//
import SwiftUI

struct Illness: View {
    let mainColor = Color(red: 20/255, green: 28/255, blue: 58/255)
    let accentColor = Color(.red)
    let textColor = Color(red: 210/255, green: 210/255, blue: 210/255)
    
    @State private var causeOfInjury = ""
    @State private var location = ""
    @State private var painLevel = ""
    @State private var feverPresent: String? = nil
    @State private var durationOfSymptoms: Double?
    @State private var temperature: Double?
    
    var locationTier1 : [String] = ["leg", "arm"]
    var locationTier2 : [String] = ["foot", "hand", "back"]
    var locationTier3 : [String] = ["face", "neck", "eye", "abdomen", "chest"]
    
    var adviceText: String {
        var textSoFar = "First Aid Guidance: "
        
        // Temperature
        if let temp = temperature {
            if temp >= 104.0 {
                textSoFar += "HIGH FEVER: Seek emergency medical care. "
            } else if temp >= 101.5 {
                textSoFar += "Moderate fever: Rest and hydrate. "
            } else if temp >= 100.4 {
                textSoFar += "Low-grade fever: Monitor closely. "
            }
        } else if feverPresent == "Yes" {
            textSoFar += "Take temperature. "
        }
        
        // Duration
        if let duration = durationOfSymptoms {
            if duration > 5 {
                textSoFar += "Professional medical attention recommended. "
            } else if duration > 0 {
                textSoFar += "Monitor symptoms closely. "
            }
        }
        
        // Pain level
        if let pain = Int(painLevel) {
            if pain >= 8 {
                textSoFar += "Professional medical attention recommended. "
            } else if pain >= 4 {
                textSoFar += "Monitor for severe changes in symptoms. "
            } else if pain > 0 {
                textSoFar += "Basic care recommended. "
            }
        }
        
        // area of discomfort
        let locationNormalized = location.lowercased()
        if locationTier1.contains(locationNormalized) {
            textSoFar += "Rest the affected area. "
        }
        if locationTier2.contains(locationNormalized) {
            textSoFar += "Keep area elevated if possible. "
        }
        if locationTier3.contains(locationNormalized) {
            textSoFar += "Professional medical attention recommended. "
        }
        
        // what are your main symptoms?
        let lowerCause = causeOfInjury.lowercased()
        if lowerCause.contains("cough")  {
            textSoFar += "Purchase a cough syrup or lozenges. "
        };if lowerCause.contains("sore throat")  {
            textSoFar += "Purchase a cough syrup or lozenges. "
        };if lowerCause.contains("nausea")  {
            textSoFar += "Drink water and eat bland foods. "
        };if lowerCause.contains("nausea")  {
            textSoFar += "Drink water and eat bland foods. "
        };if lowerCause.contains("headache")  {
            textSoFar += "Rest and apply compress"
        }
        
        
        return textSoFar
    }

    var body: some View {
        ZStack {
            mainColor.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image("BandAid")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)

                Text("Illness")
                    .font(.system(size: 52, weight: .heavy))
                    .foregroundColor(accentColor)
                
                Form {
                    Section {
                        TextField("How many days have you been sick?", value: $durationOfSymptoms, format: .number)
                            .keyboardType(.decimalPad)
                        
                        Menu {
                            Button("No", action: { feverPresent = "No"; temperature = nil })
                            Button("Yes", action: { feverPresent = "Yes" })
                        } label: {
                            HStack {
                                Text(feverPresent ?? "Are you running a fever?")
                                    .foregroundColor(textColor)
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                        }
                        
                        if feverPresent == "Yes" {
                            TextField("Enter Temperature (°F)", value: $temperature, format: .number)
                                .keyboardType(.decimalPad)
                        }
                        
                        TextField("What are your main symptoms?", text: $causeOfInjury)
                        TextField("Area of discomfort", text: $location)
                        TextField("Severity (1–10)", text: $painLevel)
                    }
                }
                .scrollContentBackground(.hidden)
                .foregroundStyle(textColor)

                Text(adviceText)
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(accentColor)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}

struct IllnessPreview: PreviewProvider {
    static var previews: some View {
        Illness()
    }
}
