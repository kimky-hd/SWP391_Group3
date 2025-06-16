<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Liên Hệ - Flower Shop</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="Flower Shop, Liên hệ, Hoa tươi" name="keywords">
    <meta content="Liên hệ với Flower Shop để được tư vấn và đặt hoa tươi" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">  

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
    
    <style>
        /* Custom styles for contact page */
        .bg-flower {
            background-color: #fce4ec;
        }
        
        .text-flower {
            color: #e83e8c;
        }
        
        .btn-flower {
            background-color: #e83e8c;
            color: white;
            border: none;
            transition: all 0.3s;
        }
        
        .btn-flower:hover {
            background-color: #d81b60;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(232, 62, 140, 0.3);
        }
        
        .contact-form {
            border-radius: 15px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        
        .contact-form:hover {
            box-shadow: 0 0 40px rgba(232, 62, 140, 0.2);
        }
        
        .contact-info-card {
            border-radius: 15px;
            background-color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
            padding: 30px;
            height: 100%;
            transition: all 0.3s;
        }
        
        .contact-info-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(232, 62, 140, 0.15);
        }
        
        .contact-info-card i {
            font-size: 2.5rem;
            color: #e83e8c;
            margin-bottom: 20px;
        }
        
        .form-control:focus {
            border-color: #e83e8c;
            box-shadow: 0 0 0 0.2rem rgba(232, 62, 140, 0.25);
        }
        
        .page-header {
            background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url(img/banner1.jpg) center center no-repeat;
            background-size: cover;
            padding: 100px 0;
            margin-bottom: 50px;
        }
        
        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #e83e8c;
            color: white;
            margin: 0 5px;
            transition: all 0.3s;
        }
        
        .social-links a:hover {
            background-color: #d81b60;
            transform: translateY(-3px);
        }
        
        .map-container {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>

<body>
    <!-- Header Start -->
    <jsp:include page="header.jsp" />
    <!-- Header End -->

    <!-- Page Header Start -->
    <div class="page-header">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <h1 class="display-3 text-white text-center animated fadeInDown"></h1>
                </div>
            </div>
        </div>
    </div>
    <!-- Page Header End -->

    <!-- Contact Info Start -->
    <div class="container-fluid py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4">
                    <span class="bg-light px-2">Thông Tin Liên Hệ</span>
                </h2>
                <p class="mb-5">Hãy liên hệ với chúng tôi bằng một trong những cách dưới đây. Đội ngũ Flower Shop luôn sẵn sàng hỗ trợ bạn!</p>
            </div>
            
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-5">
                    <div class="contact-info-card text-center h-100">
                        <i class="fa fa-map-marker-alt"></i>
                        <h4 class="mb-3">Địa Chỉ</h4>
                        <p>123 Phố Trung Kính, Trung Hòa, Cầu Giấy, Hà Nội</p>
                        <a href="https://goo.gl/maps/JDcf5r6SotPeAKQu8" class="btn btn-sm btn-flower mt-2">Xem Bản Đồ</a>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-5">
                    <div class="contact-info-card text-center h-100">
                        <i class="fa fa-phone-alt"></i>
                        <h4 class="mb-3">Điện Thoại</h4>
                        <p class="mb-2">Hotline: +84 123 456 789</p>
                        <p class="mb-2">CSKH: +84 987 654 321</p>
                        <p>Đặt hàng: +84 555 666 777</p>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-5">
                    <div class="contact-info-card text-center h-100">
                        <i class="fa fa-envelope"></i>
                        <h4 class="mb-3">Email</h4>
                        <p class="mb-2">info@flowershop.com</p>
                        <p class="mb-2">support@flowershop.com</p>
                        <p>sales@flowershop.com</p>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-5">
                    <div class="contact-info-card text-center h-100">
                        <i class="fa fa-clock"></i>
                        <h4 class="mb-3">Giờ Làm Việc</h4>
                        <p class="mb-2">Thứ Hai - Thứ Sáu: 8:00 - 20:00</p>
                        <p class="mb-2">Thứ Bảy - Chủ Nhật: 9:00 - 18:00</p>
                        <p>Ngày Lễ: 9:00 - 17:00</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Contact Info End -->

    <!-- Contact Form Start -->
    <div class="container-fluid bg-flower py-5">
        <div class="container">
            <div class="row">
                <div class="col-lg-7 mb-5 mb-lg-0">
                    <div class="contact-form bg-light p-5">
                        <div class="text-center mb-4">
                            <h3 class="text-flower">Gửi Tin Nhắn Cho Chúng Tôi</h3>
                            <p>Hãy điền thông tin của bạn vào mẫu dưới đây, chúng tôi sẽ liên hệ lại trong thời gian sớm nhất</p>
                        </div>
                        <div id="success"></div>
                        <form name="sentMessage" id="contactForm" novalidate="novalidate">
                            <div class="form-row">
                                <div class="col-md-6">
                                    <div class="control-group mb-4">
                                        <input type="text" class="form-control p-4" id="name" placeholder="Họ và tên"
                                            required="required" data-validation-required-message="Vui lòng nhập họ tên" />
                                        <p class="help-block text-danger"></p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="control-group mb-4">
                                        <input type="email" class="form-control p-4" id="email" placeholder="Email"
                                            required="required" data-validation-required-message="Vui lòng nhập email" />
                                        <p class="help-block text-danger"></p>
                                    </div>
                                </div>
                            </div>
                            <div class="control-group mb-4">
                                <input type="text" class="form-control p-4" id="subject" placeholder="Tiêu đề"
                                    required="required" data-validation-required-message="Vui lòng nhập tiêu đề" />
                                <p class="help-block text-danger"></p>
                            </div>
                            <div class="control-group mb-4">
                                <textarea class="form-control p-4" rows="6" id="message" placeholder="Tin nhắn"
                                    required="required"
                                    data-validation-required-message="Vui lòng nhập tin nhắn"></textarea>
                                <p class="help-block text-danger"></p>
                            </div>
                            <div class="text-center">
                                <button class="btn btn-flower py-3 px-5" type="submit" id="sendMessageButton">
                                    <i class="fa fa-paper-plane mr-2"></i>Gửi Tin Nhắn
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="col-lg-5">
                    <div class="map-container mb-4">
                        <iframe style="width: 100%; height: 350px;"
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3724.4855345755353!2d105.79388731476343!3d21.01637998600766!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3135ab5e96c1255d%3A0xb61d51df7f33d3d3!2zMTIzIFAuIFRydW5nIEvDrW5oLCBUcnVuZyBIb8OgLCBD4bqndSBHaeG6pXksIEjDoCBO4buZaSwgVmnhu4d0IE5hbQ!5e0!3m2!1svi!2s!4v1689123456789!5m2!1svi!2s"
                        frameborder="0" style="border:0;" allowfullscreen="" aria-hidden="false" tabindex="0"></iframe>
                    </div>
                    
                    <div class="bg-light p-4 mb-4">
                        <h4 class="text-flower mb-4">Có Câu Hỏi?</h4>
                        <p>Nếu bạn có bất kỳ câu hỏi nào về sản phẩm hoặc dịch vụ của chúng tôi, đừng ngần ngại liên hệ với đội ngũ hỗ trợ khách hàng của Flower Shop.</p>
                        <p>Chúng tôi cam kết phản hồi mọi thắc mắc của bạn trong vòng 24 giờ.</p>
                    </div>
                    
                    <div class="bg-light p-4">
                        <h4 class="text-flower mb-4">Kết Nối Với Chúng Tôi</h4>
                        <p>Theo dõi chúng tôi trên các nền tảng mạng xã hội để cập nhật những mẫu hoa mới nhất và khuyến mãi đặc biệt!</p>
                        <div class="social-links mt-4">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-youtube"></i></a>
                            <a href="#"><i class="fab fa-tiktok"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Contact Form End -->

    <!-- FAQ Section Start -->
    <div class="container-fluid py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="section-title position-relative text-uppercase mx-xl-5 mb-4">
                    <span class="bg-light px-2">Câu Hỏi Thường Gặp</span>
                </h2>
            </div>
            
            <div class="row">
                <div class="col-lg-8 mx-auto">
                    <div class="accordion" id="faqAccordion">
                        <!-- FAQ Item 1 -->
                        <div class="card border-0 mb-3">
                            <div class="card-header bg-light border-0 p-3" id="headingOne">
                                <h5 class="mb-0">
                                    <button class="btn btn-link text-dark text-decoration-none" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        <i class="fa fa-plus-circle text-flower mr-2"></i> Làm thế nào để đặt hoa trực tuyến?
                                    </button>
                                </h5>
                            </div>

                            <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#faqAccordion">
                                <div class="card-body py-3 px-5">
                                    Để đặt hoa trực tuyến, bạn chỉ cần truy cập vào trang web của chúng tôi, chọn sản phẩm mong muốn, thêm vào giỏ hàng và tiến hành thanh toán. Bạn có thể chọn thời gian và địa điểm giao hàng phù hợp với nhu cầu của mình.
                                </div>
                            </div>
                        </div>
                        
                        <!-- FAQ Item 2 -->
                        <div class="card border-0 mb-3">
                            <div class="card-header bg-light border-0 p-3" id="headingTwo">
                                <h5 class="mb-0">
                                    <button class="btn btn-link text-dark text-decoration-none collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        <i class="fa fa-plus-circle text-flower mr-2"></i> Phí giao hàng là bao nhiêu?
                                    </button>
                                </h5>
                            </div>
                            <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#faqAccordion">
                                <div class="card-body py-3 px-5">
                                    Phí giao hàng phụ thuộc vào khoảng cách và thời gian giao hàng. Trong nội thành Hà Nội, phí giao hàng từ 20.000đ đến 50.000đ.
                                </div>
                            </div>
                        </div>
                        
                        <!-- FAQ Item 3 -->
                        <div class="card border-0 mb-3">
                            <div class="card-header bg-light border-0 p-3" id="headingThree">
                                <h5 class="mb-0">
                                    <button class="btn btn-link text-dark text-decoration-none collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        <i class="fa fa-plus-circle text-flower mr-2"></i> Thời gian giao hàng là bao lâu?
                                    </button>
                                </h5>
                            </div>
                            <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#faqAccordion">
                                <div class="card-body py-3 px-5">
                                    Sau khi đặt hàng thành công, đơn hàng sẽ được cập nhật tự động và thời gian giao hàng sẽ từ 4-6h tùy vào sản phẩm khách hàng lựa chọn. Nếu có thắc mắc gì thêm vui lòng liên hệ trực tiếp với bộ phận CSKH.
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- FAQ Section End -->

    <!-- Footer Start -->
    <jsp:include page="footer.jsp" />
    <!-- Footer End -->

    <!-- Back to Top -->
    <a href="#" class="btn btn-flower back-to-top"><i class="fa fa-angle-double-up"></i></a>

    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>

    <!-- Contact Javascript File -->
    <script src="mail/jqBootstrapValidation.min.js"></script>
    <script src="mail/contact.js"></script>

    <!-- Template Javascript -->
    <script src="js/main.js"></script>
    
    <script>
        // Hiệu ứng cho accordion FAQ
        $('.collapse').on('show.bs.collapse', function() {
            $(this).prev().find('i').removeClass('fa-plus-circle').addClass('fa-minus-circle');
        }).on('hide.bs.collapse', function() {
            $(this).prev().find('i').removeClass('fa-minus-circle').addClass('fa-plus-circle');
        });
        
        // Hiệu ứng animation khi scroll
        $(window).scroll(function() {
            $('.contact-info-card').each(function() {
                var position = $(this).offset().top;
                var scroll = $(window).scrollTop();
                var windowHeight = $(window).height();
                
                if (scroll > position - windowHeight + 100) {
                    $(this).addClass('animated fadeInUp');
                }
            });
        });
    </script>
</body>

</html>
