class ContactMailer < ActionMailer::Base
  # Define default parameters
  default from: "PropertyDome@slehmann36.com"
  default to: "PropertyDome@slehmann36.com"

  def send_contact_email(first_name, last_name, email, subject, body)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @subject = subject
    @body = body

    # Send email to company mailbox
    mail(subject: @subject) #from: @email, Contact Request

    # Notify sender of successful delivery
    #mail(to: @email, subject: 'Contact Request Received')
  end
  def send_contact_confirmation_email(first_name, last_name, email, subject, body)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @subject = subject
    @body = body

    # Send email to company mailbox
    #mail(subject: @subject) #from: @email, Contact Request

    # Notify sender of successful delivery
    mail(to: @email, subject: 'Contact Request Received')
  end

end
