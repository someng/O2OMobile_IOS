//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#import "ServiceDebugger_DashCPUCell.h"
#import "ServiceDebugger_PlotsView.h"
#import "ServiceDebugger_Unit.h"
#import "ServiceDebugger_CPUModel.h"

#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceDebugger_DashCPUCell

SUPPORT_AUTOMATIC_LAYOUT( YES )
SUPPORT_RESOURCE_LOADING( YES )

- (void)load
{
	self.tappable = YES;
	self.backgroundColor = [UIColor clearColor];
	
	ServiceDebugger_PlotsView * plotsView = (ServiceDebugger_PlotsView *)$(@"#plots").view;
	
	plotsView.alpha = 0.9f;
	plotsView.lineColor = [UIColor colorWithWhite:0.6f alpha:1.0f];
	plotsView.capacity = MAX_CPU_HISTORY;
}

- (void)unload
{
}

- (void)dataDidChanged
{
	float percent = [ServiceDebugger_CPUModel sharedInstance].usage;
	if ( percent >= 0.9f )
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:YES];
		[UIView setAnimationRepeatCount:999999];
		
		self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
		
		[UIView commitAnimations];
	}
	else
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.6f];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationRepeatAutoreverses:NO];
		[UIView setAnimationRepeatCount:1];
		
		self.backgroundColor = [UIColor clearColor];

		[UIView commitAnimations];
	}

	ServiceDebugger_PlotsView * plotsView = (ServiceDebugger_PlotsView *)$(@"#plots").view;
	[plotsView setPlots:[ServiceDebugger_CPUModel sharedInstance].chartDatas];
	[plotsView setLowerBound:[ServiceDebugger_CPUModel sharedInstance].lowerBound];
	[plotsView setUpperBound:[ServiceDebugger_CPUModel sharedInstance].upperBound];
	[plotsView setNeedsDisplay];

	$(@"usage").DATA( [NSString stringWithFormat:@"usage: %.1f%%", percent * 100] );
}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
