//
//  MapViewController.swift
//  SeSACTMDBProject
//
//  Created by 강민혜 on 8/11/22.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let theaterData = TheaterList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavi()
//        configureNaviBarButton()
        showActionSheet()
        
        locationManager.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionOnly(center: center)
        showAllTheaterLocationAndName()
        
    }
    
    func configureNavi() {
        
        self.navigationController?.navigationBar.tintColor = .white
        
        let navibarAppearance = UINavigationBarAppearance()
        let barbuttonItemAppearance = UIBarButtonItemAppearance()
        
        navibarAppearance.backgroundColor = .white
        navibarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 20)]
        navibarAppearance.shadowColor = .gray
        
        self.navigationItem.scrollEdgeAppearance = navibarAppearance
        self.navigationItem.standardAppearance = navibarAppearance
        
        // searchController 만들어서 넣기!
        navibarAppearance.buttonAppearance = barbuttonItemAppearance
    }
    
//    func configureNaviBarButton() {
//        let pinButton = UIBarButtonItem(image: UIImage(systemName: "mappin"), style: .plain, target: self, action: #selector(showActionSheet))
//        
//        self.navigationItem.rightBarButtonItem = pinButton
//    }
    
    
    func showAllTheaterLocationAndName() {
        for theater in 0...(theaterData.mapAnnotations.count - 1) {
            let test = CLLocationCoordinate2D(latitude: theaterData.mapAnnotations[theater].latitude, longitude: theaterData.mapAnnotations[theater].longitude)
            let locationName = theaterData.mapAnnotations[theater].location
            
            setAnnotationOnly(center: test, name: locationName)
        }
    }
    
    // MARK: - 위치권한 허용 팝업표시
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRequestLocationServiceAlert()
    }
    
    // MARK: - 맵뷰 설정
    // 중심설정 함수 (pin표기 X)
    func setRegionOnly(center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
    }
    
    // pin 고정 설정함수
    func setAnnotationOnly(center: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = name
        
        mapView.addAnnotation(annotation)
    }
    
    func grouping(brand: String) {
        
        let groupedTheater = Dictionary(grouping: theaterData.mapAnnotations) { $0.type }
        let filteredData = groupedTheater[brand]!
        
        for theater in 0...(filteredData.count - 1) {
            let test = CLLocationCoordinate2D(latitude: theaterData.mapAnnotations[theater].latitude, longitude: theaterData.mapAnnotations[theater].longitude)
            let locationName = theaterData.mapAnnotations[theater].location
            
            setAnnotationOnly(center: test, name: locationName)
        }
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
    
    // MARK: - 액션시트 생성
//    @objc
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "메가박스", style: .default, handler: {(ACTION:UIAlertAction) in
            self.removeAnnotations()
            self.grouping(brand: "메가박스")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "롯데시네마", style: .default, handler: {_ in
            self.removeAnnotations()
            self.grouping(brand: "롯데시네마")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "CGV", style: .default, handler: {(ACTION:UIAlertAction) in
            self.removeAnnotations()
            self.grouping(brand: "CGV")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "전체보기", style: .default, handler: {(ACTION:UIAlertAction) in
            self.removeAnnotations()
            self.showAllTheaterLocationAndName()
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }

    // MARK: - 위치권한 허용팝업 생성
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
      }
        
      let cancel = UIAlertAction(title: "취소", style: .default)
        
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
}


// MARK: - CLLocationManagerDelegate 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    // 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            setRegionOnly(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    // 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // 사용자의 권한 상태가 바뀔 경우
        // iOS 14 이상
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization()
    }
        // iOS 14 미만
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//    checkUserDeviceLocationServiceAuthorization()
//    }
}

// MARK: - 위치 관련된 User Defined 메서드
extension MapViewController {
    
    // MARK: - iOS 위치 서비스 활성화여부 확인 (먼저)
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
     
        // 현재 authorizationStatus 가져오기
        if #available(iOS 14.0, *) {
            // 인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // iOS 위치 서비스 활성화 여부 체크하기
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }

    // MARK: - 사용자의 위치 권한 상태 확인 (그다음)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 위치 권한요청 팝업
            
        case .restricted, .denied:
            print("DENIED, 청년취업사관학교 영등포 캠퍼스가 맵뷰의 중심이 되도록 설정합니다.")
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            setRegionOnly(center: center)
            showRequestLocationServiceAlert()
            // 청년취업사관학교 영등포 캠퍼스 위치를 맵뷰 중심으로
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        default:
            print("DEFAULT")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        }
    }
}

// MARK: - 지도관련 설정
extension MapViewController: MKMapViewDelegate {
    
    // 지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    }
    
    // 이거 실행한거 함수명을 보려면 map delegate 설정이 필요
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
        locationManager.startUpdatingLocation()
    }

}
