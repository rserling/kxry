from sendemail import email_send

subject = "KXRY Alert"
sender = "ErikNerd <wolfstools@gmail.com>"

recipients = []
recipients.append("davedatt@gmail.com")

attachments = []
#attachments.append("test.txt")

body = "this is a test alert from a python script I found"

# ------------------- SEND RESULT REPORT -------------------------------
email_send(recipients, subject, body, sender, attachments)
