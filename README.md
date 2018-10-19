# README

・プルリクの作成について（最低限書くことなど）
【必ず記載する項目】
1. どのような処理を入れたのか
2. どのような画面を作成したのか

1. ソースコードレビュー
2. 処理確認：
	1. ローカル上でstagingブランチに移動
	2. リモートのstagingをローカルのstagingににpullしてくる
		(git pull origin staging)
	3. （上記の）最新のローカルstaginに新しいブランチをマージ
		(git merge ブランチ名)
	4. マージしたブランチをgithubにpush
		(git push origin staging)
	5. 他の2人が、最新のstagingブランチをpullしてきて、動作確認
	6. if OK
		ラベルをOKにする
	  elsif Not OK
		ラベルをNot OKにする
	  end

	※ ラベルが2つOKがついたら、masterにマージ（masterへのマージはGithub上でできる）

