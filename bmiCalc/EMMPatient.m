//
//  EMMPatient.m
//  bmiCalc
//
//  Created by Eric Martin on 6/25/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import "EMMPatient.h"

EMMPatient* SecretPatient;

#define male YES
#define female NO

@implementation EMMPatient
@synthesize height,weight,age,gender;
+(EMMPatient *)thePatient
{
    if(SecretPatient == nil)
    {
        SecretPatient=[[EMMPatient alloc]init];
    }
    return SecretPatient;
}
-(float)bmi
{
    float _height = [height floatValue];
    float _weight = [weight floatValue];
    return _weight/(_height*_height);
}

-(float)bmr
{
    if (gender == male)
    {
        
        float _height = [height floatValue];
        float _weight = [weight floatValue];
        int _age = [age intValue];
        NSLog(@"%g,%g,%d",_height,_weight,_age);
        return 66.0 + 13.7*_weight + 500.0*_height - 6.8*_age;
    }
    else
    {
        NSLog(@"FEMALE");
        float _height = [height floatValue];
        float _weight = [weight floatValue];
        int _age = [age intValue];
        return 655 + 9.6*_weight + 0.018*_height - 4.7*_age;
    }
}


@end
