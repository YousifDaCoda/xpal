//
//  LanguagesList.swift
//  XPal
//
//  Created by gunnar on 4/29/25.
//


import SwiftUI
import SwiftData
import Charts

struct LanguagesList: View {
    
    
    @Environment(\.modelContext) private var modelContext
    @Query(FetchDescriptor<Language>(sortBy: [SortDescriptor(\Language.name, order: .forward)])) private var listOfAllLanguagesInDatabase: [Language]
     
    var languageCountryData: [LanguageCountryData] {
        listOfAllLanguagesInDatabase.map {
            LanguageCountryData(languageName: $0.name, countryCount: $0.countriesSpoken)
        }
    }
    
    var speakerChartData: [LanguageSpeakersData] {
        listOfAllLanguagesInDatabase.map {
            LanguageSpeakersData(languageName: $0.name, numberOfSpeakers: $0.numberOfSpeakers)
        }
    }

    var mostWidespreadLanguage: LanguageCountryData? {
        languageCountryData.max(by: { $0.countryCount < $1.countryCount })
    }

    var mostSpokenLanguage: LanguageSpeakersData? {
        speakerChartData.max(by: { $0.numberOfSpeakers < $1.numberOfSpeakers })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // List of Languages
                    List {
                        ForEach(listOfAllLanguagesInDatabase) { aLanguage in
                            NavigationLink(destination: LanguageDetails(language: aLanguage)) {
                                LanguageItem(language: aLanguage)
                            }
                        }
                    }
                    .font(.system(size: 14))
                    .frame(height: 400)
                    
                    Text("Languages by Country Count")
                        .font(.headline)
                        .padding(.horizontal)

                    Chart(languageCountryData, id: \.languageName) { dataPoint in
                        SectorMark(
                            angle: .value("Countries", dataPoint.countryCount),
                            innerRadius: .ratio(0.618),
                            angularInset: 1.5
                        )
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("Language", dataPoint.languageName))
                    }
                    .chartBackground { chartProxy in
                        GeometryReader { geometry in
                            if let frameAnchor = chartProxy.plotFrame {
                                let frame = geometry[frameAnchor]
                                VStack {
                                    Text("Most Widespread")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                    
                                    if let most = mostWidespreadLanguage {
                                        Text(most.languageName)
                                            .font(.title2.bold())
                                            .foregroundColor(.primary)
                                    }
                                }
                                .position(x: frame.midX, y: frame.midY)
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)


                    
                    Text("Languages by Number of Speakers")
                        .font(.headline)
                        .padding(.horizontal)

                    Chart(speakerChartData, id: \.languageName) { dataPoint in
                        SectorMark(
                            angle: .value("Speakers", dataPoint.numberOfSpeakers),
                            innerRadius: .ratio(0.618),
                            angularInset: 1.5
                        )
                        .cornerRadius(5)
                        .foregroundStyle(by: .value("Language", dataPoint.languageName))
                    }
                    .chartBackground { chartProxy in
                        GeometryReader { geometry in
                            if let frame = chartProxy.plotFrame {
                                let rect = geometry[frame]
                                VStack {
                                    Text("Most Spoken")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)

                                    if let most = mostSpokenLanguage {
                                        Text(most.languageName)
                                            .font(.title2.bold())
                                            .foregroundColor(.primary)
                                    }
                                }
                                .position(x: rect.midX, y: rect.midY)
                            }
                        }
                    }
                    .frame(height: 250)
                    .padding(.horizontal)

                }
            }
            .navigationTitle("List of Languages")
            .toolbarTitleDisplayMode(.inline)
        }
        
    }
    
   
}


