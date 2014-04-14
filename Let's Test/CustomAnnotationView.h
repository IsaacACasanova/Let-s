//
//  CustomAnnotationView.h
//  MyLocationEvents
//
//  Created by Matt on 4/4/14.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKPinAnnotationView

- (id) initWithAnnotationWithImage:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *)annotViewImage;

@end
