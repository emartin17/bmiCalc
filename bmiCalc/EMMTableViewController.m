//
//  EMMTableViewController.m
//  bmiCalc
//
//  Created by Eric Martin on 6/26/14.
//  Copyright (c) 2014 Martin Developments. All rights reserved.
//

#import "EMMTableViewController.h"
#import "EMMPatient.h"

@implementation EMMTableViewController
@synthesize activeField;
@synthesize inputAccessoryView;
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrev;
@synthesize genderArray;
@synthesize textFieldArray;

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if(self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    textFieldArray = @[weightField,heightField,ageField,genderField];
    
    genderArray = @[@"Male", @"Female"];
    
    //picker exists in the view, but is outside visible range
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.delegate = self;
    picker.dataSource = self;
    genderField.inputView = picker;
    
    [weightField addTarget:self
                    action:@selector(checkBoth)
          forControlEvents:UIControlEventEditingChanged];
    
    [heightField addTarget:self action:@selector(checkBoth)forControlEvents:UIControlEventEditingChanged];
    
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
    UIToolbar *toolbar = [self createInputAccessoryView];
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
    [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
    [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
    float progessbar = [patient bmi];
    progessbar = progessbar - 15;
    progessbar = progessbar/15;
    bmiScale.progress = progessbar;
    bmiLabel.hidden = NO;
    bmiLabel.text = [NSString stringWithFormat:@"%g",[patient bmi]];
}

-(void)outputBMR
{
    EMMPatient *patient = [EMMPatient thePatient];
    [patient setHeight:[NSNumber numberWithFloat:[heightField.text floatValue]]];
    [patient setWeight:[NSNumber numberWithFloat:[weightField.text floatValue]]];
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
    bmrScale.progress = progressbar;
    bmrLabel.hidden = NO;
    bmrLabel.text = [NSString stringWithFormat:@"%g",[patient bmr]];
}

-(void)checkBoth
{
    if(![weightField.text isEqualToString:@""] && ![heightField.text isEqualToString:@""])
    {
        [self outputBMI];
    }
    else
    {
        [self clearBMI];
    }
    
    if(![weightField.text  isEqual: @""] && ![heightField.text  isEqual: @""] && ![ageField.text isEqualToString:@""] && ![genderField.text isEqualToString:@""])
    {
        [self outputBMR];
    }
    else
    {
        [self clearBMR];
    }
}

-(void)clearBMI
{
    bmiLabel.hidden = YES;
    bmiLabel.text = @"";
    bmiScale.progress = 0.0;
}

-(void)clearBMR
{
    bmrLabel.hidden = YES;
    bmrLabel.text = @"";
    bmrScale.progress = 0.0;
}

-(void)gotoPrevTextField
{
    if(![weightField isFirstResponder])
    {
        for(UITextField *fr in textFieldArray)
        {
            if([fr isFirstResponder])
            {
                [[textFieldArray objectAtIndex:[textFieldArray indexOfObject:fr]-1] becomeFirstResponder];
                break;
            }
            
        }
    }
}

-(void)gotoNextTextField
{
    if(![genderField isFirstResponder])
    {
        for(UITextField *fr in textFieldArray)
        {
            if([fr isFirstResponder])
            {
                [[textFieldArray objectAtIndex:[textFieldArray indexOfObject:fr]+1] becomeFirstResponder];
                break;
            }
            
        }
    }
}

-(void)resignAllResponders
{
    [weightField resignFirstResponder];
    [heightField resignFirstResponder];
    [ageField resignFirstResponder];
    [genderField resignFirstResponder];
}

-(UIToolbar*)createInputAccessoryView
{
    //UIColor* color = [UIColor colorWithRed: 0.812 green: 0.812 blue: 0.812 alpha: 1];
    
    inputAccessoryView = [[UIView alloc]initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccessoryView setBackgroundColor:[UIColor lightGrayColor]];
    [inputAccessoryView setAlpha:0.8];
    
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Previous"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoPrevTextField)];
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"Next"
                                   style: UIBarButtonItemStyleDone
                                   target: self
                                   action:@selector(gotoNextTextField)];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                   target: self
                                   action: nil];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                  target: self
                                  action:@selector(resignAllResponders)];
    
    NSArray *itemsArray = @[prevButton, nextButton, flexButton, doneButton];
    
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
        weightUnits.text = @"kg";
        heightUnits.text = @"m";
    }
    else
    {
        [patient setImperial:YES];
        weightUnits.text = @"lbs";
        heightUnits.text = @"in";
        //[heightField setFrame:CGRectMake(109, 6, 65, 30)];
    }
    [self checkBoth];
}

#pragma mark - UITableView Methods



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
