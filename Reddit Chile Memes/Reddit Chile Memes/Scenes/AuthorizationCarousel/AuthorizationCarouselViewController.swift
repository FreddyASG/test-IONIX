//
//  AuthorizationCarouselViewController.swift
//  Reddit Chile Memes
//
//  Created by Freddy Silva on 15/5/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation
import AVFoundation
import UserNotifications

protocol AuthorizationCarouselDisplayLogic: AnyObject {
    func displayInitialData(viewModel: AuthorizationCarousel.InitialData.ViewModel)
}

class AuthorizationCarouselViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var locationManager: CLLocationManager?
    
    private var items = [AuthorizationCarousel.Item]()
    
    var interactor: AuthorizationCarouselBusinessLogic?
    var router: (NSObjectProtocol & AuthorizationCarouselRoutingLogic & AuthorizationCarouselDataPassing)?

    // MARK: - Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = AuthorizationCarouselInteractor()
        let presenter = AuthorizationCarouselPresenter()
        let router = AuthorizationCarouselRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        loadInitialData()
    }
    
    // MARK: - Methods
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: String(describing: AuthorizationCarouselCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: AuthorizationCarouselCollectionViewCell.reuseIdentifier)
    }
    
    private func requestAuthorization(item: AuthorizationCarousel.Item) {
        switch item {
        case .camera:
            cameraAuthorization()
        case .notifications:
            notificationsAuthorization()
        case .location:
            locationAutorization()
        }
    }
    
    private func cameraAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized: // The user has previously granted access to the camera.
            navigateToSettings(item: .camera)
            
        case .notDetermined: // The user has not yet been asked for camera access.
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    self?.navigateToNotifications()
                }
            }
            
        case .denied, .restricted: // The user can't grant access due to restrictions.
            navigateToSettings(item: .camera)
        @unknown default:
            fatalError()
        }
    }
    
    private func notificationsAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { [weak self] settings in
            if (settings.authorizationStatus == .authorized) || (settings.authorizationStatus == .provisional) {
                self?.navigateToSettings(item: .notifications)
            } else {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted {
                        self?.navigateToLocation()
                    } else {
                        self?.navigateToSettings(item: .notifications)
                    }
                }
            }
            
        }
    }
    
    private func locationAutorization() {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        switch locationManager?.authorizationStatus {
        case .authorizedWhenInUse:
            navigateToSettings(item: .location)
        case .authorizedAlways:
            navigateToSettings(item: .location)
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        case .restricted, .denied:
            navigateToSettings(item: .location)
        case .none:
            navigateToSettings(item: .location)
        default:
            break
        }
    }
    
    private func continueCarousel(item: AuthorizationCarousel.Item) {
        
        switch item {
        case .camera:
            navigateToNotifications()
        case .notifications:
            navigateToLocation()
        case .location:
            router?.routeToHome()
        }
        
    }
    
    private func navigateToNotifications() {
        let indexPath = IndexPath(item: 1, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func navigateToLocation() {
        
        UserDefaultsReddit.hiddenCarousel(true)
        
        let indexPath = IndexPath(item: 2, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    private func navigateToSettings(item: AuthorizationCarousel.Item) {
        DispatchQueue.main.async {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { [weak self] _ in
                    switch item {
                    case .camera:
                        self?.navigateToNotifications()
                    case .notifications:
                        self?.navigateToLocation()
                    case .location:
                        self?.router?.routeToHome()
                    }
                }
            }
        }
    }
    
    // MARK: - LoadInitialData
    func loadInitialData() {
        let request = AuthorizationCarousel.InitialData.Request()
        interactor?.loadInitialData(request: request)
    }
    
    // MARK: - Actions
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        
        switch items[index] {
        case .location:
            UserDefaultsReddit.hiddenCarousel(true)
        default:
            break
        }
    }
}

// MARK: - AuthorizationCarouselDisplayLogic
extension AuthorizationCarouselViewController: AuthorizationCarouselDisplayLogic {
    func displayInitialData(viewModel: AuthorizationCarousel.InitialData.ViewModel) {
        items = viewModel.items
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension AuthorizationCarouselViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthorizationCarouselCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? AuthorizationCarouselCollectionViewCell else {
            fatalError()
        }
        
        cell.delegate = self
        cell.setupAutorizationCarouselCell(item: items[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - AuthorizationCarouselCollectionViewCellDelegate
extension AuthorizationCarouselViewController: AuthorizationCarouselCollectionViewCellDelegate {
    func didTapAuthorization(item: AuthorizationCarousel.Item) {
        requestAuthorization(item: item)
    }
    
    func didTapCancel(item: AuthorizationCarousel.Item) {
        continueCarousel(item: item)
    }
}

// MARK: - CLLocationManagerDelegate
extension AuthorizationCarouselViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            router?.routeToHome()
        default:
            break
        }
    }
    
}
