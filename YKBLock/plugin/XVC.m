//
//  XRKSettingsViewController.m
//  hookwechat
//
//  Created by TsuiYuenHong on 2017/3/4.
//
//
#import "ZJHURLProtocol.h"
#import <WebKit/WebKit.h>
#import <UIKit/UIKit.h>
#import "LRKeychain.h"
#import "AESCrypt.h"
#import "RSA.h"
#import "XVC.h"


#define CurrentViewSize self.view.frame.size
#define CurrentViewOrigin self.view.frame.origin

@interface XRKSettingsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSMutableArray *arrayDS1;
@property (nonatomic, strong) NSMutableArray *arrayDS2;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *szLabel;
@property (nonatomic, strong) UISwitch *szSwitch;
@property (nonatomic, strong) UILabel *chLabel;
@property (nonatomic, strong) UISwitch *chSwitch;
@property (nonatomic, strong) UILabel *rdLabel;
@property (nonatomic, strong) UISwitch *rdSwitch;
@end


static double sts = 20;

@implementation XRKSettingsViewController


- (void)viewDidLoad {
    if ([UIDevice currentDevice].systemVersion.floatValue >= 15.0) {
        sts = 100;
    }
    self.navigationItem.title = @"YX" ;
    UIBarButtonItem *butt = [[UIBarButtonItem alloc] initWithTitle:@"获取机型列表" style:UIBarButtonItemStylePlain target:self action:@selector(LoadDeviceList:)];
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationItem.rightBarButtonItem = butt;
    [super viewDidLoad];
    [self setupDatas];
    [self setupSubviews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self CheckStatusd];
    });

}



- (UIView *)alertv{
    
    
    SHFontCycleLabel *movlabel = [[SHFontCycleLabel alloc]initWithFrame:CGRectMake(20, sts, CurrentViewSize.width - 20, 30)];
    [movlabel setBackgroundColor:[UIColor whiteColor]];
    movlabel.labelText = [[NSUserDefaults standardUserDefaults] objectForKey:@"alertv"];
    return movlabel;
}




- (UIView *)szLabel{
    if (!_szLabel) {
        _szLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, sts+50, CurrentViewSize.width - 120, 30)];

        _szLabel.text = @"闪照强制保存";
    }
    return _szLabel;
}

- (UIView *)szSwitch{
    if (!_szSwitch) {
        _szSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CurrentViewSize.width - 70, sts+50, 50, 30)];
        _szSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"szEnabled"];
        [_szSwitch addTarget:self action:@selector(ChangeSzStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _szSwitch;
}
- (void)ChangeSzStatus:(UISwitch *)szs{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"szEnabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"szEnabled"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"szEnabled"];
    }
}

- (UIView *)chLabel{
    if (!_chLabel) {
        _chLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, sts+100, CurrentViewSize.width - 120, 30)];
        _chLabel.text = @"消息防撤回";
    }
    return _chLabel;
}

- (UIView *)chSwitch{
    if (!_chSwitch) {
        _chSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CurrentViewSize.width - 70, sts+100, 50, 30)];
        _chSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"chEnabled"];
        [_chSwitch addTarget:self action:@selector(ChangeChStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _chSwitch;
}

- (void)ChangeChStatus:(UISwitch *)chs{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"chEnabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"chEnabled"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"chEnabled"];
    }
}

- (UIView *)rdLabel{
    if (!_rdLabel) {
        _rdLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, sts+150, CurrentViewSize.width - 120, 30)];
        _rdLabel.text = @"强开画图红包";
    }
    return _rdLabel;
}

- (UIView *)rdSwitch{
    if (!_rdSwitch) {
        _rdSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(CurrentViewSize.width - 70, sts+150, 50, 30)];
        _rdSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"rdEnabled"];
        [_rdSwitch addTarget:self action:@selector(ChangeRdStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _rdSwitch;
}

- (void)ChangeRdStatus:(UISwitch *)rds{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"rdEnabled"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"rdEnabled"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"rdEnabled"];
    }
}

-(void)CheckStatusd{
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
        
    }
    NSString *yzm = [LRKeychain getKeychainDataForKey:@"UserCode"];
    //构建请求参数
    NSString *deviceID = [LRKeychain getKeychainDataForKey:@"DeviceId"];
    //RSA公钥加密随机字符串
    NSDictionary *reqdict=@{
                            @"code":yzm,
                            @"mac":deviceID,
                            @"en":randomString
                            };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:reqdict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonenc = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *en = [RSA encryptString:jsonenc publicKey:RSpub];
    NSString *AllUrl = [[AESCrypt decrypt:RequestAddr password:[RSpub substringToIndex:kRandomLength]] stringByAppendingString:[NSString stringWithFormat:@"?token=%@",en]];
    NSURL *url = [NSURL URLWithString:AllUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:(8)];
        NSHTTPURLResponse *resss = nil;
        NSError *errr = nil;
        NSData *dataa = [NSURLConnection sendSynchronousRequest:request returningResponse:&resss error:&errr];
    if (errr) {
        exit(0);
    }
        NSString *decstr = [AESCrypt decrypt:([[NSString alloc] initWithData:dataa encoding:NSUTF8StringEncoding]) password:(randomString)];
        NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:[decstr dataUsingEncoding:NSUTF8StringEncoding]options:NSJSONReadingMutableContainers error:nil];
    if (![[dics objectForKey:@"s"]isEqualToString:@"200"]) {
        exit(0);
    }
}


-(void)LoadDeviceList:(id)sender {
        NSString *AllUrl = [[AESCrypt decrypt:RequestAddr password:[RSpub substringToIndex:kRandomLength]] stringByAppendingString:@"?do=getdevice1"];
        NSURL *url = [NSURL URLWithString:AllUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setTimeoutInterval:(8)];
        NSData *dataa = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *getdevicelist = [NSJSONSerialization JSONObjectWithData:dataa options:NSJSONReadingMutableContainers error:nil];
        NSString *AllUrl2 = [[AESCrypt decrypt:RequestAddr password:[RSpub substringToIndex:kRandomLength]] stringByAppendingString:@"?do=getdevice2"];
        NSURL *url2 = [NSURL URLWithString:AllUrl2];
        NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
        [request2 setHTTPMethod:@"GET"];
        [request setTimeoutInterval:(8)];
        NSData *dataa2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:nil error:nil];
        NSDictionary *getdevicelist2 = [NSJSONSerialization JSONObjectWithData:dataa2 options:NSJSONReadingMutableContainers error:nil];
        if (getdevicelist2 && getdevicelist) {
            [[NSUserDefaults standardUserDefaults] setObject:getdevicelist2 forKey:@"dict2"];
            [[NSUserDefaults standardUserDefaults] setObject:getdevicelist forKey:@"dict1"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"机型列表更新成功,返回上级菜单再进入即可生效！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"网络错误，请检查连接或稍后重试！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES completion:nil];
        }
}
- (void)setupDatas {
    self.dict1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"dict1"];
    self.dict2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"dict2"];
    if (!_dict1) {
        _dict1 = @{@"iPhone 13 Pro Max" : @"iPhone14,3"};
        _dict2 = @{@"HUAWEI Mate X2" : @"HUAWEI Mate X2"};
    }
    self.arrayDS1 = [[NSMutableArray alloc] init];
    for (NSString *key in _dict1) {
        NSString * str = key;
        [self.arrayDS1 addObject:str];
    }
    self.arrayDS2 = [[NSMutableArray alloc] init];
    for (NSString *key in _dict2) {
        NSString * str = key;
        [self.arrayDS2 addObject:str];
    }
}

- (void)setupSubviews {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     *  表格视图样式
     *  UITableViewStylePlain //无分区样式
        UITableViewStyleGrouped //分区样式
     */
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, sts+200, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-sts-270) style:UITableViewStylePlain];
    /**
     *
     *  设置代理
     */
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.alertv];
    [self.view addSubview:self.szLabel];
    [self.view addSubview:self.szSwitch];
    [self.view addSubview:self.chLabel];
    [self.view addSubview:self.chSwitch];
    [self.view addSubview:self.rdLabel];
    [self.view addSubview:self.rdSwitch];
    [self.view addSubview:self.tableView];
}

/**
 *  UITableViewDataSource协议中的所有方法,用来对表格视图的样式进行设置(比如说显示的分区个数、每个分区中单元格个数、单元格中显示内容、分区头标题、分区未标题、分区的View)
 */
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

/**
 *  设置每个分区显示的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.arrayDS1 count];
    } else {
        return [self.arrayDS2 count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ///<1.>设置标识符
    static NSString * str = @"cellStr";
    ///<2.>复用机制:如果一个页面显示7个cell，系统则会创建8个cell,当用户向下滑动到第8个cell时，第一个cell进入复用池等待复用。
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    ///<3.>新建cell
    if (cell == nil) {
        //副标题样式
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    ///<4.>设置单元格上显示的文字信息
    if (indexPath.section == 0) {
        cell.textLabel.text = [self.arrayDS1 objectAtIndex:indexPath.row];
    } else {
        
        cell.textLabel.text = [self.arrayDS2 objectAtIndex:indexPath.row];
    }
    
//    cell.detailTextLabel.text = @"副标题";
    
    return cell;
}

/**
 *  由于表格的样式设置成plain样式,但是不能说明当前的表格不显示分区
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"iPhone机型";
    }else {
        return @"其他机型（仅供娱乐）";
    }
}

/**
 *  设置单元格的高度
 *  单元格默认高度44像素
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

/**
 *  UITableViewDelegate协议中所有方法，用来对单元格自身进行操作(比如单元格的删除、添加、移动...)
 */
#pragma UITableViewDelegate

/**
 *  点击单元格触发该方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(indexPath.section == 0){
        NSString *model = [_dict1 objectForKey:cell.textLabel.text];
        [[NSUserDefaults standardUserDefaults] setValue:model forKey:@"aadevice"];
        
    }
    else{
        NSString *model = [_dict2 objectForKey:cell.textLabel.text];
        [[NSUserDefaults standardUserDefaults] setValue:model forKey:@"aadevice"];
    }
    
    //点击按钮清除缓存并显示的文字
    NSArray *tempPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *kitpath = [NSString stringWithFormat:@"%@/WebKit",[tempPath objectAtIndex:0]];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:kitpath];

    for (NSString *fileName in enumerator) {

    [[NSFileManager defaultManager] removeItemAtPath:[kitpath stringByAppendingPathComponent:fileName] error:nil];

    }

    NSString *selectCellStr = [NSString stringWithFormat:@"成功修改为:%@\n关闭软件重启后生效\n点击左上角头像即可设置在线状态", cell.textLabel.text];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:selectCellStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"关闭APP" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                              {
        exit(0);
                              }];
    [alertController addAction:action];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end

//滚动效果测试


@interface SHFontCycleLabel ()

@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation SHFontCycleLabel

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.myLabel];
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (void)setLabelText:(NSString *)labelText{
    
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self.secondLabel removeFromSuperview];
    
    self.myLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _labelText = labelText;
    self.myLabel.text = _labelText;
    self.myLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    
    CGRect rect = [_labelText boundingRectWithSize:CGSizeMake(10000, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.myLabel.font} context:nil];
    
    if (rect.size.width > self.frame.size.width) {
        
        self.myLabel.frame = CGRectMake(0, 0, rect.size.width + 30, self.frame.size.height);
        [self createSecondLabel];
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(startFontCycle) userInfo:nil repeats:YES];
    }
}

- (void)startFontCycle{
    
    self.myLabel.frame = CGRectMake(self.myLabel.frame.origin.x - 1, 0, self.myLabel.frame.size.width, self.myLabel.frame.size.height);
    self.secondLabel.frame = CGRectMake(CGRectGetMaxX(self.myLabel.frame), 0, self.secondLabel.frame.size.width, self.secondLabel.frame.size.height);
    
    if (CGRectGetMaxX(self.myLabel.frame) < 0) {
        
        UILabel *tempLabel;
        tempLabel = self.myLabel;
        self.myLabel = self.secondLabel;
        self.secondLabel = tempLabel;
    }
}



- (void)createSecondLabel{
    
    if (self.secondLabel) {
        
        self.secondLabel = nil;
    }
    
    self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.myLabel.frame.size.width, 0, self.myLabel.frame.size.width, self.frame.size.height)];
    self.secondLabel.text = self.myLabel.text;
    self.secondLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    
    [self addSubview:self.secondLabel];
}

- (UILabel *)myLabel{
    
    if (!_myLabel) {
        
        _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
    return _myLabel;
}


- (void)dealloc{
    
    [self.myTimer invalidate];
    self.myTimer = nil;
}

@end

