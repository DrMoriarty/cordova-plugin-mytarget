//
//  ViewController.m
//  NativeAdTableViewExample
//
//  Created by Anton Bulankin on 17.06.15.
//  Copyright (c) 2015 Mail.Ru Group. All rights reserved.
//

#import "ViewController.h"
#import <MyTargetSDK/MyTargetSDK.h>

typedef enum {
    NativeAdTableCellDataTypeSimple = 1, //No ad cell
    NativeAdTableCellDataTypePromo,
    NativeAdTableCellDataTypeTeaserNewsFeed,
    NativeAdTableCellDataTypeTeaserChatList,
    NativeAdTableCellDataTypeImage,
    NativeAdTableCellDataTypeCommon
} NativeAdTableCellDataType;


@interface NativeAdTableCellData : NSObject
@property NativeAdTableCellDataType type;
@property int index;
@property id ad;
@property UIView * view;
@property NSString * text;
@property BOOL isFinishLoaded;
@end

@implementation NativeAdTableCellData
@end



@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,
MTRGNativePromoAdDelegate, MTRGNativeImageAdDelegate, MTRGNativeTeaserAdDelegate>

@end

@implementation ViewController{
    IBOutlet UITableView * _tableView;
    IBOutlet UIButton * _loadMoreButton;
    
    NSMutableArray * _cellsData;
    int _currentIndex;
}

-(void) setStyleForButton:(UIButton*)button{
    button.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.05];
    button.layer.borderColor = [[UIColor blackColor]colorWithAlphaComponent:0.1].CGColor;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.layer.borderWidth = 0.6;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _cellsData = [NSMutableArray new];
    [self setStyleForButton:_loadMoreButton];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _currentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createAdForCellData:(NativeAdTableCellData *) cellData{
    if (!cellData) return;
    if (cellData.type == NativeAdTableCellDataTypePromo){
        MTRGNativePromoAd * promoAd = [[MTRGNativePromoAd alloc]initWithSlotId:@"6590"];
        promoAd.autoLoadImages = YES;
        promoAd.delegate = self;
        [promoAd load];
        
        cellData.ad = promoAd;
    } else if(cellData.type == NativeAdTableCellDataTypeTeaserNewsFeed){
        MTRGNativeTeaserAd * teaserAd = [[MTRGNativeTeaserAd alloc]initWithSlotId:@"6591"];
        teaserAd.autoLoadImages = YES;
        teaserAd.delegate = self;
        [teaserAd load];
        
        cellData.ad = teaserAd;
    } else if (cellData.type == NativeAdTableCellDataTypeImage){
        MTRGNativeImageAd * imageAd = [[MTRGNativeImageAd alloc]initWithSlotId:@"6592"];
        imageAd.delegate = self;
        imageAd.autoLoadImages = YES;
        [imageAd load];
        
        cellData.ad = imageAd;
    } else if (cellData.type == NativeAdTableCellDataTypeTeaserChatList){
        MTRGNativeTeaserAd * teaserAd = [[MTRGNativeTeaserAd alloc]initWithSlotId:@"6591"];
        teaserAd.delegate = self;
        teaserAd.autoLoadImages = YES;
        [teaserAd load];
        
        cellData.ad = teaserAd;
    }
    
    if (cellData.ad){
        cellData.isFinishLoaded = NO;
        cellData.text = @"Reloading...";
        if (cellData.view){
            [cellData.view removeFromSuperview];
        }
        cellData.view = nil;
    }
}


-(void) initTableData{
    for (int i = 1; i <= 20; ++i) {
        NativeAdTableCellData * cellData = [[NativeAdTableCellData alloc]init];
        if (i == 2){
            cellData.type = NativeAdTableCellDataTypePromo;
        }else if(i == 7) {
            cellData.type = NativeAdTableCellDataTypeTeaserNewsFeed;
            
        }else if(i == 9) {
            cellData.type = NativeAdTableCellDataTypeImage;
            
        }else if(i == 15) {
            cellData.type = NativeAdTableCellDataTypeTeaserChatList;
        }else{
            cellData.type = NativeAdTableCellDataTypeSimple;
            
            cellData.isFinishLoaded = YES;
            cellData.text = [NSString stringWithFormat:@"Cell - %d", (i+_currentIndex)];
        }
        
        [self createAdForCellData:cellData];
        
        [_cellsData addObject:cellData];
    }
    
    _currentIndex += 20;
}

-(void) initViewForAd:(id)ad banner:(id)banner{
    for (NativeAdTableCellData * cellData in _cellsData) {
        if (ad == cellData.ad){
            BOOL isLoaded = banner != nil;
            if (isLoaded){
                if (cellData.type == NativeAdTableCellDataTypePromo){
                    cellData.view = [MTRGNativeViewsFactory createContentStreamViewWithBanner:(MTRGNativePromoBanner *)banner];
                }
                else if (cellData.type == NativeAdTableCellDataTypeTeaserChatList){
                    cellData.view = [MTRGNativeViewsFactory createChatListViewWithBanner:(MTRGNativeTeaserBanner *)banner];
                }
                else if (cellData.type == NativeAdTableCellDataTypeTeaserNewsFeed){
                    cellData.view = [MTRGNativeViewsFactory createNewsFeedViewWithBanner:(MTRGNativeTeaserBanner *) banner];
                }
                else if (cellData.type == NativeAdTableCellDataTypeImage){
                    cellData.view = [MTRGNativeViewsFactory createContentWallViewWithBanner:(MTRGNativeImageBanner *) banner];
                }
                cellData.text = cellData.view ? nil : @"View not created";
            }else{
                cellData.text = @"Error";
            }
            
            if (cellData.view){
                MTRGNativeBaseAd * ad = (MTRGNativeBaseAd *)cellData.ad;
                [ad registerView:cellData.view withController:self];
            }
            cellData.isFinishLoaded = YES;
            
            break;
        }
    }
    
    if ([self isAllViewsLoadAd]){
        [_tableView reloadData];
    }
}

-(IBAction)reloadAdBannersButtonClick:(id)sender{
    for (NativeAdTableCellData * cellData in _cellsData) {
        [self createAdForCellData:cellData];
    }
}

-(IBAction)loadTableButtonClick:(id)sender{
    for (NativeAdTableCellData * cellData in _cellsData) {
        MTRGNativeBaseAd * ad = cellData.ad;
        [ad unregisterView];
        
        if (cellData && cellData.view){
            [cellData.view removeFromSuperview];
        }
    }
    _cellsData = [NSMutableArray new];
    _currentIndex = 0;
    [self initTableData];
}

-(IBAction)loadMoreButtonClick:(id)sender{
    [self initTableData];
}

-(IBAction)backButtonClick:(id)sender{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

-(BOOL) isAllViewsLoadAd{
    NSUInteger count = [_cellsData count];
    NSUInteger loadedCount = 0;
    for (NativeAdTableCellData * cellData in _cellsData) {
        if (cellData.isFinishLoaded){
            loadedCount++;
        }
    }
    return loadedCount == count;
}


#pragma mark --- MTRGNativePromoAdDelegate


-(void)onLoadWithNativePromoBanner:(MTRGNativePromoBanner *)promoBanner promoAd:(MTRGNativePromoAd *)promoAd{
    [self initViewForAd:promoAd banner:promoBanner];
}
-(void)onNoAdWithReason:(NSString *)reason promoAd:(MTRGNativePromoAd *)promoAd{
    [self initViewForAd:promoAd banner:nil];
}
-(void)onAdClickWithNativePromoAd:(MTRGNativePromoAd *)promoAd{
    
}

#pragma mark --- MTRGNativeTeaserAdDelegate

-(void)onLoadWithNativeTeaserBanner:(MTRGNativeTeaserBanner *)teaserBanner teaserAd:(MTRGNativeTeaserAd *)teaserAd{
    [self initViewForAd:teaserAd banner:teaserBanner];
}
-(void)onNoAdWithReason:(NSString *)reason teaserAd:(MTRGNativeTeaserAd *)teaserAd{
    [self initViewForAd:teaserAd banner:nil];
}
-(void)onAdClickWithNativeTeaserAd:(MTRGNativeTeaserAd *)teaserAd{
    
}

#pragma mark -- MTRGNativeImageAdDelegate

-(void)onLoadWithNativeImageBanner:(MTRGNativeImageBanner *)imageBanner imageAd:(MTRGNativeImageAd *)imageAd{
    [self initViewForAd:imageAd banner:imageBanner];
}
-(void)onNoAdWithReason:(NSString *)reason imageAd:(MTRGNativeImageAd *)imageAd{
    [self initViewForAd:imageAd banner:nil];
}
-(void)onAdClickWithNativeImageAd:(MTRGNativeImageAd *)imageAd{
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellID = @"AnyCellID";
    static NSString* adCellID = @"MyTargetNativeAdCellID";
    UITableViewCell* cell;
    
    NativeAdTableCellData * cellData = [self cellDataForIndexPath:indexPath];
    UIView *adView = nil;
    if (cellData){
        adView = cellData.view;
    }
    if (adView){
        cell = [tableView dequeueReusableCellWithIdentifier:adCellID];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:adCellID];
        } else {
            
        }
        [cell addSubview:adView];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = cellData.text;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NativeAdTableCellData *) cellDataForIndexPath:(NSIndexPath*)indexPath{
    if (!_cellsData) return nil;
    if (!indexPath) return nil;
    if (indexPath.row >= [_cellsData count]) return nil;
    NativeAdTableCellData * cellData = _cellsData[indexPath.row];
    return cellData;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cellsData count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NativeAdTableCellData * cellData = [self cellDataForIndexPath:indexPath];
    if (!cellData) return 20;
    MTRGBaseNativeAdView * bannerView = (MTRGBaseNativeAdView*)cellData.view;
    if (bannerView){
        CGFloat width = _tableView.frame.size.width;
        [bannerView setFixedWidth:width];
        CGFloat height = bannerView.frame.size.height;
        return height + 1;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    //Удаляем AdView из ячейки, этот код требуется для корректного повторного использования ячеек
    NativeAdTableCellData * cellData = [self cellDataForIndexPath:indexPath];
    if (cellData && cellData.view){
        [cellData.view removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

@end