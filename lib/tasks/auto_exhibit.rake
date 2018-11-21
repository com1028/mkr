namespace :auto_exhibit do
  desc "自動出品処理タスク"
  task :auto_exhibit => :environment do

    puts '自動出品タスクを実行'
    mercari_users = MercariUser.all_in_progress_user
    mercari_users.each do |mercari_user|
      final_auto_exhibit_count = Item.final_auto_exhibit_count(mercari_user.id)
      # まだ自動出品をしていないとき
      if final_auto_exhibit_count == 0
        # 最終出品商品は、商品レコードの最後の商品とみなす
        last_exhibit_item = mercari_user.items.last_exhibit_item(mercari_user.id).last
      # 既に自動出品をしているとき
      else final_auto_exhibit_count == 1
        last_exhibit_item = mercari_user.items.last_exhibit_item(mercari_user.id)
      end
      if mercari_user.items.auto_exhibit_count_by_mercari_user(mercari_user.id) == 0
        next_exhibit_item = nil
      else
        next_exhibit_item = mercari_user.items.next_exhibit_item(mercari_user.id, last_exhibit_item)

        # 前回の出品から出品時間(デフォルトは2時間)が経過している場合
        exhibit_interval = mercari_user.exhibit_interval
        exhibit_interval = 2 if exhibit_interval.nil?
        if last_exhibit_item.last_auto_exhibit_date.present?
          if Time.now >= last_exhibit_item.last_auto_exhibit_date.to_time + exhibit_interval.hour
            # 過去の同じ商品の出品でコメントのあった商品はメルカリ上から削除
            next_exhibit_item.deleteIfExistComment
            # 出品処理
            next_exhibit_item.exhibit
            # 最終自動出品日時を更新
            last_exhibit_item.update(last_auto_exhibit_date: nil)
            next_exhibit_item.update(last_auto_exhibit_date: Time.now.to_s(:db))
          end
        else
          # 過去の同じ商品の出品でコメントのあった商品はメルカリ上から削除
          next_exhibit_item.deleteIfExistComment
          # 出品処理
          next_exhibit_item.exhibit
          # 最終自動出品日時を更新
          last_exhibit_item.update(last_auto_exhibit_date: nil)
          next_exhibit_item.update(last_auto_exhibit_date: Time.now.to_s(:db))
        end
      end
    end

  end
end
