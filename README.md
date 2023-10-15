# Efficio
## 目次
1. [簡易紹介スライド](#今後実装予定)
2. [概要](#概要)
3. [きっかけ](#きっかけ)
4. [こだわり](#こだわり)
5. [機能](#機能)
6. [工夫点](#工夫点)
7. [言語](#言語)
<hr>

## 簡易紹介スライド
![I am Rich Image Assets](https://github.com/hapiharu012/Productivity-Apps-for-iOS/assets/120043995/f1404d62-31ae-4884-9171-e51ea591143a)
![IMG_5369](https://github.com/hapiharu012/Productivity-Apps-for-iOS/assets/120043995/e9d2007d-cfed-4c34-8707-e289befd1d70)
![aaaaaa](https://github.com/hapiharu012/Productivity-Apps-for-iOS/assets/120043995/5d9be1f8-3a24-4314-aa5d-29b12d5ea7fe)

## 概要
「Efficio」は生産性向上を目的としたiOSアプリです。現段階では主に「タスク管理」機能を提供していますが、この機能単体としてはAppStoreの上位に並んでいるアプリに劣らない機能を有していると自負しています。
今後は、[”今後実装予定の機能”](#今後実装予定)で説明する新たな機能を実装し、本アプリの実用性を高めていく予定です。

## きっかけ
私が情報科学部に進学したのは、Apple製品が好きで、自分の好きなiPhoneで動くアプリを作りたいという思いからでした。
入学以来、インターンシップや、書籍を用いて基礎を学び、いくつかのシンプルなアプリを開発してきました。  
ここで話がそれますが、私は効率よく物事を進めるのが苦手だということもあり、タスク管理アプリやその他生産性向上アプリを多々試してきました。しかし満足できるアプリはこれまでなくさまざまなアプリを経由していました。　　
この経験から、いろんなアプリを試してきたユーザーとしてアイディアはたくさん持っているので、それらを合わせた最強の生産性向上アプリを作ろうと思ったのがきっかけでした。

## こだわり
["**きっかけ**"](#きっかけ)で話したように本アプリは自分が欲しい機能、つまり「自分が使いたいと思うアプリ」を開発するというのが根底にあります。
そのため開発中に、実装していることに満足し、細かいUIの部分だったりをあまり考えなかったり、リリースすることで頭がいっぱいになり先を急いでしまうことがあります。そんな時に一度立ち止まってユーザー目線で考え自分がほんとに使いたいと思えるアプリになるように実装してきました。
そのような過程もあり現段階ではTodoの機能しかありませんがTodoアプリとして自分が他のアプリじゃなくてこのアプリを使いたいとお思える程の機能は最低限実装しています。例えば先日リリースされたiOS17で導入された「インタラクティブウィジェット」をいち早く実装し、アプリを開かなくてもタスクの完了操作を行えるようにしました。この実装によりTodoアプリとしての利便性を大幅に向上させることができました。このような機能は多くの人気Todoアプリでもまだあまり実装されていないため、本アプリが優れている点でもあります。こような機能は自分が使いたいと思えるアプリにするために妥協できない点であったので時間がかかりましたが実装に至りました。また現段階で4種のテーマからアプリ内のデザイン（配色）を設定できるようになっていますがその際にタスクの登録画面に使用しているToggleボタンの色がとても見づらくユーザビリティを考慮した際にあまりよろしくなかったのでToggleButtonを自作したりしました。このようにUIに関してもかなりこだわりを持ち開発を行なっています。

## 機能
### [現在実装済みの]  
- タスク管理
- インタラクティブなウィジェット
  - ホーム画面からTodoを実行済みにする操作を行える。
- カスタマイズ可能な配色:4つのテーマから選択可能

### [今後実装予定]
- タスクに集中するための機能
  - スクリーンタイムを使用した外部アプリへのアクセス制限
- 取り組んだ時間をタスクごとまたは総時間のグラフ表示
- 1日のスケジュールを記録/改善機能
- 達成度の数値化
  
## 工夫点
上で記してきたように本アプリは今後生産性を向上をサポートする機能を増やしていきたいと考えています。そのためコードの可読性をあげメンテナンス、機能拡張をしやすくするためMVVMアーキテクチャを採用し開発しています。現在設計についてを学びながら本アプリに落とし込んでいる状況なので完全なMVVMであるか現状自信はありませんが、今後の学習を進めていく過程で改善していけたらいいなと考えています。

## 言語
Swift（UIフレームワークはSwiftUI）
