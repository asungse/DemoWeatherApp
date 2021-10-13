//
//  LandingView.swift
//  Weather
//
//  Created by Alvin on 10/10/2021.
//

import SwiftUI
import Kingfisher

struct LandingView: View, CityViewModelDelegate {
    @StateObject var viewModel = CityViewModel()
    
    @State private var editMode = EditMode.inactive
    @State private var searchText = ""
    @State private var selection = Set<City>()
    @State private var showAlert = false
    @State private var showSheet = false
    @State private var showProgressiveView = false
    @State private var showLocationAuthorizationAlert = false
    
    private let okText = LocalizedStringKey("text.ok")
    private let deleteText = LocalizedStringKey("text.delete")
    private let deleteAllText = LocalizedStringKey("text.delete.all")
    private let navigationBarTitle = LocalizedStringKey("text.weather")
    private let searchBarPromptText = LocalizedStringKey("text.searchbar.placeholder")
    private let alertTitle = LocalizedStringKey("text.api.fail.title")
    private let needLocationAuthorizationTitle = LocalizedStringKey("text.need.location.authorization.title")
    private let needLocationAuthorizationMessage = LocalizedStringKey("text.need.location.authorization.message")
    
    private let locationIconName = ViewUtility.shared.locationIconName
    private let themeLinearGradient = ViewUtility.shared.themeLinearGradient
    
    private let errorMessage = ""
    
    private var cities: [City] { viewModel.getCities(nameWithPrefix: searchText, inSearchHistoryOnly: searchText.count < 4) }
    
    // MARK: - Protocol - CityViewModelDelegate
    
    func showNeedUpdateGpsAuthorizationAlert() {
        searchText = ""
        showProgressiveView = false
        showLocationAuthorizationAlert = true
    }
    
    func updateUIWithWeatherResult(_ result: Result<Bool, Error>) {
        searchText = ""
        showProgressiveView = false
        switch result {
        case .success(let success):
            if success {
                showSheet = true
            }
            else {
                showAlert = true
            }
        case .failure(let error):
            print(error)
        }
    }
    
    // MARK: - UI Functions
    
    private func onAppear() {
        // To display current weather information of last search at app launch
        if let cityName = viewModel.lastSearchedCity?.name {
            showProgressiveView = true
            viewModel.lastSearchCityIsShowedAtLaunch()
            viewModel.delegate = self
            viewModel.loadWeather(cityName: cityName)
        }
    }
    
    private func onTapGesture(city: City) {
        if editMode.isEditing {
            if selection.contains(city) {
                selection.remove(city)
            }
            else {
                selection.insert(city)
            }
        }
        else {
            showProgressiveView = true
            viewModel.delegate = self
            viewModel.loadWeather(cityName: city.name)
        }
    }
    
    private func onSubmitSearch() {
        guard !searchText.isEmpty else { return }
        showProgressiveView = true
        viewModel.delegate = self
        viewModel.search(text: searchText)
    }
    
    private func deleteButtonAction() {
        let selectedCities = selection.isEmpty ? cities : Array(selection)
        viewModel.updateCities(selectedCities, inSearchHistory: false)
        if selection.isEmpty {
            editMode = .inactive
        }
        else {
            selection.removeAll()
        }
    }
    
    private func locationButtonAction() {
        showProgressiveView = true
        viewModel.delegate = self
        viewModel.requestGPS()
    }
    
    // MARK: - Views
    
    private var leadingNavigationBarItem: some View {
        if cities.isEmpty {
            return AnyView(EmptyView())
        }
        else {
            return AnyView(EditButton())
        }
    }
    
    private var trailingNavigationBarItem: some View {
        if editMode.isEditing && !cities.isEmpty {
            return Button(action: deleteButtonAction, label: {
                AnyView(Text(selection.isEmpty ? deleteAllText : deleteText))
            })
        }
        else {
            return Button(action: locationButtonAction, label: {
                AnyView(Image(systemName: locationIconName))
            })
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(cities, id: \.self, selection: $selection) { city in
                    Text(city.name)
                        .font(.system(size: 25, weight: .medium, design: .default))
                        .frame(width: UIScreen.main.bounds.width * 0.85, alignment: .leading)
                        .contentShape(Rectangle())
                        .listRowBackground(themeLinearGradient)
                        .foregroundColor(.white)
                        .onTapGesture { onTapGesture(city: city) }
                        .sheet(isPresented: $showSheet, content: {
                            VStack {
                                Spacer()
                                Text(viewModel.selectedCityName ?? viewModel.apiResponse?.name ?? "")
                                    .font(.system(size: 35, weight: .medium, design: .default))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                                KFImage.url(NetworkManager.shared.getIconURL(icon: viewModel.apiResponse?.weather?.first?.icon))
                                    .frame(width: 50, height: 50, alignment: .center)
                                Text(Demo.packApiResponseDetailsForCurrentWeather(viewModel.apiResponse))
                                    .font(.system(size: 16, weight: .medium, design: .default))
                                    .padding()
                                Spacer()
                            }
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                            .background(themeLinearGradient).edgesIgnoringSafeArea(.all)
                        })
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text(alertTitle), message: Text(viewModel.apiResponse?.message ?? ""), dismissButton: .default(Text(okText)))
                        }
                        .alert(isPresented: $showLocationAuthorizationAlert) {
                            Alert(title: Text(needLocationAuthorizationTitle), message: Text(needLocationAuthorizationMessage), dismissButton: .default(Text(okText)))
                        }
                }
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: searchBarPromptText)
                .onSubmit(of: .search) { onSubmitSearch() }
                .navigationBarTitle(navigationBarTitle)
                .navigationBarItems(leading: leadingNavigationBarItem, trailing: trailingNavigationBarItem)
                .onAppear { onAppear() }
                .environment(\.editMode, $editMode)
                if showProgressiveView {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .scaleEffect(3)
                }
            }
        }.disabled(showProgressiveView)
    }
}

// MARK: -

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
