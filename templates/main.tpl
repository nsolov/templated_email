<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Wellivia Wellness Notification</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f5f8;
      margin: 0;
      padding: 0;
    }
    .container {
      background-color: #ffffff;
      max-width: 600px;
      margin: 30px auto;
      padding: 20px 30px;
      border-radius: 10px;
      box-shadow: 0 3px 8px rgba(0,0,0,0.05);
    }
    .header {
      text-align: center;
      margin-bottom: 20px;
    }
    .header img {
      max-height: 100px;
      margin-bottom: 10px;
    }
    .header-details {
      font-size: 14px;
      color: #666;
      line-height: 1.4;
    }
    .content {
      font-size: 16px;
      color: #333;
      line-height: 1.6;
    }
    .button {
      display: inline-block;
      margin-top: 25px;
      padding: 14px 26px;
      background-color: #d63384;
      color: #333;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-weight: bold;
      font-size: 16px;
    }
    .footer {
      margin-top: 40px;
      font-size: 12px;
      color: #999;
      text-align: center;
      line-height: 1.6;
    }
    .footer img {
      height: 60px;
      margin-bottom: 10px;
    }
    .social-icons img {
      margin: 0 6px;
      width: 30px;
      height: 30px;
    }
    a {
      color: #d63384;
      text-decoration: none;
    }
    li p {
        display: inline;
    }
  </style>
</head>
<body>
  <div class="container">

    <!-- Header -->
    <div class="header">
        <table width="600" border="0">
            <tr>
                <td><img src="https://nsolov.com/img/wellivia.png" alt="Wellivia Logo"></td>
                <td width="90%">
                    <div class="header-details">
                        <strong>Wellivia Wellness</strong><br>
                        &#128205; 123 Harmony Avenue, Serenity City<br>
                        &#9742; +1 (800) 555-9876 &nbsp; | &nbsp; &#128338; Mon-Fri: 08:00-19:00<br>
                        &#127760; <a href="https://wellivia.com">wellivia.com</a>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <!-- Content -->
    <div class="content">
      {{content}}
    </div>

    <!-- Footer -->
    <div class="footer">
      <img src="https://nsolov.com/img/wellivia.png" alt="Wellivia Logo">
      <p>123 Harmony Avenue, Serenity City<br>
      +1 (800) 555-9876 | <a href="https://wellivia.com">wellivia.com</a></p>

      <div class="social-icons">
        <a href="https://facebook.com/wellivia"><img src="https://nsolov.com/img/f.png" alt="Facebook"></a>
        <a href="https://instagram.com/wellivia"><img src="https://nsolov.com/img/i.png" alt="Instagram"></a>
        <a href="https://twitter.com/wellivia"><img src="https://nsolov.com/img/t.png" alt="Twitter"></a>
      </div>

      <p>
        <a href="https://wellivia.com/subsription/">Unsubscribe</a><br/> &#169; {{year}} Wellivia Wellness
      </p>
    </div>
  </div>
</body>
</html>
