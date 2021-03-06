//
//  CreateBankAccountViewController.m
//  MoneyManagerEx
//
//  Created by taotao on 2016/11/12.
//  Copyright © 2016年 taotao. All rights reserved.
//

#import "CreateBankAccountViewController.h"
#import "MMEXDataPickerView.h"
#import "AccountModel.h"
#import "BankAccountType.h"
#import "SCLAlertView.h"

@interface CreateBankAccountViewController ()<DataPickerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankAccountNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankAccountTypeValueLabel;
@property (strong, nonatomic) MMEXDataPickerView *dataPickerView;

@property (nonatomic, strong) AccountModel *account;
@property (nonatomic, weak) id<CreateBankAccountDelegate> delegate;

- (IBAction)accountTypeBtnPressed:(id)sender;

@end

@implementation CreateBankAccountViewController

- (instancetype)initWithDelegate:(id<CreateBankAccountDelegate>)delegate
{
    if (self = [self initWithNibName:@"CreateBankAccountViewController" bundle:nil]) {
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initControlConfig];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControlConfig
{
    self.title = NSLocalizedString(@"Create Bank Account", nil);
    _bankAccountNameTextField.placeholder = NSLocalizedString(@"Bank Account Name", nil);
    [_bankAccountNameTextField becomeFirstResponder];
    _bankAccountNameTextField.delegate = self;
    [_bankAccountNameTextField enablesReturnKeyAutomatically];
    _bankAccountTypeLabel.text = NSLocalizedString(@"Bank Account Type", nil);
    
    _bankAccountTypeValueLabel.text = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelCreateBankAccount)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveCreateBankAccount)];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)initData
{
    _account = [[AccountModel alloc] init];
}

#pragma mark - setter

#pragma mark - getter

- (MMEXDataPickerView *)dataPickerView
{
    if (!_dataPickerView) {
        _dataPickerView = [MMEXDataPickerView getNewInstanceWithData:[[BankAccountType shareInstance] getAllTypeName] parentHeight:self.view.frame.size.height delegate:self];
        
        [self.view addSubview:_dataPickerView];
    }
    
    return _dataPickerView;
}

#pragma mark - action

- (IBAction)accountTypeBtnPressed:(id)sender
{
    [_bankAccountNameTextField resignFirstResponder];
    [self.dataPickerView hide:!self.dataPickerView.invisible];
}

- (void)cancelCreateBankAccount
{
    [_bankAccountNameTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveCreateBankAccount
{
    [_bankAccountNameTextField resignFirstResponder];
    
    if (_account.name.length <= 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundType = SCLAlertViewBackgroundTransparent;
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        
        [alert showNotice:self title:NSLocalizedString(@"Create Bank Account name is nil", nil) subTitle:nil closeButtonTitle:NSLocalizedString(@"Confirm", nil) duration:2];
        return;
    }
    
    if ([_account.type integerValue] == 0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        alert.backgroundType = SCLAlertViewBackgroundTransparent;
        alert.showAnimationType = SCLAlertViewShowAnimationFadeIn;
        
        [alert showNotice:self title:NSLocalizedString(@"Create Bank Account type is nil", nil) subTitle:nil closeButtonTitle:NSLocalizedString(@"Confirm", nil) duration:2];
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(didCreateBankAccount:)]) {
        [_delegate didCreateBankAccount:_account];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapView
{
    [_bankAccountNameTextField resignFirstResponder];
    if (!self.dataPickerView.invisible) {
        [self.dataPickerView hide:YES];
    }
}

#pragma mark - DataPickerDelegate

- (void)didSelectData:(NSInteger)data
{
    [self.dataPickerView hide:YES];
    _account.type = [NSNumber numberWithInteger:data];
    _bankAccountTypeValueLabel.text = [[BankAccountType shareInstance] typeNameOfIndex:data];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _account.name = textField.text;
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
