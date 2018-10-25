# README

・プルリクの作成について（最低限書くことなど）
【必ず記載する項目】
1. どのような処理を入れたのか
2. どのような画面を作成したのか

・作業
	1. ローカルmasterブランチに移動（git checkout master）
	2. リモートmasterブランチをpull（git pull origin master）
	3. ローカルmasterブランチから新しいブランチを切る（git checkout -b ブランチ名）
	3. （作業）
	4. 変更をadd + commit（git add -A　& git commit -m "コミット名"）
	5. リモートにpush（git push origin ブランチ名）
	6. ローカル上でstagingブランチに移動（git checkout staging）
	7. ローカルstagingブランチに、作業したブランチをマージ（git merge ブランチ名）
	8. ローカルstagingブランチをpush（git push origin staging）
	9. プルリクエストを作成（※ 自分が切ったブランチで << stagingでは作らない）

・ソースコードレビュー
	if OK
		"目"アイコン
	elsif Not OK
		コメントを残す
	end

	・処理確認
	1. ローカルでstagingブランチに移動（git checkout staging）
	2. リモートのstagingブランチをpull（git pull origin staging）
	3. ローカルで実行して処理確認

・masterに反映
	コードレビュー、処理確認がOK（2人共）なら、github上からmasterにマージする（Github上の操作）