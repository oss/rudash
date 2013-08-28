/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2010 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 */


// A good bit of this code was derived from the Three20 project
// and was customized to work inside Titanium
//
// All modifications by Appcelerator are licensed under 
// the Apache License, Version 2.0
//
//
// Copyright 2009 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
#import <UIKit/UIKit.h>

@class RutgersLauncherButton;
@class RutgersLauncherItem;
@protocol RutgersLauncherViewDelegate;


@interface RutgersLauncherView : UIView<UIScrollViewDelegate> {
@private
	id<RutgersLauncherViewDelegate> delegate;
	UIScrollView *scrollView;
	UIPageControl *pager;
	NSMutableArray *pages;
	NSMutableArray *buttons;
	NSInteger columnCount;
	NSInteger rowCount;
    NSInteger lastIndex;
	RutgersLauncherButton *dragButton;
	NSTimer* editHoldTimer;
	NSTimer* springLoadTimer;
	UITouch* dragTouch;
	NSInteger positionOrigin;
	CGPoint dragOrigin;
	CGPoint touchOrigin;
	BOOL editing;
	BOOL springing;	
    BOOL editable;
    BOOL renderingButtons;
}

@property(nonatomic) NSInteger lastIndex;
@property(nonatomic) NSInteger columnCount;
@property(nonatomic) NSInteger rowCount;
@property(nonatomic) NSInteger currentPageIndex;
@property(nonatomic,assign) id<RutgersLauncherViewDelegate> delegate;
@property(nonatomic,readonly) BOOL editing;
@property(nonatomic,assign) BOOL editable;

- (void)addItem:(RutgersLauncherItem*)item animated:(BOOL)animated;
- (void)removeItem:(RutgersLauncherItem*)item animated:(BOOL)animated;

- (void)beginEditing;
- (void)endEditing;
- (void)recreateButtons;

- (RutgersLauncherItem*)itemForIndex:(NSInteger)index;
- (NSArray*)items;

@end


@protocol RutgersLauncherViewDelegate <NSObject>

@optional

- (void)launcherView:(RutgersLauncherView*)launcher didAddItem:(RutgersLauncherItem*)item;

- (void)launcherView:(RutgersLauncherView*)launcher didRemoveItem:(RutgersLauncherItem*)item;

- (void)launcherView:(RutgersLauncherView*)launcher willDragItem:(RutgersLauncherItem*)item;

- (void)launcherView:(RutgersLauncherView*)launcher didDragItem:(RutgersLauncherItem*)item;

- (void)launcherView:(RutgersLauncherView*)launcher didMoveItem:(RutgersLauncherItem*)item;

- (void)launcherView:(RutgersLauncherView*)launcher didSelectItem:(RutgersLauncherItem*)item;

- (void)launcherViewDidBeginEditing:(RutgersLauncherView*)launcher;

- (void)launcherViewDidEndEditing:(RutgersLauncherView*)launcher;

- (BOOL)launcherViewShouldWobble:(RutgersLauncherView*)launcher;

@end

