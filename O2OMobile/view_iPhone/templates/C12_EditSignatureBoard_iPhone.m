//
//       _/_/_/                      _/            _/_/_/_/_/
//    _/          _/_/      _/_/    _/  _/              _/      _/_/      _/_/
//   _/  _/_/  _/_/_/_/  _/_/_/_/  _/_/              _/      _/    _/  _/    _/
//  _/    _/  _/        _/        _/  _/          _/        _/    _/  _/    _/
//   _/_/_/    _/_/_/    _/_/_/  _/    _/      _/_/_/_/_/    _/_/      _/_/
//
//
//  Copyright (c) 2015-2016, Geek Zoo Studio
//  http://www.geek-zoo.com
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "C12_EditSignatureBoard_iPhone.h"

#import "AppBoard_iPhone.h"

#pragma mark -

@implementation C12_EditSignatureBoard_iPhone

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

DEF_SINGLETON( C12_EditSignatureBoard_iPhone )

DEF_OUTLET( BeeUITextView,	signature );
DEF_OUTLET( BeeUILabel,		remain );

@synthesize backWhenSucceed = _backWhenSucceed;
@synthesize userModel = _userModel;

- (void)load
{
	self.userModel = [UserModel sharedInstance];
	[self.userModel addObserver:self];
}

- (void)unload
{
	[self.userModel removeObserver:self];
	self.userModel = nil;
}

#pragma mark - Signal

ON_CREATE_VIEWS( signal )
{
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.navigationBarShown = YES;
	self.navigationBarLeft = [UIImage imageNamed:@"back_button.png"];
	self.navigationBarTitle = __TEXT(@"personal_signature");
	self.navigationBarRight = __TEXT(@"save");
	
	[self updateRemain];
}

ON_DELETE_VIEWS( signal )
{
}

ON_LAYOUT_VIEWS( signal )
{
}

ON_WILL_APPEAR( signal )
{
	self.signature.text = self.userModel.user.signature;

	[AppBoard_iPhone sharedInstance].menuPannable = NO;
	
	[self updateRemain];
}

ON_DID_APPEAR( signal )
{
	self.signature.userInteractionEnabled = YES;
	self.signature.editable = YES;
	
	[self.signature becomeFirstResponder];
	
	[self updateRemain];
}

ON_WILL_DISAPPEAR( signal )
{
	[AppBoard_iPhone sharedInstance].menuPannable = NO;
}

ON_DID_DISAPPEAR( signal )
{
}

ON_SIGNAL3( BeeUINavigationBar, LEFT_TOUCHED, signal )
{
	[self.stack popBoardAnimated:YES];
}

ON_SIGNAL3( BeeUINavigationBar, RIGHT_TOUCHED, signal )
{
	if ( nil == self.signature.text || self.signature.text.length == 0 )
	{
		[self presentMessageTips:@"请输入正确的签名"];
		[self.signature becomeFirstResponder];
		return;
	}
	
	[self.userModel changeSignature:self.signature.text];
}

#pragma mark -

ON_SIGNAL2( BeeUITextView, signal )
{
	[self updateRemain];
}

- (void)updateRemain
{
	self.remain.text = [NSString stringWithFormat:@"%d", 20 - self.signature.text.length];
}

#pragma MARK -

ON_SIGNAL3( UserModel, PROFILE_UPDATING, signal )
{
	[self presentLoadingTips:@"正在提交..."];
	
	[self.signature resignFirstResponder];
}

ON_SIGNAL3( UserModel, PROFILE_UPDATED, signal )
{
	[self dismissTips];
	[self.view.window presentSuccessTips:__TEXT(@"signature_success")];

	if ( self.backWhenSucceed )
	{
		[self.stack popBoardAnimated:YES];
	}
}

ON_SIGNAL3( UserModel, PROFILE_FAILED, signal )
{
	[self dismissTips];
}

@end
