//
//  Coordinator.swift
//  
//
//  Created by Артем Денисов on 18.09.2022.
//

import MapKit

public final class Coordinator: NSObject, MKMapViewDelegate{
    var mkMapWrapper: MKMapViewWrapper
    
    init(mkMapWrapper: MKMapViewWrapper) {
        self.mkMapWrapper = mkMapWrapper
    }
    
    func didSelect(annotation: MKAnnotation?){
        guard let action = mkMapWrapper.onAnnotationDidSelectAction else { return }
        guard let annotationValue = annotation else { return }
        action(annotationValue)
    }
    
    func didDeselect(annotation: MKAnnotation?){
        guard let action = mkMapWrapper.onAnnotationDidDeselectAction else { return }
        guard let annotationValue = annotation else { return }
        action(annotationValue)
    }
    
    //TODO CustomAnnotation
    //        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //
    //        }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        didSelect(annotation: view.annotation)
    }
    
    public func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        didDeselect(annotation: view.annotation)
    }
    
    @available(iOS 16, *)
    public func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        didSelect(annotation: annotation)
    }
    
    @available(iOS 16, *)
    public func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
        didDeselect(annotation: annotation)
    }
}
