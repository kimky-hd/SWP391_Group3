(function ($) {
    "use strict";

    // Dropdown on mouse hover
    $(document).ready(function () {
        function toggleNavbarMethod() {
            if ($(window).width() > 992) {
                $('.navbar .dropdown').on('mouseover', function () {
                    $('.dropdown-toggle', this).trigger('click');
                }).on('mouseout', function () {
                    $('.dropdown-toggle', this).trigger('click').blur();
                });
            } else {
                $('.navbar .dropdown').off('mouseover').off('mouseout');
            }
        }
        toggleNavbarMethod();
        $(window).resize(toggleNavbarMethod);
    });


    // Back to top button
    $(window).scroll(function () {
        if ($(this).scrollTop() > 100) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({scrollTop: 0}, 1500, 'easeInOutExpo');
        return false;
    });


    // Vendor carousel
    $('.vendor-carousel').owlCarousel({
        loop: true,
        margin: 29,
        nav: false,
        autoplay: true,
        smartSpeed: 1000,
        responsive: {
            0: {
                items: 2
            },
            576: {
                items: 3
            },
            768: {
                items: 4
            },
            992: {
                items: 5
            },
            1200: {
                items: 6
            }
        }
    });


    // Related carousel
    $('.related-carousel').owlCarousel({
        loop: true,
        margin: 29,
        nav: false,
        autoplay: true,
        smartSpeed: 1000,
        responsive: {
            0: {
                items: 1
            },
            576: {
                items: 2
            },
            768: {
                items: 3
            },
            992: {
                items: 4
            }
        }
    });


    // Product Quantity
    $('.quantity button').on('click', function () {
        var button = $(this);
        var oldValue = button.parent().parent().find('input').val();
        if (button.hasClass('btn-plus')) {
            var newVal = parseFloat(oldValue) + 1;
        } else {
            if (oldValue > 0) {
                var newVal = parseFloat(oldValue) - 1;
            } else {
                newVal = 0;
            }
        }
        button.parent().parent().find('input').val(newVal);
    });

})(jQuery);
function editBlog(blogID) {
    // Mở modal chỉnh sửa và tải dữ liệu blog hiện tại
    // Bạn cần tạo modal tương tự như modal thêm blog
}

function deleteBlog(blogID) {
    if (confirm('Bạn có chắc chắn muốn xóa blog này không?')) {
        // Gửi yêu cầu xóa đến server
        window.location.href = 'deleteBlog?blogID=' + blogID;
    }
}

// Script để tạo hiệu ứng delay khi bỏ chuột ra
document.addEventListener('DOMContentLoaded', function () {
    const flowerBtn = document.querySelector('.flower-fixed-btn');
    let timeoutId;

    flowerBtn.addEventListener('mouseenter', function () {
        clearTimeout(timeoutId);
        flowerBtn.classList.add('active');
    });

    flowerBtn.addEventListener('mouseleave', function () {
        timeoutId = setTimeout(function () {
            flowerBtn.classList.remove('active');
        }, 1000); // Delay 1 giây
    });
});