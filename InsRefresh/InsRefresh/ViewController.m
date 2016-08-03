//
//  ViewController.m
//  InsRefresh
//
//  Created by Dylan on 2016/8/3.
//  Copyright © 2016年 Dylan. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(UIButton *)sender {

    TableViewController * tabv = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:tabv animated:YES];
}

@end
