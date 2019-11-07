//
//  MKMapView+Zoom.h
//  Reindeer
//
//  Created by 揭康伟 on 17/5/23.
//  Copyright © 2017年 Sword. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Zoom)
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
