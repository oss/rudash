/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "EduRutgersDashDashboardViewProxy.h"
#import "EduRutgersDashDashboardItemProxy.h"
#import "EduRutgersDashDashboardView.h"
#import "TiUtils.h"
#import "RutgersLauncherItem.h"
#import "RutgersLauncherButton.h"
#import "RutgersLauncherView.h"

@implementation EduRutgersDashDashboardViewProxy

-(id)init
{
    if (self = [super init]) {
        [self setValue:[NSNumber numberWithBool:YES] forUndefinedKey:@"editable"];
    }
    return self;
}

-(void)startEditing:(id)args
{
    [self makeViewPerformSelector:@selector(startEditing) withObject:nil createIfNeeded:YES waitUntilDone:NO];
}

-(void)stopEditing:(id)args
{
    [self makeViewPerformSelector:@selector(stopEditing) withObject:nil createIfNeeded:YES waitUntilDone:NO];    
}

-(void)fireEvent:(NSString*)type withObject:(id)obj withSource:(id)source propagate:(BOOL)propagate reportSuccess:(BOOL)report errorCode:(int)code message:(NSString*)message
{
	if ([type isEqual:@"click"])
	{
		EduRutgersDashDashboardView *v = (EduRutgersDashDashboardView*)[self view];
		RutgersLauncherView *launcher = [v launcher];
		if (launcher.editing)
		{
			return;
		}
	}
	[super fireEvent:type withObject:obj withSource:source propagate:propagate];
}

-(void)setData:(id)data
{
    for (TiViewProxy* proxy in data) {
        ENSURE_TYPE(proxy, EduRutgersDashDashboardItemProxy)
        [self rememberProxy:proxy];
    }
    
    [self setValue:data forUndefinedKey:@"data"];
    [self makeViewPerformSelector:@selector(setViewData:) withObject:data createIfNeeded:YES waitUntilDone:YES];
}

@end

