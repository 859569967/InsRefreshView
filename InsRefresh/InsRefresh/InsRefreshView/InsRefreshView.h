//
//  InsRefreshView.h
//  AVInsurance
//
//  Created by Dylan on 2016/8/3.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsRefreshView : UIView

/**
 初始化方法, 对scrollView的contentOffset属性做了监听
 @param scrollView 希望监听的ScrollView
 
 Initialize method, observe `contentOffset` property in scrollView.
 */
+ (instancetype) viewWithScroll: (UIScrollView *) scrollView;

/**
 是否正在刷新
 The refresh control statu.
 */
@property ( nonatomic, assign, readonly ) BOOL isRefresh;

/**
 开始下拉刷新
 Begin pull to refresh when the `isRefresh` flag is `YES`.
 */
- (void) beginRefresh;

/**
 结束下拉刷新
 End refresh, set the `isRefresh` flag to `NO`.
 */
- (void) endinRefresh;

/**
 触发Refresh会调用Block
 Trigger the refresh action will call this block.
 */
@property ( nonatomic, copy ) void (^triggeredRefresh) (InsRefreshView * refreshView);

/**
 是否正在加载更多
 The load more statu.
 */
@property ( nonatomic, assign, readonly) BOOL isLoadMore;

/**
 当滑动视图距离底部多少的时候触发自动加载更多block
 Between scrolling y and ScrollView bottom, when less than it, will trigger the load more block.
 */
@property ( nonatomic, assign ) CGFloat bottomInset;

/**
 开始加载更多
 Begin load more, trigger the loadmore block.
 */
- (void) beginLoadMore;

/**
 结束加载更多, 这个方法需要在加载更多函数中调用
 End loadmore, set the `isLoadMore` flag to `NO`, if not, refreshView will call loadmore block once.
 @code
 [ref setTriggeredLoadMore:^(InsRefreshView * refresh) {
 ...
 [refresh endinLoadMore];
 }];
 @endcode
 */
- (void) endinLoadMore;

/**
 将要滑动到scrollView底部的时候会触发这个Block
 Will Scroll to bottom, trigger this block auto. remember call `endinLoadMore`, set NO to flag.
 */
@property ( nonatomic, copy ) void (^triggeredLoadMore) (InsRefreshView * refreshView);

@end
