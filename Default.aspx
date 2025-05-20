<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Booking_system.Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome to Event Booking System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style type="text/css">
        /* 
         * Event Booking System Main Stylesheet
         * Modern CSS with enhanced features and responsiveness
         */

        /* ========== GLOBAL STYLES ========== */
        :root {
            --primary-color: #1e3c72;
            --primary-light: #2a5298;
            --primary-gradient: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
            --secondary-color: #6c5ce7;
            --text-color: #333;
            --text-light: #666;
            --body-bg: #f8f9fa;
            --white: #fff;
            --card-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            --card-shadow-hover: 0 15px 35px rgba(0, 0, 0, 0.1);
            --section-padding: 100px 0;
            --border-radius: 10px;
            --transition-speed: 0.3s;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
            color: var(--text-color);
            line-height: 1.6;
            background-color: var(--body-bg);
            overflow-x: hidden;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* ========== TYPOGRAPHY ========== */
        h1, h2, h3, h4, h5, h6 {
            margin-top: 0;
            font-weight: 600;
            line-height: 1.2;
            color: var(--primary-color);
        }

        p {
            margin-top: 0;
            margin-bottom: 1rem;
        }

        a {
            text-decoration: none;
            color: var(--primary-color);
            transition: all var(--transition-speed) ease;
        }

        /* ========== HEADER & NAVIGATION ========== */
        .header {
            background-color: #25417b; /* Dark blue color from the image */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 0;
        }

        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            position: relative;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: white;
            text-decoration: none;
            transition: color var(--transition-speed);
        }

        .logo:hover {
            color: #f0f0f0;
        }

        .nav-links {
            display: flex;
            gap: 30px;
        }

        .nav-links a, .nav-links .aspNetDisabled {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: color var(--transition-speed);
            padding: 8px 0;
            position: relative;
        }

        .nav-links a:hover, .nav-links .aspNetDisabled:hover {
            color: #f0f0f0;
        }
        
        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: white;
            transition: width 0.3s ease;
        }
        
        .nav-links a:hover::after {
            width: 100%;
        }
        
        .user-info {
            margin-left: 30px;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .user-info .username {
            font-weight: 600;
            color: white;
        }

        .mobile-menu-btn {
            display: none;
            background: none;
            border: none;
            color: var(--white);
            font-size: 24px;
            cursor: pointer;
        }

        /* ========== HERO SECTION ========== */
        .hero {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 120px 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(108, 92, 231, 0.1);
            z-index: 1;
        }

        .hero::after {
            content: '';
            position: absolute;
            bottom: -80px;
            left: -80px;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            background: rgba(30, 60, 114, 0.08);
            z-index: 1;
        }

        .hero h1 {
            font-size: 3.5rem;
            margin-bottom: 20px;
            color: var(--primary-color);
            text-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            animation: fadeInDown 1s ease;
        }

        .hero p {
            font-size: 1.3rem;
            max-width: 700px;
            margin: 0 auto 40px;
            color: var(--text-light);
            animation: fadeInUp 1s ease 0.3s backwards;
        }

        /* ========== BUTTONS ========== */
        .btn {
            display: inline-block;
            background-color: var(--primary-color);
            color: var(--white);
            padding: 14px 30px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: all var(--transition-speed);
            margin: 0 10px;
            box-shadow: 0 4px 15px rgba(30, 60, 114, 0.3);
            border: none;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.1);
            transition: width var(--transition-speed);
            z-index: -1;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 7px 20px rgba(30, 60, 114, 0.4);
        }

        .btn:hover::before {
            width: 100%;
        }

        .btn-outline {
            background-color: transparent;
            border: 2px solid var(--primary-color);
            color: var(--primary-color);
        }

        .btn-outline:hover {
            background-color: var(--primary-color);
            color: var(--white);
        }

        .admin-btn {
            background-color: var(--secondary-color);
            margin-top: 20px;
        }

        .admin-btn:hover {
            background-color: #5341d6;
        }

        /* ========== FEATURE SECTION ========== */
        .features {
            padding: var(--section-padding);
            background-color: var(--white);
        }

        .section-title {
            text-align: center;
            margin-bottom: 60px;
            color: var(--primary-color);
            font-size: 2.5rem;
            position: relative;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: var(--primary-gradient);
            margin: 15px auto 0;
            border-radius: 2px;
        }

        .feature-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-top: 40px;
        }

        .feature-item {
            flex-basis: 30%;
            margin-bottom: 50px;
            text-align: center;
            padding: 40px 25px;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: all var(--transition-speed);
            background-color: var(--white);
            position: relative;
            z-index: 1;
            overflow: hidden;
        }

        .feature-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 0;
            background: linear-gradient(180deg, rgba(30, 60, 114, 0.03) 0%, rgba(30, 60, 114, 0) 100%);
            transition: height var(--transition-speed);
            z-index: -1;
        }

        .feature-item:hover {
            transform: translateY(-10px);
            box-shadow: var(--card-shadow-hover);
        }

        .feature-item:hover::before {
            height: 100%;
        }

        .feature-icon {
            font-size: 48px;
            margin-bottom: 25px;
            color: var(--primary-color);
            display: inline-block;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            width: 100px;
            height: 100px;
            line-height: 100px;
            border-radius: 50%;
            transition: transform var(--transition-speed);
        }

        .feature-item:hover .feature-icon {
            transform: scale(1.1);
        }

        .feature-item h3 {
            margin-bottom: 20px;
            color: var(--primary-color);
            font-size: 22px;
        }

        .feature-item p {
            color: var(--text-light);
        }

        /* ========== HOW IT WORKS SECTION ========== */
        .how-it-works {
            background-color: var(--body-bg);
            padding: var(--section-padding);
            position: relative;
            overflow: hidden;
        }

        .how-it-works::before {
            content: '';
            position: absolute;
            right: -200px;
            top: 50%;
            transform: translateY(-50%);
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(30, 60, 114, 0.05) 0%, rgba(30, 60, 114, 0) 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .steps {
            display: flex;
            justify-content: space-between;
            max-width: 900px;
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }

        .step {
            text-align: center;
            flex-basis: 30%;
            position: relative;
        }

        .step-number {
            width: 60px;
            height: 60px;
            background: var(--primary-gradient);
            color: var(--white);
            font-size: 24px;
            font-weight: bold;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            position: relative;
            z-index: 2;
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3);
            transition: transform var(--transition-speed);
        }

        .step:hover .step-number {
            transform: scale(1.1);
        }

        .step h3 {
            margin-bottom: 15px;
            color: var(--primary-color);
        }

        .step:not(:last-child)::after {
            content: '';
            position: absolute;
            width: 70%;
            height: 2px;
            background: #d1d5db;
            top: 30px;
            left: 65%;
            z-index: 1;
        }

        /* ========== TESTIMONIALS SECTION ========== */
        .testimonials {
            padding: var(--section-padding);
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
        }

        .testimonial-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-top: 40px;
        }

        .testimonial {
            flex-basis: 30%;
            background: var(--white);
            padding: 30px;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            margin-bottom: 30px;
            transition: all var(--transition-speed);
            transform: translateY(0);
        }

        .testimonial:hover {
            transform: translateY(-10px);
            box-shadow: var(--card-shadow-hover);
        }

        .testimonial-content {
            margin-bottom: 20px;
            font-style: italic;
            color: var(--text-light);
            position: relative;
            padding-left: 30px;
        }

        .testimonial-content::before {
            content: '"';
            font-family: Georgia, serif;
            font-size: 60px;
            position: absolute;
            left: 0;
            top: -20px;
            color: var(--primary-color);
            opacity: 0.2;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
        }

        .testimonial-author img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }

        .author-info h4 {
            margin: 0 0 5px;
            color: var(--primary-color);
        }

        .author-info p {
            margin: 0;
            font-size: 14px;
            color: var(--text-light);
        }

        /* ========== CTA SECTION ========== */
        .cta {
            padding: 100px 0;
            text-align: center;
            background: var(--primary-gradient);
            color: var(--white);
            position: relative;
            overflow: hidden;
        }

        .cta::before, .cta::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
        }

        .cta::before {
            top: -150px;
            right: -150px;
        }

        .cta::after {
            bottom: -150px;
            left: -150px;
        }

        .cta h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
            color: var(--white);
        }

        .cta p {
            max-width: 600px;
            margin: 0 auto 30px;
            font-size: 1.2rem;
            opacity: 0.9;
        }

        .cta .btn {
            background-color: var(--white);
            color: var(--primary-color);
            padding: 15px 40px;
            font-size: 18px;
        }

        .cta .btn:hover {
            background-color: rgba(255, 255, 255, 0.9);
        }

        /* ========== FEATURED VENUES SECTION ========== */
        .featured-venues {
            padding: var(--section-padding);
            background-color: var(--white);
        }

        .venue-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-top: 40px;
        }

        .venue-item {
            flex-basis: 30%;
            margin-bottom: 50px;
            text-align: center;
            padding: 0 0 25px 0;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: all var(--transition-speed);
            background-color: var(--white);
            overflow: hidden;
        }

        .venue-item:hover {
            transform: translateY(-10px);
            box-shadow: var(--card-shadow-hover);
        }

        .venue-image {
            height: 200px;
            background-position: center;
            background-size: cover;
            background-repeat: no-repeat;
            transition: transform var(--transition-speed);
        }

        /* Setting placeholder images for each venue */
        .venue-image-gym {
            background-image: url('https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80');
        }

        .venue-image-centrum {
            background-image: url('Centrum.jpg');
        }

        .venue-image-garden {
            background-image: url('https://images.unsplash.com/photo-1566737236500-c8ac43014a67?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80');
        }

        .venue-item:hover .venue-image {
            transform: scale(1.05);
        }

        .venue-item h3 {
            margin: 25px 0 15px;
            color: var(--primary-color);
            font-size: 22px;
            padding: 0 20px;
        }

        .venue-item p {
            color: var(--text-light);
            padding: 0 20px;
            margin-bottom: 20px;
        }

        .venue-details {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 15px 20px 0;
            border-top: 1px solid #f1f1f1;
        }

        .venue-details span {
            display: block;
            margin-bottom: 10px;
            color: var(--text-light);
            font-size: 14px;
            font-weight: 500;
        }

        /* ========== FOOTER ========== */
        .footer {
            background-color: var(--primary-color);
            color: var(--white);
            padding: 80px 0 20px;
        }

        .footer-content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin-bottom: 40px;
        }

        .footer-column {
            flex-basis: 23%;
        }

        .footer-column h3 {
            margin-bottom: 25px;
            font-size: 20px;
            color: var(--white);
            position: relative;
        }

        .footer-column h3::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: -10px;
            width: 40px;
            height: 3px;
            background-color: rgba(255, 255, 255, 0.3);
        }

        .footer-column p {
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 20px;
        }

        .footer-column ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .footer-column ul li {
            margin-bottom: 12px;
        }

        .footer-column ul li a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all var(--transition-speed);
            position: relative;
            padding-left: 15px;
        }

        .footer-column ul li a::before {
            content: '›';
            position: absolute;
            left: 0;
            opacity: 0.7;
            transition: transform var(--transition-speed);
        }

        .footer-column ul li a:hover {
            color: var(--white);
            padding-left: 20px;
        }

        .footer-column ul li a:hover::before {
            transform: translateX(5px);
            opacity: 1;
        }

        .footer-bottom {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.6);
            font-size: 14px;
        }

        /* ========== ANIMATIONS ========== */
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
            100% {
                transform: scale(1);
            }
        }

        /* ========== RESPONSIVE DESIGN ========== */
        @media screen and (max-width: 1200px) {
            .container {
                width: 95%;
            }
        }

        @media screen and (max-width: 992px) {
            .feature-item, .testimonial, .venue-item {
                flex-basis: 48%;
            }
            
            .footer-column {
                flex-basis: 48%;
                margin-bottom: 30px;
            }
            
            .hero h1 {
                font-size: 3rem;
            }
        }

        @media screen and (max-width: 768px) {
            .container {
                width: 90%;
            }
            
            .nav-links {
                position: fixed;
                top: 0;
                right: -100%;
                width: 70%;
                height: 100vh;
                background-color: var(--primary-color);
                flex-direction: column;
                align-items: center;
                justify-content: center;
                transition: all 0.5s ease;
                z-index: 110;
            }
            
            .nav-links.active {
                right: 0;
            }
            
            .nav-links a {
                margin: 15px 0;
                font-size: 18px;
            }
            
            .mobile-menu-btn {
                display: block;
                z-index: 120;
            }
            
            .step:not(:last-child)::after {
                display: none;
            }
            
            .hero h1 {
                font-size: 2.5rem;
            }
            
            .hero p {
                font-size: 1.1rem;
            }
            
            .section-title {
                font-size: 2rem;
            }
        }

        @media screen and (max-width: 576px) {
            .feature-item, .testimonial, .venue-item, .footer-column {
                flex-basis: 100%;
            }
            
            .steps {
                flex-direction: column;
            }
            
            .step {
                margin-bottom: 50px;
            }
            
            .hero h1 {
                font-size: 2rem;
            }
            
            .hero {
                padding: 80px 0;
            }
            
            .features, .how-it-works, .testimonials, .featured-venues {
                padding: 60px 0;
            }
            
            .section-title {
                margin-bottom: 40px;
            }
            
            .btn {
                display: block;
                margin: 10px auto;
                max-width: 80%;
            }
        }

        /* ========== ABOUT US SECTION STYLES ========== */
        .about-section-home {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            padding: var(--section-padding);
            position: relative;
            overflow: hidden;
            border-top: 1px solid rgba(30, 60, 114, 0.1);
        }
        
        .about-section-home::before {
            content: '';
            position: absolute;
            top: -100px;
            right: -100px;
            width: 300px;
            height: 300px;
            background: radial-gradient(circle, rgba(30, 60, 114, 0.05) 0%, rgba(30, 60, 114, 0) 70%);
            border-radius: 50%;
            z-index: 0;
        }
        
        .about-section-home::after {
            content: '';
            position: absolute;
            bottom: -150px;
            left: -150px;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(30, 60, 114, 0.03) 0%, rgba(30, 60, 114, 0) 70%);
            border-radius: 50%;
            z-index: 0;
        }
        
        .about-content {
            display: flex;
            flex-wrap: wrap;
            gap: 50px;
            margin-bottom: 60px;
            position: relative;
            z-index: 1;
        }
        
        .about-text {
            flex: 1;
            min-width: 300px;
            animation: fadeInLeft 1s ease-out;
        }
        
        .about-features {
            flex: 1;
            min-width: 300px;
            animation: fadeInRight 1s ease-out;
        }
        
        .about-section-home h3 {
            color: var(--primary-color);
            margin-bottom: 25px;
            font-size: 26px;
            position: relative;
            padding-bottom: 12px;
            border-bottom: none;
            font-weight: 600;
            letter-spacing: -0.5px;
        }
        
        .about-section-home h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary-gradient);
            border-radius: 3px;
            transition: width 0.3s ease;
        }
        
        .about-section-home h3:hover:after {
            width: 100px;
        }
        
        .about-section-home p {
            line-height: 1.9;
            margin-bottom: 22px;
            color: var(--text-light);
            font-size: 17px;
        }
        
        .about-team {
            background-color: var(--white);
            padding: 45px;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            z-index: 1;
            animation: fadeInUp 1s ease-out;
        }
        
        .about-team:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .features-grid {
            display: flex;
            flex-wrap: wrap;
            margin: 25px -15px;
        }
        
        .feature {
            flex: 1 0 calc(50% - 30px);
            margin: 15px;
            background: var(--white);
            border-radius: var(--border-radius);
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .feature::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 0;
            background: var(--primary-gradient);
            transition: height 0.3s ease;
            z-index: -1;
        }
        
        .feature:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.1);
        }
        
        .feature:hover::before {
            height: 100%;
        }
        
        .feature h4 {
            color: var(--primary-color);
            margin-bottom: 15px;
            font-size: 20px;
            position: relative;
            transition: transform 0.3s ease, padding-left 0.3s ease;
        }
        
        .feature:hover h4 {
            transform: translateY(-2px);
            padding-left: 10px;
        }
        
        .feature p {
            transition: padding-left 0.3s ease;
        }
        
        .feature:hover p {
            padding-left: 10px;
        }
        
        /* ========== CONTACT US SECTION STYLES ========== */
        .contact-section-home {
            background-color: var(--white);
            padding: var(--section-padding);
            position: relative;
            border-top: 1px solid rgba(30, 60, 114, 0.1);
        }
        
        .contact-section-home:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, rgba(30, 60, 114, 0.03) 0%, rgba(30, 60, 114, 0) 100%);
            z-index: 0;
        }
        
        .contact-section-home .container {
            position: relative;
            z-index: 1;
        }
        
        .contact-section-home .contact-container {
            display: flex;
            flex-wrap: wrap;
            gap: 50px;
            margin-top: 50px;
            animation: fadeInUp 1s ease-out;
        }
        
        .contact-section-home .contact-info,
        .contact-section-home .contact-form {
            flex: 1;
            min-width: 300px;
            transition: transform 0.3s ease;
        }
        
        .contact-section-home .contact-info {
            background-color: rgba(248, 250, 252, 0.8);
            padding: 35px;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
        }
        
        .contact-section-home .contact-form {
            background-color: var(--white);
            padding: 35px;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
        }
        
        .contact-section-home .contact-info:hover,
        .contact-section-home .contact-form:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .contact-section-home h3 {
            color: var(--primary-color);
            margin-bottom: 25px;
            font-size: 26px;
            position: relative;
            padding-bottom: 12px;
            border-bottom: none;
            font-weight: 600;
            letter-spacing: -0.5px;
        }
        
        .contact-section-home h3:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 60px;
            height: 3px;
            background: var(--primary-gradient);
            border-radius: 3px;
            transition: width 0.3s ease;
        }
        
        .contact-section-home h3:hover:after {
            width: 100px;
        }
        
        .contact-section-home .contact-details {
            list-style: none;
            padding: 0;
            margin: 25px 0;
        }
        
        .contact-section-home .contact-details li {
            margin-bottom: 20px;
            padding-left: 40px;
            position: relative;
            color: var(--text-light);
            font-size: 16px;
            transition: transform 0.3s ease;
        }
        
        .contact-section-home .contact-details li:hover {
            transform: translateX(5px);
        }
        
        .contact-section-home .contact-details li i {
            position: absolute;
            left: 0;
            top: 50%;
            transform: translateY(-50%);
            width: 30px;
            height: 30px;
            background: var(--primary-gradient);
            border-radius: 50%;
            color: var(--white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }
        
        .contact-section-home .hours {
            background-color: rgba(255, 255, 255, 0.7);
            padding: 20px;
            border-radius: 8px;
            margin-top: 30px;
            border-left: 4px solid var(--primary-color);
            transition: transform 0.3s ease;
        }
        
        .contact-section-home .hours:hover {
            transform: translateX(5px);
        }
        
        .contact-section-home .hours h4 {
            color: var(--primary-color);
            font-size: 18px;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .contact-section-home .hours p {
            color: var(--text-light);
            margin-bottom: 8px;
            display: flex;
            justify-content: space-between;
        }
        
        .contact-section-home .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .contact-section-home label {
            display: block;
            margin-bottom: 10px;
            font-weight: 500;
            color: var(--text-color);
            transition: color 0.3s ease;
        }
        
        .contact-section-home .form-group:focus-within label {
            color: var(--primary-color);
        }
        
        .contact-section-home .textbox {
            width: 100%;
            padding: 14px 18px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: #f9fafc;
        }
        
        .contact-section-home .textbox:focus {
            border-color: var(--primary-color);
            background-color: var(--white);
            outline: none;
            box-shadow: 0 0 0 3px rgba(30, 60, 114, 0.1);
            transform: translateY(-2px);
        }
        
        .contact-section-home .button {
            background: var(--primary-gradient);
            color: white;
            border: none;
            padding: 14px 30px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .contact-section-home .button::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            transition: width 0.3s ease;
            z-index: -1;
        }
        
        .contact-section-home .button:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(30, 60, 114, 0.4);
        }
        
        .contact-section-home .button:hover::before {
            width: 100%;
        }
        
        .contact-section-home .message {
            display: block;
            margin-top: 20px;
            padding: 15px;
            border-radius: 8px;
            font-weight: 500;
            transform: translateY(0);
            animation: fadeInUp 0.5s ease-out;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        
        .contact-section-home .error {
            background-color: #fff5f5;
            color: #e53e3e;
            border-left: 4px solid #e53e3e;
        }
        
        .contact-section-home .success {
            background-color: #f0fff4;
            color: #38a169;
            border-left: 4px solid #38a169;
        }
        
        /* Animations */
        @keyframes fadeInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes fadeInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @media (max-width: 768px) {
            .about-content, 
            .contact-section-home .contact-container {
                flex-direction: column;
                gap: 30px;
            }
            
            .feature {
                flex: 1 0 100%;
            }
            
            .contact-section-home .contact-info,
            .contact-section-home .contact-form {
                padding: 25px;
            }
            
            .about-section-home h3,
            .contact-section-home h3 {
                font-size: 22px;
            }
        }
        
        /* ========== UPCOMING EVENTS SECTION ========== */
        .upcoming-events {
            background-color: #f8f9fa;
            padding: var(--section-padding);
            position: relative;
            border-top: 1px solid rgba(30, 60, 114, 0.1);
        }
        
        .section-description {
            text-align: center;
            max-width: 700px;
            margin: -20px auto 50px;
            color: var(--text-light);
            font-size: 1.1rem;
        }
        
        .events-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .event-card {
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            overflow: hidden;
            display: flex;
            width: calc(50% - 15px);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 5px solid var(--primary-color);
        }
        
        .event-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--card-shadow-hover);
        }
        
        .event-date {
            padding: 20px;
            background: linear-gradient(to bottom, var(--primary-color), var(--primary-light));
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            min-width: 100px;
        }
        
        .date-box {
            text-align: center;
        }
        
        .date-box .month {
            display: block;
            font-size: 1rem;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .date-box .day {
            display: block;
            font-size: 2rem;
            font-weight: 700;
            line-height: 1;
            margin-top: 5px;
        }
        
        .event-details {
            padding: 20px;
            flex: 1;
        }
        
        .event-title {
            margin-top: 0;
            margin-bottom: 10px;
            color: var(--primary-color);
            font-size: 1.4rem;
        }
        
        .event-time, .event-location, .event-organizer {
            margin-bottom: 8px;
            color: var(--text-light);
            font-size: 0.9rem;
        }
        
        .event-time i, .event-location i, .event-organizer i {
            width: 20px;
            color: var(--primary-color);
        }
        
        .event-description {
            margin-top: 15px;
            font-size: 0.95rem;
            line-height: 1.5;
            color: var(--text-color);
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        
        .no-events {
            text-align: center;
            padding: 40px;
            background-color: white;
            border-radius: var(--border-radius);
            box-shadow: var(--card-shadow);
            width: 100%;
        }
        
        .no-events p {
            color: var(--text-light);
            margin-bottom: 15px;
        }
        
        .no-events a {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: underline;
        }
        
        .events-footer {
            text-align: center;
        }
        
        .events-footer p {
            font-size: 1.1rem;
            color: var(--text-light);
        }
        
        .link-highlight {
            color: var(--primary-color);
            font-weight: 600;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .link-highlight:hover {
            color: var(--primary-light);
        }
        
        .link-highlight:after {
            content: '';
            position: absolute;
            width: 100%;
            height: 2px;
            bottom: -2px;
            left: 0;
            background-color: var(--primary-color);
            transform: scaleX(0);
            transform-origin: bottom right;
            transition: transform 0.3s ease;
        }
        
        .link-highlight:hover:after {
            transform: scaleX(1);
            transform-origin: bottom left;
        }
        
        @media (max-width: 992px) {
            .event-card {
                width: 100%;
            }
        }
        
        @media (max-width: 576px) {
            .event-card {
                flex-direction: column;
                border-left: none;
                border-top: 5px solid var(--primary-color);
            }
            
            .event-date {
                width: 100%;
                padding: 15px;
                flex-direction: row;
                justify-content: center;
                min-width: auto;
            }
            
            .date-box {
                display: flex;
                align-items: center;
            }
            
            .date-box .month {
                margin-right: 10px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <div class="container">
                <div class="navbar">
                    <div class="logo">Event Booking System</div>
                    <div class="nav-links">
                        <a href="Default.aspx">Home</a>
                        <a href="#about-us">About Us</a>
                        <a href="#upcoming-events">Events</a>
                        <a href="#contact-us">Contact Us</a>
                        <% if (User.Identity.IsAuthenticated) { %>
                            <a href="Dashboard.aspx">Dashboard</a>
                            <a href="BookingForm.aspx">New Booking</a>
                            <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click">Logout</asp:LinkButton>
                        <% } else { %>
                            <a href="Login.aspx">User Login</a>
                            <a href="RegisterUser.aspx">Register</a>
                            <a href="AdminLogin.aspx">Admin</a>
                        <% } %>
                    </div>
                    <% if (User.Identity.IsAuthenticated) { %>
                    <div class="user-info">
                        Welcome, <span class="username"><%= User.Identity.Name %></span>!
                    </div>
                    <% } %>
                    <button type="button" class="mobile-menu-btn">≡</button>
                </div>
            </div>
        </div>
        
        <div class="hero">
            <div class="container">
                <h1>Streamline Your Event Bookings</h1>
                <p>An all-in-one solution for planning, scheduling, and managing events with ease.</p>
                <% if (!User.Identity.IsAuthenticated) { %>
                    <a href="Login.aspx" class="btn">User Login</a>
                    <a href="RegisterUser.aspx" class="btn btn-outline">Create Account</a>
                    <div style="margin-top: 20px;">
                        <a href="AdminLogin.aspx" class="btn admin-btn">Admin Access</a>
                    </div>
                <% } else { %>
                    <a href="Dashboard.aspx" class="btn">Go to Dashboard</a>
                    <a href="BookingForm.aspx" class="btn btn-outline">New Booking</a>
                <% } %>
            </div>
        </div>
        
        <div class="features">
            <div class="container">
                <h2 class="section-title">Why Choose Us</h2>
                <div class="feature-grid">
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M14,6h-4c-1.1,0-2,0.9-2,2v8c0,1.1,0.9,2,2,2h4c1.1,0,2-0.9,2-2V8C16,6.9,15.1,6,14,6z M16,18H8V10h8V18z M16,8H8V6h8V8z M10,12h4v4h-4V12z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>Easy Scheduling</h3>
                        <p>Book events, manage schedules, and keep track of all your upcoming appointments in one place.</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M9,11c1.1,0,2-0.9,2-2s-0.9-2-2-2S7,7.9,7,9S7.9,11,9,11z M9,13c-2.7,0-5.8,1.3-5.8,4v1h11.6v-1C14.8,14.3,11.7,13,9,13z M15,12c1.1,0,2-0.9,2-2s-0.9-2-2-2s-2,0.9-2,2S13.9,12,15,12z M15,14c-0.7,0-1.4,0.1-2,0.3c1.2,0.8,2,2.1,2,3.7v1h5v-1C20,15.3,17.7,14,15,14z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>User Management</h3>
                        <p>Separate dashboards for users and administrators for complete control over the booking process.</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M13,17.5h-2v-6h2V17.5z M13,9.5h-2v-2h2V9.5z M19,14.5l-2.25-2.5L19,9.5h-4v8h4V14.5z M9,9.5H5l2.25,2.5L5,14.5h4v-8z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>Real-time Updates</h3>
                        <p>Get instant notifications and updates on booking statuses and changes to stay informed.</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M12,17c1.1,0,2-0.9,2-2s-0.9-2-2-2s-2,0.9-2,2S10.9,17,12,17z M12,9c1.1,0,2-0.9,2-2s-0.9-2-2-2S10,5.9,10,7S10.9,9,12,9z M18,8h-1V6c0-2.8-2.2-5-5-5S7,3.2,7,6v2H6c-1.1,0-2,0.9-2,2v10c0,1.1,0.9,2,2,2h12c1.1,0,2-0.9,2-2V10C20,8.9,19.1,8,18,8z M8.9,6c0-1.7,1.4-3.1,3.1-3.1s3.1,1.4,3.1,3.1v2H8.9V6z M18,20H6V10h12V20z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>Secure Access</h3>
                        <p>Your data is safe with our secure login and authentication system. Privacy guaranteed.</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M10,8h6V6h-6V8z M6,16h12v-2H6V16z M6,12h12v-2H6V12z M6,18h8v-2H6V18z M6,8h2V6H6V8z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>Admin Controls</h3>
                        <p>Admins can manage users, approve bookings, and monitor system activity with powerful tools.</p>
                    </div>
                    <div class="feature-item">
                        <div class="feature-icon">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
                                <circle cx="12" cy="12" r="10" fill="#e8eef9"/>
                                <path d="M15.5,1h-8C6.12,1,5,2.12,5,3.5v17C5,21.88,6.12,23,7.5,23h8c1.38,0,2.5-1.12,2.5-2.5v-17C18,2.12,16.88,1,15.5,1z M11.5,21.5c-0.83,0-1.5-0.67-1.5-1.5s0.67-1.5,1.5-1.5s1.5,0.67,1.5,1.5S12.33,21.5,11.5,21.5z M16,17H7V4h9V17z" fill="#1e3c72"/>
                            </svg>
                        </div>
                        <h3>Responsive Design</h3>
                        <p>Access the system from any device with our mobile-friendly interface. Book on the go!</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="how-it-works">
            <div class="container">
                <h2 class="section-title">How It Works</h2>
                <div class="steps">
                    <div class="step">
                        <div class="step-number">1</div>
                        <h3>Create Account</h3>
                        <p>Sign up for a free account to access all booking features.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <h3>Book Event</h3>
                        <p>Fill in the details for your event and submit for approval.</p>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <h3>Get Approved</h3>
                        <p>Admin reviews and approves your booking request.</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="testimonials">
            <div class="container">
                <h2 class="section-title">What Our Users Say</h2>
                <div class="testimonial-grid">
                    <div class="testimonial">
                        <div class="testimonial-content">
                            "This booking system has transformed how we manage our conference rooms. The approval process is streamlined and efficient."
                        </div>
                        <div class="testimonial-author">
                            <div class="author-info">
                                <h4>Sarah Johnson</h4>
                                <p>Office Manager</p>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial">
                        <div class="testimonial-content">
                            "As an administrator, I love how easy it is to approve or decline booking requests. The dashboard gives me all the information I need at a glance."
                        </div>
                        <div class="testimonial-author">
                            <div class="author-info">
                                <h4>Michael Chen</h4>
                                <p>Event Coordinator</p>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial">
                        <div class="testimonial-content">
                            "The user interface is intuitive and responsive. I can book events from my phone, which is incredibly convenient."
                        </div>
                        <div class="testimonial-author">
                            <div class="author-info">
                                <h4>Emma Rodriguez</h4>
                                <p>Marketing Director</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="featured-venues">
            <div class="container">
                <h2 class="section-title">Featured Venues</h2>
                <div class="venue-grid">
                    <div class="venue-item">
                        <div class="venue-image venue-image-gym"></div>
                        <h3>Kadasig Gym</h3>
                        <p>A spacious gymnasium perfect for sports events, competitions, and large gatherings. Features modern facilities, ample seating, and excellent acoustics.</p>
                        <div class="venue-details">
                            <span>Capacity: 500 people</span>
                            <span>Available for: Sports events, Competitions, Concerts</span>
                        </div>
                    </div>
                    <div class="venue-item">
                        <div class="venue-image">
                            <asp:Image ID="CentrumImage" runat="server" ImageUrl="~/Centrum.jpg" CssClass="venue-image-centrum" />
                        </div>
                        <h3>Centrum Facility</h3>
                        <p>An elegant multipurpose hall ideal for conferences, seminars, and corporate events. Equipped with state-of-the-art presentation technology and flexible seating arrangements.</p>
                        <div class="venue-details">
                            <span>Capacity: 300 people</span>
                            <span>Available for: Conferences, Seminars, Corporate events</span>
                        </div>
                    </div>
                    <div class="venue-item">
                        <div class="venue-image venue-image-garden"></div>
                        <h3>Garden Pavilion</h3>
                        <p>A beautiful outdoor venue surrounded by lush gardens, perfect for weddings, parties, and social gatherings. Offers a picturesque setting with natural lighting.</p>
                        <div class="venue-details">
                            <span>Capacity: 200 people</span>
                            <span>Available for: Weddings, Parties, Social gatherings</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- About Us Section -->
        <div id="about-us" class="about-section-home">
            <div class="container">
                <h2 class="section-title">About Us</h2>
                
                <div class="about-content">
                    <div class="about-text">
                        <h3>Our Story</h3>
                        <p>
                            The Event Booking System was founded in 2023 with a simple mission: to make event management and booking as effortless as possible. 
                            What started as a small project to help local venues manage their bookings has grown into a comprehensive platform serving organizations of all sizes.
                        </p>
                        <p>
                            Our team of dedicated professionals combines expertise in event management, software development, and customer service to deliver a seamless booking experience 
                            for both venue administrators and users.
                        </p>
                        
                        <h3>Our Mission</h3>
                        <p>
                            We strive to simplify the event booking process through innovative technology while maintaining the human touch that makes each event special. 
                            Our platform is designed to be intuitive, reliable, and adaptable to the unique needs of different venues and event types.
                        </p>
                    </div>
                    
                    <div class="about-features">
                        <h3>Why Choose Us?</h3>
                        <div class="features-grid">
                            <div class="feature">
                                <h4>User-Friendly Interface</h4>
                                <p>Our platform is designed with simplicity in mind, making it easy for anyone to book and manage events.</p>
                            </div>
                            <div class="feature">
                                <h4>Secure Authentication</h4>
                                <p>We prioritize the security of your data with robust authentication and privacy measures.</p>
                            </div>
                            <div class="feature">
                                <h4>Efficient Approval Process</h4>
                                <p>Our streamlined approval workflow ensures quick turnaround times for booking requests.</p>
                            </div>
                            <div class="feature">
                                <h4>Comprehensive Reporting</h4>
                                <p>Get insights into booking patterns and venue utilization with our reporting tools.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="about-team">
                    <h3>Our Team</h3>
                    <p>
                        Behind the Event Booking System is a team of passionate professionals dedicated to making event management easier and more efficient. 
                        Our diverse backgrounds in technology, event planning, and customer service allow us to approach challenges from multiple perspectives.
                    </p>
                    <p>
                        We're constantly learning, improving, and adapting our platform based on user feedback and emerging industry trends.
                    </p>
                </div>
            </div>
        </div>
        
        <!-- Contact Us Section -->
        <div id="contact-us" class="contact-section-home">
            <div class="container">
                <h2 class="section-title">Contact Us</h2>
                
                <div class="contact-container">
                    <div class="contact-info">
                        <h3>Get in Touch</h3>
                        <p>Have questions about our booking system? We're here to help!</p>
                        <ul class="contact-details">
                            <li><i class="icon-location"></i> 123 Event Street, BookingCity</li>
                            <li><i class="icon-phone"></i> +1 (555) 123-4567</li>
                            <li><i class="icon-email"></i> info@eventbookingsystem.com</li>
                        </ul>
                        <div class="hours">
                            <h4>Business Hours</h4>
                            <p>Monday - Friday: 9:00 AM - 5:00 PM</p>
                            <p>Saturday: 10:00 AM - 2:00 PM</p>
                            <p>Sunday: Closed</p>
                        </div>
                    </div>
                    <div class="contact-form">
                        <h3>Send us a Message</h3>
                        <div class="form-group">
                            <label for="txtName">Your Name</label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="textbox" placeholder="Enter your name"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtEmail">Your Email</label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" placeholder="Enter your email"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtSubject">Subject</label>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="textbox" placeholder="What is this regarding?"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="txtMessage">Your Message</label>
                            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="textbox" placeholder="How can we help you?"></asp:TextBox>
                        </div>
                        <asp:Button ID="btnSubmit" runat="server" Text="Send Message" CssClass="button" OnClick="btnSubmit_Click" />
                        <asp:Label ID="lblMessage" runat="server" CssClass="message"></asp:Label>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Upcoming Events Section -->
        <div id="upcoming-events" class="upcoming-events">
            <div class="container">
                <h2 class="section-title">Upcoming Events</h2>
                <p class="section-description">Check out these approved events happening soon.</p>
                
                <div class="events-grid">
                    <asp:Repeater ID="rptApprovedEvents" runat="server">
                        <ItemTemplate>
                            <div class="event-card">
                                <div class="event-date">
                                    <div class="date-box">
                                        <span class="month"><%# Convert.ToDateTime(Eval("EventDate")).ToString("MMM") %></span>
                                        <span class="day"><%# Convert.ToDateTime(Eval("EventDate")).ToString("dd") %></span>
                                    </div>
                                </div>
                                <div class="event-details">
                                    <h3 class="event-title"><%# Eval("EventName") %></h3>
                                    <p class="event-time">
                                        <i class="fas fa-clock"></i> 
                                        <%# FormatEventDateTime(Eval("EventDate"), Eval("StartTime"), Eval("EndTime")) %>
                                    </p>
                                    <p class="event-location">
                                        <i class="fas fa-map-marker-alt"></i> 
                                        <%# Eval("Location") %>
                                    </p>
                                    <p class="event-organizer">
                                        <i class="fas fa-user"></i> 
                                        Organized by: <%# Eval("OrganizerName") %>
                                    </p>
                                    <p class="event-description"><%# Eval("Description") %></p>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    
                    <asp:Panel ID="pnlNoEvents" runat="server" CssClass="no-events" Visible="false">
                        <p>No upcoming events at the moment. Check back soon!</p>
                        <p>Want to organize an event? <a href="RegisterUser.aspx">Create an account</a> to get started.</p>
                    </asp:Panel>
                </div>
                
                <div class="events-footer">
                    <% if (!User.Identity.IsAuthenticated) { %>
                    <p>Want to see more events or create your own? <a href="RegisterUser.aspx" class="link-highlight">Sign up now</a></p>
                    <% } else { %>
                    <p>Want to create your own event? <a href="BookingForm.aspx" class="link-highlight">Submit a booking request</a></p>
                    <% } %>
                </div>
            </div>
        </div>
        
        <% if (!User.Identity.IsAuthenticated) { %>
        <div class="cta">
            <div class="container">
                <h2>Ready to Get Started?</h2>
                <p>Join thousands of satisfied users who have streamlined their event booking process.</p>
                <a href="RegisterUser.aspx" class="btn">Create Your Free Account</a>
            </div>
        </div>
        <% } %>
        
        <div class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-column">
                        <h3>Event Booking System</h3>
                        <p>Your comprehensive solution for event management and booking.</p>
                    </div>
                    <div class="footer-column">
                        <h3>Quick Links</h3>
                        <ul>
                            <li><a href="Default.aspx">Home</a></li>
                            <li><a href="#about-us">About Us</a></li>
                            <li><a href="#upcoming-events">Events</a></li>
                            <li><a href="#contact-us">Contact Us</a></li>
                            <li><a href="Login.aspx">User Login</a></li>
                            <li><a href="RegisterUser.aspx">Register</a></li>
                            <li><a href="AdminLogin.aspx">Admin Access</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h3>User Access</h3>
                        <ul>
                            <li><a href="Login.aspx">User Dashboard</a></li>
                            <li><a href="BookingForm.aspx">Book an Event</a></li>
                        </ul>
                    </div>
                    <div class="footer-column">
                        <h3>Admin Access</h3>
                        <ul>
                            <li><a href="AdminLogin.aspx">Admin Login</a></li>
                            <li><a href="AdminRegistration.aspx">Admin Registration</a></li>
                        </ul>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; <%= DateTime.Now.Year %> Event Booking System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </form>
    <script src="scripts/main.js"></script>
</body>
</html> 