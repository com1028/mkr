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
        alert('削除するアカウントが選択してください');
    }else{
        alert(delete_mercari_account_id);
    }
    
}
