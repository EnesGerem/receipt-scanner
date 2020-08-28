import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

sendMail(File data) async {
  String username = 'mailsenderdocuart@gmail.com';
  String password = 'msdocuart1453';

  File file = data;

  final smtpServer = gmail(username, password);

  // Create our message.
  final message = Message()
    ..from = Address(username, 'Enes from Voucher Scanner')
    ..recipients.add('eneesgerem@gmail.com')
    //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
    //..bccRecipients.add(Address('bccAddress@example.com'))
    ..subject = 'Voucher Data'
    //..text = 'Here is your data.\n'
    ..html = "<h1>Voucher Scanner</h1>\n<p>Excel file is at the attachments</p>"
    ..attachments.add(FileAttachment(file));

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) print('Problem: ${p.code}: ${p.msg}');
  }
}
