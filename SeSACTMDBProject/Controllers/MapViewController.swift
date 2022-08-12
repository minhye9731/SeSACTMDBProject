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
        setBarButtonItem()
        
        locationManager.delegate = self
        
        let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        setRegionOnly(center: center)
        self.showAndPinTheaters(dataArray: self.theaterData.mapAnnotations)

    }
    
    // MARK: - navi 설정
    func setBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin"), style: .plain, target: self, action: #selector(showActionSheet))
    }
    
    // MARK: - 위치권한 허용 팝업표시
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showRequestLocationServiceAlert()
    }
    
    // MARK: - 액션시트 생성
    @objc
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "메가박스", style: .default, handler: {(ACTION:UIAlertAction) in
            print("메가박스")
            self.removeAnnotations()
            self.showAndPinTheatersPerBrand(brand: "메가박스")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "롯데시네마", style: .default, handler: {_ in
            print("롯데시네마")
            self.removeAnnotations()
            self.showAndPinTheatersPerBrand(brand: "롯데시네마")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "CGV", style: .default, handler: {(ACTION:UIAlertAction) in
            print("CGV")
            self.removeAnnotations()
            self.showAndPinTheatersPerBrand(brand: "CGV")
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "전체보기", style: .default, handler: {(ACTION:UIAlertAction) in
            print("전체보기")
            self.removeAnnotations()
            self.showAndPinTheaters(dataArray: self.theaterData.mapAnnotations)
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
    
    // iOS 위치 서비스 활성화여부 확인 (먼저)
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
     
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }

    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 위치 권한요청 팝업
            
        case .restricted, .denied:
            print("DENIED, 청년취업사관학교 영등포 캠퍼스가 맵뷰의 중심이 되도록 설정합니다.")
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            setRegionOnly(center: center) // 청년취업사관학교를 맵뷰 중심으로
            showRequestLocationServiceAlert() // 위치권한 허용하도록 설정으로 이동유도 팝업
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        default:
            print("DEFAULT")
            locationManager.startUpdatingLocation() // 현재위치를 맵뷰 중심으로
        }
    }
}

// MARK: - 세세한 함수 정하기
extension MapViewController {
    
    
    
    // 영화관 브랜드별 pin 설정
    func showAndPinTheatersPerBrand(brand: String) {
        
        let groupedTheater = Dictionary(grouping: theaterData.mapAnnotations) { $0.type }
        let filteredData = groupedTheater[brand]!
        
        showAndPinTheaters(dataArray: filteredData)
    }
    
    // 영화관 데이터들 표기하기
    func showAndPinTheaters(dataArray: [Theater]) {
        
        for theater in dataArray {
            let test = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            let brandName = theater.type
            let locationName = theater.location
            
            setAnnotationOnly(center: test, brand: brandName, location: locationName)
        }
    }
    
    // 맵뷰 중심 설정
    func setRegionOnly(center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
    }
    
    // 맵뷰내 pin 설정
    func setAnnotationOnly(center: CLLocationCoordinate2D, brand: String, location: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = brand
        annotation.subtitle = location
        
        mapView.addAnnotation(annotation)
    }
    
    // 모든 Annotation 삭제
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
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
