// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .
//= require jquery
//= require jquery_ujs

// 「商品一覧ページ」：「更新」ボタンを押下時の処理
function click_update_item(item_id){
    item_tr = $('#item' + item_id);
    
    item_name = item_tr.find('.item_name').children().val();
    category = item_tr.find('.category').html();
    shipping_duration = item_tr.find('.shipping_duration').find('select').val();
    item_condition = item_tr.find('.item_condition').find('select').val();
    shipping_from_area = item_tr.find('.shipping_from_area').find('select').val();
    price = item_tr.find('.price').children().children().val();
    contents = item_tr.find('.contents').html();
    auto_exhibit_flag = item_tr.find('.auto_exhibit_flag').find('select').val();

    update_data = {
        'id' : item_id,
        'item_name' : item_name,
        'category' : category,
        'shipping_duration' : shipping_duration,
        'item_condition' : item_condition,
        'shipping_from_area' : shipping_from_area,
        'price' : price,
        'contents' : contents,
        'auto_exhibit_flag' : auto_exhibit_flag
    };

    $.ajax({
        type: 'POST',
        url: '/update_selected_item',
        data: {
            'item': update_data
        }
    })
    // Ajaxリクエストが成功した時発動
    .done( (data) => {

    })
    // Ajaxリクエストが失敗した時発動
    .fail( (data) => {
        alert('商品情報の編集に失敗しました');
    })
    // Ajaxリクエストが成功・失敗どちらでも発動
    .always( (data) => {

    });;

}

//  商品データの削除確認ダイアログを表示
function item_delete_confirm(){
    delete_item_id = [];
    count = 0;
    $("input[type='checkbox']").filter(":checked").map(function() {
        id = $(this).attr("id");
        delete_item_id.push(id);
        count ++;
    });
    if(count == 0){
        alert('削除するアカウントを選択してください');
    }
    else{
        if(window.confirm('本当にチェックした商品を削除しますか？（取り消しできません）')){
            $.ajax({
                type: 'POST',
                url: '/delete_selected_item',
                data: {
                    'itemlist': delete_item_id
                }
            })
            // Ajaxリクエストが成功した時発動
            .done( (data) => {

            })
            // Ajaxリクエストが失敗した時発動
            .fail( (data) => {
                alert('削除に失敗しました');
            })
            // Ajaxリクエストが成功・失敗どちらでも発動
            .always( (data) => {

            });;
        }
    }
}

// メルカリアカウント削除の確認ダイアログを表示
function account_delete_confirm(){
    delete_mercari_account_id = [];
    count = 0;
    $("input[type='checkbox']").filter(":checked").map(function() {
        id = $(this).attr("id");
        delete_mercari_account_id.push(id);
        count ++;
    });
    if(count == 0){
        alert('削除するアカウントを選択してください');
    }
    else{
        if(window.confirm('本当にチェックしたアカウントを削除しますか？（取り消しできません）')){
            $.ajax({
                type: 'POST',
                url: '/delete_selected_mercari_account',
                data: {
                    'userlist': delete_mercari_account_id
                }
            })
            // Ajaxリクエストが成功した時発動
            .done( (data) => {

            })
            // Ajaxリクエストが失敗した時発動
            .fail( (data) => {
                alert('削除に失敗しました');
            })
            // Ajaxリクエストが成功・失敗どちらでも発動
            .always( (data) => {

            });;
        }
    }
    
}
