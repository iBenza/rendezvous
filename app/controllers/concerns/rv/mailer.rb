require 'mail'
require 'action_gmailer'
require 'premailer'

module RV::Mailer

  include ApplicationHelper

  def compose_mail(post, user)
    html_body = generate_html_mail(post.body)

    mail = Mail.new do
      from     user.email
      to       user.email
      subject  post.title
      body     post.body


      html_part do
        content_type 'text/html; charset=UTF-8'
        body html_body
      end
    end

    # set ActionGmailer
    config = {
      oauth2_token: user.google_auth_token,
      account: user.email
    }.merge(Rendezvous::Application.config.action_mailer.smtp_settings)
    mail.delivery_method(ActionGmailer::DeliveryMethod, config)

    mail
  end

  def generate_html_mail(body)
    html_body = <<'__HTML__'
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="initial-scale=1.0">    <!-- So that mobile webkit will display zoomed in -->
  <meta name="format-detection" content="telephone=no"> <!-- disable auto telephone linking in iOS -->

  <title>2 columns to rows template | Antwort</title>

  <style type="text/css">

    /* Resets: see reset.css for details */
    .ReadMsgBody { width: 100%; background-color: #ebebeb;}
    .ExternalClass {width: 100%; background-color: #ebebeb;}
    .ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div {line-height:100%;}
    body {-webkit-text-size-adjust:none; -ms-text-size-adjust:none;}
    body {margin:0; padding:0;}
    table {border-spacing:0;}
    table td {border-collapse:collapse;}
    .yshortcuts a {border-bottom: none !important;}

    /* Constrain email width for small screens */
    @media screen and (max-width: 600px) {
      table[class="container"] {
        width: 95% !important;
      }
    }

    /* Give content more room on mobile */
    @media screen and (max-width: 480px) {
      td[class="container-padding"] {
        padding-left: 12px !important;
        padding-right: 12px !important;
      }
    }


    /* Styles for forcing columns to rows */
    @media only screen and (max-width : 600px) {

      /* force container columns to (horizontal) blocks */
      td[class="force-col"] {
        display: block;
        padding-right: 0 !important;
      }
      table[class="col-2"] {
        /* unset table align="left/right" */
        float: none !important;
        width: 100% !important;

        /* change left/right padding and margins to top/bottom ones */
        margin-bottom: 12px;
        padding-bottom: 12px;
        border-bottom: 1px solid #eee;
      }

      /* remove bottom border for last column/row */
      table[id="last-col-2"] {
        border-bottom: none !important;
        margin-bottom: 0;
      }

      /* align images right and shrink them a bit */
      img[class="col-2-img"] {
        float: right;
        margin-left: 6px;
        max-width: 130px;
      }
    }

    .viewer.github a {
      color: #4183C4; }
    .viewer.github a.absent {
      color: #cc0000; }
    .viewer.github a.anchor {
      display: block;
      padding-left: 30px;
      margin-left: -30px;
      cursor: pointer;
      position: absolute;
      top: 0;
      left: 0;
      bottom: 0; }
    .viewer.github h1, .viewer.github h2, .viewer.github h3, .viewer.github h4, .viewer.github h5, .viewer.github h6 {
      margin: 20px 0 10px;
      padding: 0;
      font-weight: bold;
      -webkit-font-smoothing: antialiased;
      cursor: text;
      position: relative; }
    .viewer.github h1:hover a.anchor, .viewer.github h2:hover a.anchor, .viewer.github h3:hover a.anchor, .viewer.github h4:hover a.anchor, .viewer.github h5:hover a.anchor, .viewer.github h6:hover a.anchor {
      background: url("../../images/modules/styleguide/para.png") no-repeat 10px center;
      text-decoration: none; }
    .viewer.github h1 tt, .viewer.github h1 code {
      font-size: inherit; }
    .viewer.github h2 tt, .viewer.github h2 code {
      font-size: inherit; }
    .viewer.github h3 tt, .viewer.github h3 code {
      font-size: inherit; }
    .viewer.github h4 tt, .viewer.github h4 code {
      font-size: inherit; }
    .viewer.github h5 tt, .viewer.github h5 code {
      font-size: inherit; }
    .viewer.github h6 tt, .viewer.github h6 code {
      font-size: inherit; }
    .viewer.github h1 {
      font-size: 28px;
      color: black; }
    .viewer.github h2 {
      font-size: 24px;
      border-bottom: 1px solid #cccccc;
      color: black; }
    .viewer.github h3 {
      font-size: 18px; }
    .viewer.github h4 {
      font-size: 16px; }
    .viewer.github h5 {
      font-size: 14px; }
    .viewer.github h6 {
      color: #777777;
      font-size: 14px; }
    .viewer.github p, .viewer.github blockquote, .viewer.github ul, .viewer.github ol, .viewer.github dl, .viewer.github li, .viewer.github table, .viewer.github pre {
      margin: 15px 0; }
    .viewer.github hr {
      background: transparent url("../../images/modules/pulls/dirty-shade.png") repeat-x 0 0;
      border: 0 none;
      color: #cccccc;
      height: 4px;
      padding: 0; }
    .viewer.github body > h2:first-child {
      margin-top: 0;
      padding-top: 0; }
    .viewer.github body > h1:first-child {
      margin-top: 0;
      padding-top: 0; }
    .viewer.github body > h1:first-child + h2 {
      margin-top: 0;
      padding-top: 0; }
    .viewer.github body > h3:first-child, .viewer.github body > h4:first-child, .viewer.github body > h5:first-child, .viewer.github body > h6:first-child {
      margin-top: 0;
      padding-top: 0; }
    .viewer.github a:first-child h1, .viewer.github a:first-child h2, .viewer.github a:first-child h3, .viewer.github a:first-child h4, .viewer.github a:first-child h5, .viewer.github a:first-child h6 {
      margin-top: 0;
      padding-top: 0; }
    .viewer.github h1 p, .viewer.github h2 p, .viewer.github h3 p, .viewer.github h4 p, .viewer.github h5 p, .viewer.github h6 p {
      margin-top: 0; }
    .viewer.github li p.first {
      display: inline-block; }
    .viewer.github ul, .viewer.github ol {
      padding-left: 30px; }
    .viewer.github ul :first-child, .viewer.github ol :first-child {
      margin-top: 0; }
    .viewer.github ul :last-child, .viewer.github ol :last-child {
      margin-bottom: 0; }
    .viewer.github dl {
      padding: 0; }
    .viewer.github dl dt {
      font-size: 14px;
      font-weight: bold;
      font-style: italic;
      padding: 0;
      margin: 15px 0 5px; }
    .viewer.github dl dt:first-child {
      padding: 0; }
    .viewer.github dl dt > :first-child {
      margin-top: 0; }
    .viewer.github dl dt > :last-child {
      margin-bottom: 0; }
    .viewer.github dl dd {
      margin: 0 0 15px;
      padding: 0 15px; }
    .viewer.github dl dd > :first-child {
      margin-top: 0; }
    .viewer.github dl dd > :last-child {
      margin-bottom: 0; }
    .viewer.github blockquote {
      border-left: 4px solid #dddddd;
      padding: 0 15px;
      color: #777777; }
    .viewer.github blockquote > :first-child {
      margin-top: 0; }
    .viewer.github blockquote > :last-child {
      margin-bottom: 0; }
    .viewer.github table {
      padding: 0; }
    .viewer.github table tr {
      border-top: 1px solid #cccccc;
      background-color: white;
      margin: 0;
      padding: 0; }
    .viewer.github table tr:nth-child(2n) {
      background-color: #f8f8f8; }
    .viewer.github table tr th {
      font-weight: bold;
      border: 1px solid #cccccc;
      text-align: left;
      margin: 0;
      padding: 6px 13px; }
    .viewer.github table tr td {
      border: 1px solid #cccccc;
      text-align: left;
      margin: 0;
      padding: 6px 13px; }
    .viewer.github table tr th :first-child, .viewer.github table tr td :first-child {
      margin-top: 0; }
    .viewer.github table tr th :last-child, .viewer.github table tr td :last-child {
      margin-bottom: 0; }
    .viewer.github img {
      max-width: 100%; }
    .viewer.github span.frame {
      display: block;
      overflow: hidden; }
    .viewer.github span.frame > span {
      border: 1px solid #dddddd;
      display: block;
      float: left;
      overflow: hidden;
      margin: 13px 0 0;
      padding: 7px;
      width: auto; }
    .viewer.github span.frame span img {
      display: block;
      float: left; }
    .viewer.github span.frame span span {
      clear: both;
      color: #333333;
      display: block;
      padding: 5px 0 0; }
    .viewer.github span.align-center {
      display: block;
      overflow: hidden;
      clear: both; }
    .viewer.github span.align-center > span {
      display: block;
      overflow: hidden;
      margin: 13px auto 0;
      text-align: center; }
    .viewer.github span.align-center span img {
      margin: 0 auto;
      text-align: center; }
    .viewer.github span.align-right {
      display: block;
      overflow: hidden;
      clear: both; }
    .viewer.github span.align-right > span {
      display: block;
      overflow: hidden;
      margin: 13px 0 0;
      text-align: right; }
    .viewer.github span.align-right span img {
      margin: 0;
      text-align: right; }
    .viewer.github span.float-left {
      display: block;
      margin-right: 13px;
      overflow: hidden;
      float: left; }
    .viewer.github span.float-left span {
      margin: 13px 0 0; }
    .viewer.github span.float-right {
      display: block;
      margin-left: 13px;
      overflow: hidden;
      float: right; }
    .viewer.github span.float-right > span {
      display: block;
      overflow: hidden;
      margin: 13px auto 0;
      text-align: right; }
    .viewer.github code, .viewer.github tt {
      margin: 0 2px;
      padding: 0 5px;
      white-space: nowrap;
      border: 1px solid #eaeaea;
      background-color: #f8f8f8;
      border-radius: 3px; }
    .viewer.github pre code {
      margin: 0;
      padding: 0;
      white-space: pre;
      border: none;
      background: transparent; }
    .viewer.github .highlight pre {
      background-color: #f8f8f8;
      border: 1px solid #cccccc;
      font-size: 13px;
      line-height: 19px;
      overflow: auto;
      padding: 6px 10px;
      border-radius: 3px; }
    .viewer.github pre {
      background-color: #f8f8f8;
      border: 1px solid #cccccc;
      font-size: 13px;
      line-height: 19px;
      overflow: auto;
      padding: 6px 10px;
      border-radius: 3px; }
    .viewer.github pre code, .viewer.github pre tt {
      background-color: transparent;
      border: none; }
  </style>
</head>
<body style="margin:0; padding:10px 0;" bgcolor="#ebebeb" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<br>

<!-- 100% wrapper (grey background) -->
<table border="0" width="100%" height="100%" cellpadding="0" cellspacing="0" bgcolor="#ebebeb">
  <tr>
    <td align="center" valign="top" bgcolor="#ebebeb" style="background-color: #ebebeb;">

      <!-- 600px container (white background) -->
      <table border="0" width="600" cellpadding="0" cellspacing="0" class="container" bgcolor="#ffffff">
        <tr>
          <td class="container-padding" bgcolor="#ffffff" style="background-color: #ffffff; padding-left: 30px; padding-right: 30px; font-size: 14px; line-height: 20px; font-family: Helvetica, sans-serif; color: #333;">
            <br>

__HTML__

    html_body += h_application_format_markdown(body)

    html_body += <<'__HTML__'

            <br>

            </td>
            </tr>
            <tr>
          <td class="container-padding" bgcolor="#ffffff" style="background-color: #ffffff; padding-left: 30px; padding-right: 30px; font-size: 13px; line-height: 20px; font-family: Helvetica, sans-serif; color: #333;" align="left">
            <br>

            <hr>

            このメールは<a href="#">Rendezvous</a>から送信されています。

            <br><br>

          </td>
        </tr>
      </table>
      <!--/600px container -->

    </td>
  </tr>
</table>
<!--/100% wrapper-->
<br>
<br>
</body>
</html>
__HTML__

    premailer = Premailer.new(html_body, :with_html_string => true, :adapter => :nokogiri)
    premailer.to_inline_css
  end

end
