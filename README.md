# Concert_Ticket
iOSudid网络验证
* Xcode
* 一台可以用的服务器
## 准备工作
* 下载Xcode
* Mac上下载POD环境theos
* 服务器环境Nginx+MySQL5.6+PHP5.6
* 部署教程：1:上传源码到服务器后解压到根目录，必须部署ssl强制开启https随后到config.php内配置数据库 
2：生成AES加密数据 1024bit密钥格式PKCS#1 生成完保存好
3：在youkebing.com/AES.php内填写加密数据,string下填写域名/api/token.php。key下填上面生成好的公钥前15位，点encrypt生成好的数据保存好。生成完在Xcode里ZJHURLProtocol配置数据
4：/api/token.php填写RSA私钥
* 以上完成好就可以编译了 编译完是静态库如果需要动态库可以联系我微信：hanshuhsiy
* 在签名工具注入验证测试推荐使用轻松签
* 签名的时候记得选择注入越狱依赖

## （注：禁止倒卖商用，此源码用于学习）

