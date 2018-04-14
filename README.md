# Ruby on Rails チュートリアルのサンプルアプリケーション

これは、次の教材で作られたサンプルアプリケーションです。   
[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
[Michael Hartl](http://www.michaelhartl.com/) 著

## ライセンス

[Ruby on Rails チュートリアル](https://railstutorial.jp/)内にある
ソースコードはMITライセンスとBeerwareライセンスのもとで公開されています。
詳細は [LICENSE.md](LICENSE.md) をご覧ください。

## 使い方

このアプリケーションを動かす場合は、まずはリポジトリを手元にクローンしてください。
その後、次のコマンドで必要になる RubyGems をインストールします。

```
$ bundle install --without production
```

その後、データベースへのマイグレーションを実行します。

```
$ rails db:migrate
```

最後に、テストを実行してうまく動いているかどうか確認してください。

```
$ rails test
```

テストが無事に通ったら、Railsサーバーを立ち上げる準備が整っているはずです。

```
$ rails server
```

詳しくは、[*Ruby on Rails チュートリアル*](https://railstutorial.jp/)
を参考にしてください。

Memo

・リポジトリ作成
 & git init
 
・コミットするファイルを選択する(インデックスに追加)
 & git add [オプション]
            ファイル名          #指定ファイルのみadd
            ディレクトリ名      #ディレクトリをadd
            -A                  #全てをadd
            *                   #カレントディレクトリからのファイルを全てadd
            -u                  #gitで管理されているファイルのみadd
            -n                  #addされるファイルを確認　※addはされない
            -p                  #行単位でCommit
            
・コミット
 & git commit [オプション]      #addで指定されていたファイルのコミット
              .                 #全てをcommit   (git add -a ⇒ git commit と同義)
              --amend           #直前のcommitを現在のステージングの内容と結合して上書き
              -m "msg"          #commitメッセージを入力
            
・コミットログを確認する
 & git log [オプション]       #全てのコミットログを確認
            -oneline          #1行1コミット
            -author="Name"    #指定ユーザのコミット履歴のみ
            [FILE]            #指定ファイルのコミット履歴
            
・commit内容を表示
git show [オプション]         #最新のコミット内容
          [TAG]               #指定したタグのコミット内容を表示
          -branch             #ブランチの作成・変更・マージ等の履歴を表示
          

・リポジトリでの追加、変更ファイルの確認
git status

・bitbucketにリポジトリを作成し、Push
 & git remote add origin git@bitbucket.org:unioblog/tutorial_app.git
 & git push -u origin --all
 



・コントローラ作成
 & rails generate controller "Controller名" "アクション名(複数可？)"
 
・モデル作成
 & rails generate model "Model名" "列名":"型" email:string(例)
  
・元に戻す
 & rails destroy "Controller名またはModel名"
 
・マイグレーションの変更
 & rails db:migrate
 
2018/04/14 雛形リポジトリ完成 Githubに保存