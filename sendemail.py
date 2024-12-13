#              .';:cc;.
#            .,',;lol::c.
#            ;';lddddlclo
#            lcloxxoddodxdool:,.
#            cxdddxdodxdkOkkkkkkkd:.
#          .ldxkkOOOOkkOO000Okkxkkkkx:.
#        .lddxkkOkOOO0OOO0000Okxxxxkkkk:
#       'ooddkkkxxkO0000KK00Okxdoodxkkkko
#      .ooodxkkxxxOO000kkkO0KOxolooxkkxxkl
#      lolodxkkxxkOx,.      .lkdolodkkxxxO.
#      doloodxkkkOk           ....   .,cxO;
#      ddoodddxkkkk:         ,oxxxkOdc'..o'
#      :kdddxxxxd,  ,lolccldxxxkkOOOkkkko,
#       lOkxkkk;  :xkkkkkkkkOOO000OOkkOOk.
#        ;00Ok' 'O000OO0000000000OOOO0Od.
#         .l0l.;OOO000000OOOOOO000000x,
#            .'OKKKK00000000000000kc.
#               .:ox0KKKKKKK0kdc,.
#                      ...
#
# Author: peppe8o
# Date: Mar 17th, 2023
# Version: 1

# import the required modules
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from email.mime.base import MIMEBase
from email import encoders

username = "wolfstools@gmail.com"
password = "n0Fr0get"
smtp_host = "smtp.gmail.com"
smtp_port = 587

def email_send(rec, subj, message, sender=username, attachments=[], body_type="html"):
# defaul sender=username. You can also specify here an alias, like "Name Surname <name.surname@example.com>"
# rec = list object with recipient(s) email addresses
# subj = email subject
# message = email body
# attachments = list object with attachments path, default no attachments
# body-type can be "html" (default, if not specified) or "plain"

	msg = MIMEMultipart()
	msg['Subject'] = subj
	msg['From'] = sender

	# add the body
	msg.attach(MIMEText(message, body_type))

	# add attachhments
	if len(attachments)>0:
		for i in attachments:
			filename = i
			attachment = open(i, "rb") # open the file to be sent
			p = MIMEBase('application', 'octet-stream') # instance of MIMEBase and named as p
			p.set_payload((attachment).read()) # To change the payload into encoded form
			encoders.encode_base64(p) # encode into base64
			p.add_header('Content-Disposition', "attachment; filename= %s" % filename)
			msg.attach(p) # attach the instance 'p' to instance 'msg'

	# Converts the Multipart msg into a string
	text = msg.as_string()

	# Send the email(s)
	s = smtplib.SMTP(smtp_host, smtp_port) # creates SMTP session
	s.starttls() # start TLS for security
	s.login(username, password) # Authentication
	for r in rec: s.sendmail(username, r, text) # sending the mail
	s.quit() # terminating the session

