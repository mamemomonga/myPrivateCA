# プライベート認証局とサーバ証明書の作成ツール

プライベート認証局と証明書の作成を行います。

# 実行環境

* Docker Desktop for Mac

# 利用方法

## 初期設定

    $ cp env.example env
    $ vim env
    $ ./run.sh

イメージがビルドされヘルプが表示される

## イメージのビルドとプライベート認証局の作成

homemadeはプライベート認証局のCommon Nameに置き換える

    $ ./run.sh ca homemade

ファイル | 内容
---|---
var/CA/private/cakey.pem | CA秘密鍵
var/CA/cacert.pem | CA証明書
var/CA/cacert.der | OS,ブラウザに設定するCAルート証明書

## サーバ証明書の作成

localhostはサーバ証明書のCommon Nameに置き換える

    $ ./run.sh cert localhost
    ...
    Sign the certificate? [y/n]:y
    ...
    1 out of 1 certificate requests certified, commit? [y/n] y

ファイル | 内容
---|---
var/certs/localhost/cert.pem | 署名済みサーバ証明書
var/certs/localhost/privkey.pem | サーバ秘密鍵
var/certs/localhost/req.pem | サーバCSR(使用しない)

## dhparam.pemの作成

[Safe Prime Database and API](https://2ton.com.au/safeprimes/) から素数をダウンロードする

    $ ./run.sh dhparam

## CA証明書の設定

### Firefox

1. 設定
2. プライベートとセキュリティ
3. 証明書を表示
4. 認証局証明書
5. 読み込む
6. var/CA/cacert.der を指定
7. 「この認証局によるウェブサイトの識別を信頼する」 にチェック
8. OK

### Safari, Chrome

#### macOS(Catalina)

1. 「キーチェーンアクセス」を起動
2. キーチェーン: システム、分類: 証明書を選択
3. var/CA/cacert.der を 右側にドロップ
4. 追加されたキー(ここの例では homemade )をダブルクリック
5. 信頼を▶をクリック
6. SSL(Secure Sockets Layer) を「常に信頼」にする
7. (x)で閉じる

## nginxをつかって動作確認

    $ ./nginx.sh

上記の設定したブラウザで https://localhost/ にアクセスし、警告がでずに **Welcome to nginx!** が表示されれば成功。
