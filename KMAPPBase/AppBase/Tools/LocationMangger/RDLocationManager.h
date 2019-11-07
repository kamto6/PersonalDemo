//
//  RDLocationManager.h
//  Reindeer
//
//  Created by Sword on 3/10/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RDLocationManager : NSObject

@property (nonatomic, assign) BOOL locating;        //正在定位
@property (nonatomic, assign) BOOL reversing;       //正在解析

+ (RDLocationManager*)sharedManager;

- (void)startLocate:(BOOL)needReverse completion:(void(^)(id location, NSError *error))completion;
- (void)startReverseCode:(CLLocationCoordinate2D)coordiante completion:(void(^)(id location, NSError *error))completion;
- (void)stopLocate;

@end
