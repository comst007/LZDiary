//
//  LZLocation.m
//  LZDiary
//
//  Created by comst on 16/9/21.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZLocation.h"
#import <CoreLocation/CoreLocation.h>

@interface LZLocation ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation LZLocation
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.manager = [[CLLocationManager alloc] init];
        self.manager.delegate = self;
        
        self.geocoder = [[CLGeocoder alloc] init];
        self.manager.distanceFilter = kCLDistanceFilterNone;
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.manager.pausesLocationUpdatesAutomatically = YES;
        self.manager.headingFilter = kCLHeadingFilterNone;
        
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        
        if ( status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse ) {
            [self.manager startUpdatingLocation];
        }
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.manager requestWhenInUseAuthorization];
        }
        

    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.manager startUpdatingLocation];
    }else{
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *currentlocation = [locations lastObject];
    [self.manager stopUpdatingHeading];
     __weak typeof(self) weakSelf = self;
    [self.geocoder reverseGeocodeLocation:currentlocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *currentPl = [placemarks firstObject];
        
        
        NSLog(@"placeMark: %@", currentPl.locality);
        weakSelf.address = currentPl.locality;
        
        if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(locationDidUpdate:)]) {
            [weakSelf.delegate locationDidUpdate:weakSelf];
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"location fail : %@", error.localizedDescription);
    [self.manager stopUpdatingHeading];
    self.address = @"";
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(locationDidUpdate:)]) {
        [self.delegate locationDidUpdate:self];
    }
}
@end
