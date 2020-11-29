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
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require rails-ujs
//= require jquery.turbolinks
//= require activestorage
//= require turbolinks
//= require toastr
//= require_tree .

document.addEventListener("turbolinks:load", function () {
    // $("#sidebar").mCustomScrollbar({
    //     theme: "minimal"
    // });

    $('#dismiss, .overlay').on('click', function () {
        // hide sidebar
        $('#sidebar').removeClass('active');
        // hide overlay
        $('.overlay').removeClass('active');
    });

    $('#sidebarCollapse').on('click', function () {
        // open sidebar
        $('#sidebar').addClass('active');
        // fade in the overlay
        $('.overlay').addClass('active');
    });
});

$(document).on('turbolinks:load', function() {
    $(function () {
        $(".change_display_buttun").on('click', function () {
            $('.second_display').fadeIn(700);
            $('.first_display').css('display', 'none');
        });
    });
});

$(document).on('turbolinks:load', function() {
    $(function () {
        $(".return_display_buttun").on('click', function () {
            $('.second_display').css('display', 'none');
            $('.first_display').fadeIn(700);
        });
    });
});

$(document).on('turbolinks:load', function() {
    if(location.pathname != "/") {
        $('.nav-item a[href^="/' + location.pathname.split("/")[1] + '"]').addClass('active');
    } 
});


