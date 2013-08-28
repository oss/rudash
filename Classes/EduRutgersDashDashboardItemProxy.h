/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */
#import "TiViewProxy.h"
#import "RutgersLauncherItem.h"

@interface EduRutgersDashDashboardItemProxy : TiViewProxy {
@private
	RutgersLauncherItem *item;
}

@property(nonatomic,readwrite,retain) RutgersLauncherItem *item;

@end

