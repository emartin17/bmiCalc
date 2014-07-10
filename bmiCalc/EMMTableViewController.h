//
//  EMMTableViewController.h
//  bmiCalc
//
//  Created by Eric Martin on 6/26/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StaticDataTableViewController.h"
#import "EMMPatient.h"


@interface EMMTableViewController : StaticDataTableViewController
<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

{
    IBOutlet UITextField *weightField;
    IBOutlet UITextField *heightField;
    
    IBOutlet UITextField *imperialWeightField;
    IBOutlet UITextField *heightFieldFeet;
    IBOutlet UITextField *heightFieldInches;
    
    IBOutlet UITextField *ageField;
    IBOutlet UITextField *genderField;
    
    IBOutlet UILabel *bmiLabel;
    IBOutlet UILabel *bmrLabel;
    
    IBOutlet UIProgressView *bmiScale;
    IBOutlet UIProgressView *bmrScale;
    
    IBOutlet UISegmentedControl *unitsControl;
    
    IBOutlet UITableViewCell *imperialHeight;
    IBOutlet UITableViewCell *metricHeight;
    
    IBOutlet UITableViewCell *imperialWeight;
    IBOutlet UITableViewCell *metricWeight;
}

@property (strong,nonatomic) NSArray *genderArray;
@property (strong,nonatomic) NSArray *metricTextFieldArray;
@property (strong,nonatomic) NSArray *imperialTextFieldArray;


@property (nonatomic, retain) UITextField *activeField;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnPrev;

@property(strong,nonatomic) NSMutableArray *activeArray;

@property(readwrite, retain) UIView *inputAccessoryView;

-(void)outputBMI;
-(void)outputBMR;
-(void)checkBoth;

-(void)clearBMI;
-(void)clearBMR;

-(UIToolbar*)createInputAccessoryView;

-(void)gotoPrevTextField;
-(void)gotoNextTextField;

-(float)customRounding:(float)value;

-(IBAction)switchUnits:(id)sender;

-(BOOL)containsNoEmptyTextFields:(NSArray*)textFieldArray;


@end
