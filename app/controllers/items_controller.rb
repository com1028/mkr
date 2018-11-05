class ItemsController < ApplicationController
    def index
        @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
        @items = @mercari_user.items.all
    end

    def new
        @mercari_user = current_user.mercari_users.find_by(id: params['mercari_user_id'])
        @item = Item.new
    end

    def edit
        @item = Item.find_by(id: params['id'])
        @mercari_user = @item.mercari_user
    end

    def update
        @mercari_user = current_user.mercari_users.find_by(id: item_params['mercari_user_id'])
        @item = @mercari_user.items.find_by(id: params['id'])
        if @item.update_attributes(item_params)
            # 商品データの編集に成功した場合
            flash[:success] = "商品を編集しました"
            redirect_to items_path(mercari_user_id: @mercari_user.id)
        else
            # 商品データの編集に失敗した場合
            render 'new'
        end
    end

    def create
        @mercari_user = current_user.mercari_users.find_by(id: item_params['mercari_user_id'])
        @item = @mercari_user.items.new(item_params)
        @item.user_id = current_user.id
        if @item.save
            # 商品データの作成に成功した場合
            flash[:success] = "商品を追加しました"
            redirect_to items_path(mercari_user_id: @mercari_user.id)
        else
            # 商品データの作成に失敗した場合
            render 'new'
        end
    end

    def update_selected_item
        @item = Item.find_by(id: item_params['id'])
        if @item.update_attributes(item_params)
            flash[:success] = "情報を編集しました"
            redirect_to items_path(mercari_user_id: @item.mercari_user.id)
        else
            flash[:danger] = @item.errors.full_messages
            redirect_to items_path(mercari_user_id: @item.mercari_user.id)
        end
    end

    def delete_selected_item
        @mercari_user = nil
        item_id_list = params['itemlist']
        item_id_list.each_with_index do |list, i|
            delete_item = Item.find_by(id: list)
            if i == 0
                @mercari_user = delete_item.mercari_user
            end
            delete_item.delete
            # 商品の画像を削除
            delete_dir = "#{Rails.root}/public/#{delete_item.user.class.to_s.underscore}/#{delete_item.user.id}/#{delete_item.mercari_user.class.to_s.underscore}/icon/#{delete_item.mercari_user.id}/item/#{delete_item.id}"
            FileUtils.rm_r(delete_dir)
        end
        flash[:success] = '商品を削除しました'
        # 商品一覧へリダイレクト
        redirect_to items_path(mercari_user_id: @mercari_user.id)
    end

    def exhibit
        @item = Item.find_by(id: params['item_id'])
        @mercari_user = @item.mercari_user
        # cmd = "java -jar #{APIConstant::API_PATH}/exhibitAPI.jar #{@item.mercari_user.global_access_token} #{@item.mercari_user.access_token} #{@item.getImageFullPath(@item.image1.to_s)} #{@item.getImageFullPath(@item.image2.to_s)} #{@item.getImageFullPath(@item.image3.to_s)} #{@item.getImageFullPath(@item.image4.to_s)} '#{@item.item_name}' '#{@item.contents}' #{@item.category} #{@item.item_condition} #{@item.shippingPayer} #{@item.shippingMethod} #{@item.shipping_from_area} #{@item.shipping_duration} #{@item.price}"
        # result = `#{cmd}`
        result = "m52732270673"
        if result.start_with?("m") && !result.include?("\n")
            # 出品成功時の処理
            binding.pry
        else
            # 出品失敗時の処理
        end
    end

    private
    def item_params
        params.require(:item).permit(:id, :mercari_user_id, :image1, :image2, :image3, :image4, :item_name,
            :category, :shipping_duration, :item_condition, :price, :shippingMethod, :shipping_from_area, :contents, :auto_exhibit_flag, 
            :image1_cache, :image2_cache, :image3_cache, :image4_cache, :remove_image2, :remove_image3, :remove_image4)
    end

end
