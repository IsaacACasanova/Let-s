//
//  CustomAnnotationView.m
//  MyLocationEvents
//
//  Created by Matt on 4/4/14.
//  Copyright (c) 2014 Matt. All rights reserved.
//

#import "CustomAnnotationView.h"

@implementation CustomAnnotationView

- (id) initWithAnnotationWithImage:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier annotationViewImage:(UIImage *)annotViewImage
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    self.image = annotViewImage;
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
