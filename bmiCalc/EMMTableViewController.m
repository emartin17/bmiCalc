//
//  EMMTableViewController.m
//  bmiCalc
//
//  Created by Eric Martin on 6/26/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import "EMMTableViewController.h"


@implementation EMMTableViewController
@synthesize activeField;
@synthesize inputAccessoryView;
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrev;
@synthesize genderArray;
@synthesize metricTextFieldArray;
@synthesize imperialTextFieldArray;
@synthesize activeArray;

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self) {
        // Custom initialization
    }
    return self;
    NSLog(@"HI");
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hideSectionsWithHiddenRows = NO;
    [self cell:imperialHeight setHidden:YES];
    [self cell:imperialWeight setHidden:YES];
    [self reloadDataAnimated:NO];
    
    
    
    metricTextFieldArray = @[weightField,heightField,ageField,genderField];
    imperialTextFieldArray = @[imperialWeightField,heightFieldFeet,heightFieldInches,ageField,genderField];
    
    activeArray = [NSMutableArray arrayWithArray:metricTextFieldArray];
    
    
    genderArray = @[@"Male", @"Female"];
    
    //picker exists in the view, but is outside visible range
    UIPickerView *genderPicker = [[UIPickerView alloc] init];
    genderPicker.delegate = self;
    genderPicker.dataSource = self;
    
    UIPickerView *activityLevelPicker = [[UIPickerView alloc] init];
    activityLevelPicker.delegate = self;
    activityLevelPicker.dataSource = self;
    
    UIPickerView *targetPicker = [[UIPickerView alloc] init];
    targetPicker.delegate = self;
    targetPicker.dataSource = self;
    
    genderField.inputView = genderPicker;
    
    [weightField addTarget:self
                    action:@selector(checkBoth)
          forControlEvents:UIControlEventEditingChanged];
    
    [imperialWeightField addTarget:self action:@selector(checkBoth) forControlEvents:UIControlEventEditingChanged];
    
    [heightField addTarget:self action:@selector(checkBoth)forControlEvents:UIControlEventEditingChanged];
    
    [heightFieldFeet addTarget:self action:@selector(checkBoth) forControlEvents:UIControlEventEditingChanged];
    
    [heightFieldInches addTarget:self action:@selector(checkBoth) forControlEvents:UIControlEventEditingChanged];
    
    [ageField addTarget:self action:@selector(checkBoth) forControlEvents:UIControlEventEditingChanged];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate Methods


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar *toolbar = [self createInputAccessoryViewForTextField:textField];
    [toolbar sizeToFit];
    [textField setInputAccessoryView: toolbar];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if([genderField isFirstResponder] && [genderField.text isEqualToString:@""])
    {
        genderField.text = @"Male";
        [self checkBoth];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MyMethods

-(void)outputBMI
{
    EMMPatient *patient = [EMMPatient thePatient];
    if([patient imperial])
    {
        [patient setHeight:[NSNumber numberWithFloat:[heightFieldFeet.text floatValue]*12+[heightFieldInches.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[imperialWeightField.text floatValue]]];
    }
    else
    {
        [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
    }
    float progressbar = [patient bmi];
    progressbar = (progressbar-10)/40;
    NSLog(@"%f",progressbar);
    if(progressbar < 0.0)
    {
        [bmiScale setProgress:0.0 animated:YES];
    }
    else if(progressbar > 1.0)
    {
        [bmiScale setProgress:1.0 animated:YES];
    }
    else
    {
        [bmiScale setProgress:progressbar animated:YES];
    }
    
    if([patient bmi] < 16.0)
    {
        bmiInfo.text = @"Severly Underweight";
    }
    else if (16.0 < [patient bmi] < 18.5)
    {
        bmiInfo.text = @"Underweight";
    }
    else if (18.25 < [patient bmi] < 25)
    {
        bmiInfo.text = @"Normal Weight";
    }
    else if (25 < [patient bmi] < 30)
    {
        bmiInfo.text = @"Overweight";
    }
    else if (30 < [patient bmi])
    {
        bmiInfo.text = @"Obese";
    }
    
    [UIView transitionWithView:bmiLabel duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    bmiLabel.hidden = NO;
    bmiLabel.text = [NSString stringWithFormat:@"%g",[patient bmi]];
}

-(void)outputBMR
{
    EMMPatient *patient = [EMMPatient thePatient];
    if([patient imperial])
    {
        int feetInInch = [heightFieldFeet.text intValue]*12;
        [patient setHeight:[NSNumber numberWithFloat:feetInInch+[heightFieldInches.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[imperialWeightField.text floatValue]]];
    }
    else
    {
        [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
        [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
    }
    [patient setAge:[NSNumber numberWithInt:[ageField.text intValue]]];
    if([genderField.text isEqualToString:@"Male"])
    {
        [patient setGender:YES];
    }
    else
    {
        [patient setGender:NO];
    }
    float progressbar = [patient bmr];
    progressbar = progressbar - 800;
    progressbar = progressbar/2200;
    if(progressbar < 0)
    {
        [bmrScale setProgress:0.0 animated:YES];
    }
    else
    {
        [bmrScale setProgress:progressbar animated:YES];
    }
    
    [UIView transitionWithView:bmrLabel duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    bmrLabel.hidden = NO;
    bmrLabel.text = [NSString stringWithFormat:@"%g",[patient bmr]];
}

-(void)checkBoth
{
    EMMPatient *p = [EMMPatient thePatient];
    if(![p imperial])
    {
        if([self containsNoEmptyTextFields:@[weightField,heightField]])
        {
            [self outputBMI];
        }
        else
        {
            [self clearBMI];
        }
        
        if([self containsNoEmptyTextFields:@[weightField,heightField]] && ![ageField.text isEqualToString:@""] && ![genderField.text isEqualToString:@""])
        {
            [self outputBMR];
        }
        else
        {
            [self clearBMR];
        }
    }
    else
    {
        if ([self containsNoEmptyTextFields:@[imperialWeightField]] && ([self containsNoEmptyTextFields:@[heightFieldInches]] || [self containsNoEmptyTextFields:@[heightFieldFeet]]))
        {
            [self outputBMI];
        }
        else
        {
            [self clearBMI];
        }
        
        if ([self containsNoEmptyTextFields:@[imperialWeightField]] && ([self containsNoEmptyTextFields:@[heightFieldInches]] || [self containsNoEmptyTextFields:@[heightFieldFeet]]) && ![ageField.text isEqualToString:@""] && ![genderField.text isEqualToString:@""])
        {
            [self outputBMR];
        }
        else
        {
            [self clearBMR];
        }
    }
    
}
-(void)clearBMI
{
    [UIView transitionWithView:bmiLabel duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    bmiLabel.hidden = YES;
    bmiLabel.text = @"";
    [bmiScale setProgress:0.0 animated:YES];
    bmiInfo.text = @"";
    
}

-(void)clearBMR
{
    [UIView transitionWithView:bmrLabel duration:0.6 options:UIViewAnimationOptionTransitionCrossDissolve animations:NULL completion:NULL];
    
    bmrLabel.hidden = YES;
    bmrLabel.text = @"";
    [bmrScale setProgress:0.0 animated:YES];
}

-(void)gotoPrevTextField
{
    if(![[activeArray objectAtIndex:0] isFirstResponder])
    {
        for(UITextField *fr in activeArray)
        {
            if([fr isFirstResponder])
            {
                [[activeArray objectAtIndex:[activeArray indexOfObject:fr]-1] becomeFirstResponder];
                break;
            }
            
        }
    }
}

-(void)gotoNextTextField
{
    int lastIndex = [activeArray count] - 1;
    if(![[activeArray objectAtIndex:lastIndex] isFirstResponder])
    {
        for(UITextField *fr in activeArray)
        {
            if([fr isFirstResponder])
            {
                [[activeArray objectAtIndex:[activeArray indexOfObject:fr]+1] becomeFirstResponder];
                break;
            }
            
        }
    }
}

-(void)resignAllResponders
{
    [weightField resignFirstResponder];
    [imperialWeightField resignFirstResponder];
    [heightField resignFirstResponder];
    [heightFieldFeet resignFirstResponder];
    [heightFieldInches resignFirstResponder];
    [ageField resignFirstResponder];
    [genderField resignFirstResponder];
}

-(UIToolbar*)createInputAccessoryViewForTextField:(UITextField *)textField
{
    inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccessoryView setBackgroundColor:[UIColor lightGrayColor]];
    [inputAccessoryView setAlpha:0.8];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"UIButtonBarArrowLeft@2x.png"]
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoPrevTextField)];
    if(textField == [activeArray objectAtIndex:0])
    {
        prevButton.enabled = NO;
    }
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace
                                    target: self
                                    action: nil];
    fixedButton.width = 20.0;
    
    
    
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"UIButtonBarArrowRight@2x.png"]
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoNextTextField)];
    if(textField == [activeArray objectAtIndex:[activeArray count]-1])
    {
        nextButton.enabled = NO;
    }
    
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target: self
                                   action: nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                  target: self
                                  action:@selector(resignAllResponders)];
    
    NSArray *itemsArray = @[prevButton, fixedButton, nextButton, flexButton, doneButton];
    
    UIToolbar *bar = [[UIToolbar alloc]init];
    [bar setItems: itemsArray];
    return bar;
}

-(IBAction)switchUnits:(id)sender
{
    EMMPatient *patient = [EMMPatient thePatient];
    if ([unitsControl selectedSegmentIndex] == 0)
    {
        [patient setImperial:NO];
        self.hideSectionsWithHiddenRows = NO;
        [self cell:metricHeight setHidden:NO];
        [self cell:imperialHeight setHidden:YES];
        [self cell:metricWeight setHidden:NO];
        [self cell:imperialWeight setHidden:YES];
        [self reloadDataAnimated:YES];
        
        activeArray = [NSMutableArray arrayWithArray:metricTextFieldArray];
        
        if(![imperialWeightField.text isEqualToString:@""])
        {
            weightField.text = [NSString stringWithFormat:@"%g",roundf([self customRounding:[imperialWeightField.text floatValue]]/(20.0/9.0))];
        }
        if(![heightFieldFeet.text isEqualToString:@""] || ![heightFieldInches.text isEqualToString:@""])
        {
            heightField.text = [NSString stringWithFormat:@"%g",roundf([self customRounding:([heightFieldFeet.text intValue]*12+[heightFieldInches.text floatValue])*0.025])];
        }
        
    }
    else
    {
        [patient setImperial:YES];
        
        self.hideSectionsWithHiddenRows = NO;
        [self cell:metricHeight setHidden:YES];
        [self cell:imperialHeight setHidden:NO];
        [self cell:metricWeight setHidden:YES];
        [self cell:imperialWeight setHidden:NO];
        [self reloadDataAnimated:YES];
        
        activeArray = [NSMutableArray arrayWithArray:imperialTextFieldArray];
        if(![weightField.text isEqualToString:@""])
        {
            imperialWeightField.text = [NSString stringWithFormat:@"%g",roundf([self customRounding:[weightField.text floatValue]]*(20.0/9.0))];
        }
        if(![heightField.text isEqualToString:@""])
        {
            NSLog(@"%@",heightField.text);
            float totalInches = [heightField.text floatValue]*40.0;
            NSLog(@"%g",totalInches);
            int feet = totalInches/12;
            float inches = (totalInches)-(feet*12);
            heightFieldInches.text = [NSString stringWithFormat:@"%g",roundf([self customRounding:inches])];
            heightFieldFeet.text = [NSString stringWithFormat:@"%d",feet];
        }
    }
    [self checkBoth];
}

-(IBAction)touchToDismiss:(id)sender
{
    [self resignAllResponders];
}

-(float)customRounding:(float)value {
    const float roundingValue = 0.01;
    int mulitpler = floor(value / roundingValue);
    return mulitpler * roundingValue;
}

-(BOOL)containsNoEmptyTextFields:(NSArray*)textFieldArray
{
    for(UITextField *field in textFieldArray)
    {
        if([field.text isEqualToString:@""] || [field.text floatValue] == 0.0)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - PickerView Methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [genderArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return genderArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    genderField.text = genderArray[row];
    [self checkBoth];
}


@end
