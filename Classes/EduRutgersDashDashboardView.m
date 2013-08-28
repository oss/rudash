/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "EduRutgersDashDashboardView.h"
#import "TiUtils.h"
#import "TiRect.h"
#import "EduRutgersDashDashboardViewProxy.h"
#import "EduRutgersDashDashboardItemProxy.h"
#import "RutgersLauncherView.h"
#import "RutgersLauncherItem.h"
#import "RutgersLauncherButton.h"

@implementation EduRutgersDashDashboardView

-(void)dealloc
{
	launcher.delegate = nil;
	if (launcher.editing)
	{
		[launcher endEditing];
	}
	RELEASE_TO_NIL(launcher);
	[super dealloc];
}

-(RutgersLauncherView*)launcher
{
	if (launcher==nil)
	{
        int rowCount = [TiUtils intValue:[self.proxy valueForKey:@"rowCount"] def:3];
        int columnCount = [TiUtils intValue:[self.proxy valueForKey:@"columnCount"] def:3];
        launcher = [[RutgersLauncherView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)
                                          withRowCount:rowCount
                                       withColumnCount:columnCount];
		launcher.delegate = self;
        [launcher setEditable:[[[self proxy] valueForUndefinedKey:@"editable"] boolValue]];
		[self addSubview:launcher];
	}
	return launcher;
}

-(void)frameSizeChanged:(CGRect)frame bounds:(CGRect)bounds
{
	if (!CGRectIsEmpty(bounds))
	{
		[TiUtils setView:launcher positionRect:bounds];
		[launcher recreateButtons];
        [launcher setCurrentPageIndex:[launcher lastIndex]];
	}
    [super frameSizeChanged:frame bounds:bounds];
}

-(void)setEditable_:(id)args
{
    ENSURE_TYPE(args, NSNumber);
    
    if (launcher != nil) {
        [launcher setEditable:[args boolValue]];
    }
    [[self proxy] replaceValue:args forKey:@"editable" notification:NO];
}

-(void)setViewData:(id)args
{
	[self launcher];
    NSArray* items = [launcher items];
    for (RutgersLauncherItem* item in items) {
        [launcher removeItem:item animated:NO];
    }
	
	for (EduRutgersDashDashboardItemProxy *proxy in args)
	{
		[launcher addItem:proxy.item animated:NO];
	}
}

-(void)startEditing
{
	[launcher beginEditing];
}

-(void)stopEditing
{
	[launcher endEditing];
}


#pragma mark Delegates 

- (void)launcherView:(RutgersLauncherView*)launcher didAddItem:(RutgersLauncherItem*)item
{
}

- (void)launcherView:(RutgersLauncherView*)launcher_ didRemoveItem:(RutgersLauncherItem*)item
{
	// update our data array
    [[self proxy] forgetProxy:item.userData];
	[self.proxy replaceValue:[launcher items] forKey:@"data" notification:NO];

	NSMutableDictionary *event = [NSMutableDictionary dictionary];
	[event setObject:item.userData forKey:@"item"];
	
	if ([self.proxy _hasListeners:@"delete"])
	{
		[self.proxy fireEvent:@"delete" withObject:event];
	}
	if ([item.userData _hasListeners:@"delete"])
	{
		[item.userData fireEvent:@"delete" withObject:event];
	}
}

- (void)launcherView:(RutgersLauncherView*)launcher_ willDragItem:(RutgersLauncherItem*)item
{
	NSMutableDictionary *event = [NSMutableDictionary dictionary];
	// the actual item being moved
	[event setObject:item.userData forKey:@"item"];
	
	if ([self.proxy _hasListeners:@"dragStart"])
	{
		[self.proxy fireEvent:@"dragStart" withObject:event];
	}
	if ([item.userData _hasListeners:@"dragStart"])
	{
		[item.userData fireEvent:@"dragStart" withObject:event];
	}
}

- (void)launcherView:(RutgersLauncherView*)launcher_ didDragItem:(RutgersLauncherItem*)item
{
	NSMutableDictionary *event = [NSMutableDictionary dictionary];
	// the actual item being moved
	[event setObject:item.userData forKey:@"item"];
	
	if ([self.proxy _hasListeners:@"dragEnd"])
	{
		[self.proxy fireEvent:@"dragEnd" withObject:event];
	}
	if ([item.userData _hasListeners:@"dragEnd"])
	{
		[item.userData fireEvent:@"dragEnd" withObject:event];
	}
}

- (void)launcherView:(RutgersLauncherView*)launcher_ didMoveItem:(RutgersLauncherItem*)item
{
	NSMutableDictionary *event = [NSMutableDictionary dictionary];
	// the actual item being moved
	[event setObject:item.userData forKey:@"item"];
	// the new (uncommitted) items in order
	[event setObject:[launcher items] forKey:@"items"];
	
	if ([self.proxy _hasListeners:@"move"])
	{
		[self.proxy fireEvent:@"move" withObject:event];
	}
	if ([item.userData _hasListeners:@"move"])
	{
		[item.userData fireEvent:@"move" withObject:event];
	}
}

- (void)launcherView:(RutgersLauncherView*)launcher didSelectItem:(RutgersLauncherItem*)item
{
	NSMutableDictionary *event = [NSMutableDictionary dictionary];
	[event setObject:item.userData forKey:@"item"];
	
	// convert our location to the location within our superview
	CGRect curFrame = [self convertRect:item.button.frame toView:[self superview]];
	TiRect *rect = [[TiRect alloc] _initWithPageContext:[self.proxy pageContext]];
	[rect setRect:curFrame];
	[event setObject:rect forKey:@"location"];
	[rect release];
	
	if ([self.proxy _hasListeners:@"click"])
	{
		[self.proxy fireEvent:@"click" withObject:event];
	}
	if ([item.userData _hasListeners:@"click"])
	{
		[item.userData fireEvent:@"click" withObject:event];
	}
}

- (void)launcherViewDidBeginEditing:(RutgersLauncherView*)launcher
{
	if ([self.proxy _hasListeners:@"edit"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[self.proxy fireEvent:@"edit" withObject:event];
	}
}

- (void)launcherViewDidEndEditing:(RutgersLauncherView*)launcher_
{
	// update our data array since it's possible been reordered
	[self.proxy replaceValue:[launcher_ items] forKey:@"data" notification:NO];
	
	if ([self.proxy _hasListeners:@"commit"])
	{
		NSMutableDictionary *event = [NSMutableDictionary dictionary];
		[self.proxy fireEvent:@"commit" withObject:event];
	}
}

- (BOOL)launcherViewShouldWobble:(RutgersLauncherView *)launcher_
{
	// all the wobble effect to be turned off if required by Apple
	return [TiUtils boolValue:[self.proxy valueForUndefinedKey:@"wobble"] def:YES];
}


@end

