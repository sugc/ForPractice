//
//  MTFacebookFBSKDShareViewCOntroller.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/13.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTFacebookFBSKDShareViewController.h"

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "UIView+Utils.h"


@interface MTFacebookFBSKDShareViewController () <
                                        UITableViewDelegate,
                                        UITableViewDataSource,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate>


@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) FBSDKShareVideo *video;
@property (nonatomic, strong) FBSDKShareDialog *shareDialog;
@property (nonatomic, strong) FBSDKMessageDialog *messageDialog;
@property (nonatomic, strong) FBSDKLikeControl *likeControl;
@property (nonatomic, strong) FBSDKSendButton *fbSendButton;
@property (nonatomic, strong) UIButton *shareDialogButton;
@property (nonatomic, strong) UIButton *messageDialogButton;
@property (nonatomic, strong) FBSDKShareButton *shareBtn;
@property (nonatomic, assign) NSInteger tag;

@end



@implementation MTFacebookFBSKDShareViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setData];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.likeControl];
    [self.view addSubview:self.fbSendButton];
    [self.view addSubview:self.shareDialogButton];
    [self.view addSubview:self.messageDialogButton];
    [self.view addSubview:self.shareBtn];
    

}

- (void)didReceiveMemoryWarning{

    [super didReceiveMemoryWarning];
}



- (FBSDKShareButton *)shareBtn{
    
    if (!_shareBtn) {
        _shareBtn = [[FBSDKShareButton alloc] init];
        _shareBtn.frame = CGRectMake(0,
                                     MTScreenHeight - 40,
                                     MTScreenWidth ,
                                     40);
    }
    
    return _shareBtn;
}


- (UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(5, 24, 50, 30);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(goBack)
           forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:^(void){
        
    }];
    
}


- (void)setData{
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray addObject:@"FBSDKShareLinkContent分享"];
    [_dataArray addObject:@"FBSDKSharePhotoContent分享"];
    [_dataArray addObject:@"FBSDKShareVideoContent分享"];
    [_dataArray addObject:@"FBSDKShareMediaContent分享"];

    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(50, 24, [UIScreen mainScreen].bounds.size.width - 100, 50);
        _titleLabel.text = @"Facebook";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    return  _titleLabel;
}



- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0,
                                      80,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [UIScreen mainScreen].bounds.size.height - 300);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (FBSDKShareDialog *)shareDialog{

    if (!_shareDialog) {
        _shareDialog = [[FBSDKShareDialog alloc] init];
    }
    
    return _shareDialog;
}

- (FBSDKMessageDialog *)messageDialog{

    if (!_messageDialog) {
        _messageDialog = [[FBSDKMessageDialog alloc] init];
    }
    
    return _messageDialog;
    
}

- (FBSDKShareVideo *)video{

    if (!_video) {
        _video = [[FBSDKShareVideo alloc] init];
        
    }
    
    return _video;
}


- (FBSDKLikeControl *)likeControl{

    if (!_likeControl) {
        _likeControl = [[FBSDKLikeControl alloc] init];
        _likeControl.frame = CGRectMake(0,
                                        self.tableView.bottom,
                                        MTScreenWidth,
                                        30);
        _likeControl.objectID = @"https://developers.facebook.com";
    }
    
    return _likeControl;
}

- (FBSDKSendButton *)fbSendButton{

    if (!_fbSendButton) {
        _fbSendButton = [[FBSDKSendButton alloc] init];
        _fbSendButton.frame = CGRectMake(0,
                                         self.likeControl.bottom + 10,
                                         MTScreenWidth,
                                         30);
        
    }
    
    return _fbSendButton;
}

- (UIButton *)shareDialogButton{
    
    if (!_shareDialogButton) {
        _shareDialogButton = [[UIButton alloc] init];
        _shareDialogButton.frame = CGRectMake(0,
                                         self.fbSendButton.bottom + 10,
                                         MTScreenWidth,
                                         30);
        _shareDialogButton.backgroundColor = [UIColor grayColor];
        [_shareDialogButton setTitle:@"shareDialog" forState:UIControlStateNormal];
        [_shareDialogButton addTarget:self
                          action:@selector(clickshareDialogButton)
                forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareDialogButton;
}

- (UIButton *)messageDialogButton{
    
    if (!_messageDialogButton) {
        _messageDialogButton = [[UIButton alloc] init];
        _messageDialogButton.frame = CGRectMake(0,
                                              self.shareDialogButton.bottom + 10,
                                              MTScreenWidth,
                                              30);
        _messageDialogButton.backgroundColor = [UIColor grayColor];
        [_messageDialogButton setTitle:@"messageDialog" forState:UIControlStateNormal];
        [_messageDialogButton addTarget:self
                               action:@selector(clickMessageDialogButton)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _messageDialogButton;
}


- (void)linkContentShare{
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.imageURL = [NSURL URLWithString:@"http://a2.qpic.cn/psb?/V14FiAMl1CPYcY/nxGuP4JyQjmBId*2mdPXoaDJIUseqToLYlQaMZcUaCk!/b/dA0BAAAAAAAA&ek=1&kp=1&pt=0&bo=iAH0AAAAAAADAFg!&sce=60-2-2&rf=viewer_311"];
    content.contentTitle = @"nothing";
    content.contentURL = [NSURL URLWithString:@"http://open.itcast.cn/python/53-452.html?1607GMYKJ"];
    content.contentDescription = @"test";
    
    self.shareBtn.shareContent = content;
    self.fbSendButton.shareContent = content;
    self.shareDialog.shareContent = content;
    self.messageDialog.shareContent = content;
}


- (void)photoContentShare{
    
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    UIImage *shareImage = [UIImage imageNamed:@"1.jpg"];
    FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:shareImage userGenerated:YES];
    content.photos = @[photo];
    
    self.shareBtn.shareContent = content;
    self.fbSendButton.shareContent = content;
    self.shareDialog.shareContent = content;
    self.messageDialog.shareContent = content;
    
}

- (void)videoContentShare{
    
    _tag = 1;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.mediaTypes = [[NSArray alloc]
                         initWithObjects:(NSString*) kUTTypeMovie,
                                         (NSString*) kUTTypeVideo,
                                         nil];
    
    [self presentViewController:picker animated:NO completion:nil];
    
}

- (void)mediaContentShare{
    
    _tag = 2;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.mediaTypes = [[NSArray alloc]
                         initWithObjects:(NSString*) kUTTypeMovie,
                         (NSString*) kUTTypeVideo,
                         nil];
    [self presentViewController:picker animated:NO completion:nil];
    
    
}

- (void)clickshareDialogButton{
   
    [self.shareDialog show];

}

- (void)clickMessageDialogButton{
    
    [self.messageDialog show];
}

//*************UITableViewDelegate, UITableViewDataSource***************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"shareTableViewCell"];
        cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self linkContentShare];
            break;
        case 1:
            [self photoContentShare];
            break;
        case 2:
            [self videoContentShare];
            break;
        case 3:
            [self mediaContentShare];
            break;
        default:
            break;
    }
    
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    
    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
    self.video.videoURL = url;
    
    if (_tag == 1) {
        
        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
        content.video = self.video;
        self.shareBtn.shareContent = content;
        self.fbSendButton.shareContent = content;
        self.shareDialog.shareContent = content;
        self.messageDialog.shareContent = content;

    }
    
    if (_tag == 2) {
        
        
        FBSDKShareMediaContent *content = [FBSDKShareMediaContent new];
        
        UIImage *shareImage = [UIImage imageNamed:@"1.jpg"];
        FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:shareImage userGenerated:NO];
        
        content.media = @[self.video, photo];

        self.shareBtn.shareContent = content;
        self.fbSendButton.shareContent = content;
        self.shareDialog.shareContent = content;
        self.messageDialog.shareContent = content;
        
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
}


@end


