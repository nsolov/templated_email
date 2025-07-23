<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Clinic Notification</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f6f6f6;
      margin: 0;
      padding: 0;
    }
    .container {
      background-color: #ffffff;
      max-width: 600px;
      margin: 30px auto;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    .header {
      text-align: center;
      color: #2a7ae2;
      font-size: 24px;
      margin-bottom: 10px;
    }
    .content {
      font-size: 16px;
      color: #333333;
      line-height: 1.5;
    }
    .button {
      display: inline-block;
      margin-top: 20px;
      padding: 12px 24px;
      background-color: #2a7ae2;
      color: white;
      text-decoration: none;
      border-radius: 5px;
    }
    .footer {
      margin-top: 30px;
      font-size: 12px;
      color: #888888;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">Wellivia Clinic</div>
    <div class="content">
      <p>Dear {{name}},</p>

      <p>This is a friendly reminder from <strong>Wellivia Clinic</strong> about your upcoming appointment:</p>

      <ul>
        <li><strong>Date:</strong> {{appointment_date}}</li>
        <li><strong>Time:</strong> {{appointment_time}}</li>
        <li><strong>Doctor:</strong> Dr. {{doctor_name}}</li>
      </ul>

      <p>If you have any questions or need to reschedule, please contact us.</p>

      <a href="{{appointment_link}}" class="button">View Appointment</a>

      <p>Thank you for choosing our clinic!</p>
    </div>
    <div class="footer">
      &#169; {{year}} Your Clinic. All rights reserved.
    </div>
  </div>
</body>
</html>
