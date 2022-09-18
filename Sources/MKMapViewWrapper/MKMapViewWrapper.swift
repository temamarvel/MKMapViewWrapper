//
//  MKMapViewWrapper.swift
//
//  Created by Артем Денисов on 24.06.2022.
//

import SwiftUI
import MapKit

public struct MKMapViewWrapper : UIViewRepresentable{
    @Binding var region: MKCoordinateRegion
    @Binding var pointOfInterestFilter: MKPointOfInterestFilter
    var showsUserLocation: Bool
    var showsScale: Bool
    var annotations: [MKAnnotation]? = nil
    
    internal var onAnnotationDidSelectAction: ((MKAnnotation?) -> Void)? = nil
    internal var onAnnotationDidDeselectAction: ((MKAnnotation?) -> Void)? = nil
    
    public init<Items, Annotation>(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll), annotationsDataItems: Items, annotationContent: @escaping (Items.Element) -> Annotation) where Items: RandomAccessCollection, Items.Element: Identifiable, Annotation: MKAnnotation {
        self.init(region: region, showsUserLocation: showsUserLocation, showsScale: showsScale)
        self.annotations = annotationsDataItems.map(annotationContent)
    }
    
    public init(region: Binding<MKCoordinateRegion>, showsUserLocation: Bool = true, showsScale: Bool = false, pointOfInterestFilter: Binding<MKPointOfInterestFilter> = .constant(.excludingAll)) {
        self._region = region
        self._pointOfInterestFilter = pointOfInterestFilter
        self.showsUserLocation = showsUserLocation
        self.showsScale = showsScale
    }
    
    public func makeUIView(context: UIViewRepresentableContext<MKMapViewWrapper>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = showsUserLocation
        mapView.showsScale = showsScale
        mapView.pointOfInterestFilter = pointOfInterestFilter
        if let annotations = self.annotations {
            mapView.addAnnotations(annotations)
        }
        return mapView
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMapRegion(mapView: uiView, region: region)
    }
    
    func updateMapRegion(mapView: MKMapView, region: MKCoordinateRegion){
        mapView.setRegion(region, animated: true)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(mkMapWrapper: self)
    }
    
    public func onAnnotationDidSelect(_ action: @escaping (MKAnnotation?) -> Void) -> MKMapViewWrapper {
        var newMapWrapper = self
        newMapWrapper.onAnnotationDidSelectAction = action
        return newMapWrapper
    }
    
    public func onAnnotationDidDeselect(_ action: @escaping (MKAnnotation?) -> Void) -> MKMapViewWrapper {
        var newMapWrapper = self
        newMapWrapper.onAnnotationDidDeselectAction = action
        return newMapWrapper
    }
}
