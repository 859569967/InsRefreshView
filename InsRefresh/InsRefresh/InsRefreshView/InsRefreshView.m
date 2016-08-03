//
//  InsRefreshView.m
//  AVInsurance
//
//  Created by Dylan on 2016/8/3.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "InsRefreshView.h"

/**
 默认为49的高度
 */
#undef  kInsRefreshViewHeight
#define kInsRefreshViewHeight 49

@interface InsRefreshView () {
    // 附着的ScrollView
    UIScrollView *_scrollView;
}

@property ( nonatomic, strong ) UIActivityIndicatorView * indicator;

@end

@implementation InsRefreshView

+ (instancetype) viewWithScroll: (UIScrollView *) scrollView {
    return [[[self class] alloc] initWithScroll:scrollView];
}

- (instancetype) initWithScroll: (UIScrollView *) scrollView {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.hidesWhenStopped = NO;
    [_indicator startAnimating];

    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kInsRefreshViewHeight)];
    if ( self ) {
        self->_isRefresh = NO;
        self->_isLoadMore = NO;

        self.bottomInset = 100;

        [self addSubview:_indicator];
        _indicator.center = self.center;

        CGRect frame = _indicator.frame;
        frame.origin.y -= kInsRefreshViewHeight;
        _indicator.frame = frame;

        self.backgroundColor = _scrollView.backgroundColor;

        _scrollView = scrollView;
        [self setScrollView];
    }
    return self;
}

- (void) setScrollView {
    // 默认的Frame
    CGRect frame = self.frame;
    frame.origin.y -= kInsRefreshViewHeight;
    self.frame = frame;

    [_scrollView addSubview:self];
    // 监听ScrollView的Frame变化
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    CGPoint p = [change[@"new"] CGPointValue];
    // 下拉刷新 ( 64 + ... )
    if ( p.y <= -110 && !self.isRefresh ) {
        // 触发下啦刷新
        [self indicatorAnimated];
    }
    // 上拉加载
    CGFloat loadDistance = _scrollView.contentSize.height + _scrollView.contentInset.bottom - _scrollView.bounds.size.height;
    // 触发上拉加载的条件
    if ( loadDistance - p.y <= _bottomInset && !self.isLoadMore ) {
        [self beginLoadMore];
    }
}

- (void) beginLoadMore {
    self->_isLoadMore = YES;
    if ( self.triggeredLoadMore ) {
        self.triggeredLoadMore(self);
    }
}

- (void) endinLoadMore {
    self->_isLoadMore = NO;
}

- (void)dealloc {
    if ( _indicator ) {
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
        _indicator = nil;
    }
    if ( _scrollView ) {
        [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void) indicatorAnimated {
    self->_isRefresh = YES;

    UIEdgeInsets inset = _scrollView.contentInset;
    _scrollView.contentInset = UIEdgeInsetsMake(inset.top + kInsRefreshViewHeight, inset.left, inset.bottom, inset.right);

    __weak typeof(self) weakSelf = self;
    // Animated the indicator view.
    [UIView animateWithDuration:.25 animations:^{

        CGRect frame = _indicator.frame;
        frame.origin.y += kInsRefreshViewHeight;
        _indicator.frame = frame;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25 delay:.25 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            _indicator.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.25 animations:^{
                _indicator.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.25 animations:^{
                    _indicator.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    _indicator.transform = CGAffineTransformIdentity;
                    if ( weakSelf.triggeredRefresh ) {
                        weakSelf.triggeredRefresh(weakSelf);
                    }
                }];
            }];
        }];
    }];
}

- (void) beginRefresh {
    if ( !self.isRefresh ) {
        [self indicatorAnimated];
    }
}

- (void) endinRefresh {
    if ( self.isRefresh ) {
        [UIView animateWithDuration:.25 delay:.1 options:UIViewAnimationOptionAllowAnimatedContent animations:^{

            CGRect frame = _indicator.frame;
            frame.origin.y -= kInsRefreshViewHeight;
            _indicator.frame = frame;

            UIEdgeInsets inset = _scrollView.contentInset;
            _scrollView.contentInset = UIEdgeInsetsMake(inset.top - kInsRefreshViewHeight, inset.left, inset.bottom, inset.right);
        } completion:^(BOOL finished) {

        }];
        self->_isRefresh = NO;
    }
}

#pragma mark - color set

- (void) setTintColor: (UIColor *) tintColor {
    [super setTintColor:tintColor];
    _indicator.color = tintColor;
}

@end