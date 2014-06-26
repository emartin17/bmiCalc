//
//  EMMPatient.h
//  bmiCalc
//
//  Created by Eric Martin on 6/25/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EMMPatient : NSObject

@property (nonatomic,retain) NSNumber* weight;

@property (nonatomic,retain) NSNumber* height;

@property (nonatomic,retain) NSNumber* age;

@property BOOL gender;

@property (readonly) float bmi;

@property (readonly) float bmr;


+(EMMPatient*)thePatient;
-(float)bmi;
-(float)bmr;


@end
