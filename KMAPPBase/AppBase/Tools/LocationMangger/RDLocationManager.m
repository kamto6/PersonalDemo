//
//  WKSLocationManager.m
//  WisdomKunShan
//
//  Created by Sword on 3/10/15.
//
//

#import "RDLocationManager.h"
#import <CoreLocation/CoreLocation.h>
//#import "RDLocation.h"
//#import "RDCityModel.h"


@interface RDLocationManager()<CLLocationManagerDelegate>
{
   
   
}

@property (nonatomic, assign) BOOL needReverse;

@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic, strong)CLGeocoder        *geocoder;
@end

@implementation RDLocationManager


- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc]init];
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            
            if ([UIDevice currentDevice].systemVersion.floatValue > 8.0) {
                
                [_locationManager requestWhenInUseAuthorization];
                
            }
            
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;//设置定位精度
            _locationManager.distanceFilter = 10;//定位频率,每隔多少米定位一次
        }

        
    }
    return _locationManager;
}
- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc]init];
        
    }
    return _geocoder;
}
- (void)startLocate:(BOOL)needReverse completion:(void(^)(id location, NSError *error))completion
{
    self.needReverse = needReverse;
//    self.completion = completion;
//    if (!_locService) {
//        _locService = [[BMKLocationService alloc] init];
//    }
//    _locService.delegate = self;
//    [_locService startUserLocationService];
    [self startLocate];
    
}
- (void)startLocate{
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}
- (void)stopLocate{
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
}

- (void)startReverseCode:(CLLocationCoordinate2D)coordiante completion:(void(^)(id location, NSError *error))completion
{
//    self.completion = completion;
   
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self stopLocate];
    CLLocation *userLocation = [locations firstObject];
//    RDLocation *location = [[RDLocation alloc]init];
//    location.coordinate = userLocation.coordinate;
//    _location = location;
    if (!self.needReverse) {
//        if (_completion) {
//            _completion(_location, nil);
//        }
    }else{
        [self getAddressWithCoordinate:userLocation.coordinate];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    if (_completion) {
//        _completion(nil, error);
//    }
}
- (void)getAddressWithCoordinate:(CLLocationCoordinate2D)coordinate{
    
    CLLocation *location =  [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
//            if (_completion) {
//                _completion(nil, error);
//            }
            return ;
        }
        CLPlacemark *mark = [placemarks firstObject];
//        RDCityModel *city = [[RDCityModel alloc] init];
//        if (mark.addressDictionary[@"Country"]) {
//            NSString *country = mark.addressDictionary[@"Country"];
//            NSString *countryCode = mark.addressDictionary[@"CountryCode"];
//            if ([country isEqualToString:@"中国"]&&[countryCode isEqualToString:@"CN"]) {
//                DATA_ENV.isChina = TRUE;
//            }
//        }
//
//        if (mark.addressDictionary[@"City"]) {
//            NSMutableString *cityName = [NSMutableString stringWithString:mark.addressDictionary[@"City"]];
//            if (cityName && cityName.length >= 1) {
//                [cityName deleteCharactersInRange:NSMakeRange(cityName.length - 1, 1)];
//                city.name = cityName;
//            }
//        }else{
//            city.name = @"";
//        }
//
//        _location.cityModel = city;
//        if (mark.name && mark.name.length) {
//            _location.address = mark.name;
//        }
        
//        if (_completion) {
//            _completion(_location, nil);
//        }
    }];
}
@end
