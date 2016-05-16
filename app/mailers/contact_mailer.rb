class ContactMailer < ActionMailer::Base
  # Define default parameters
  default from: "PropertyDome@slehmann36.com"
  default to: "PropertyDome@slehmann36.com"

  def send_contact_email(name, email, body)
    @name = name
    @email = email
    @body = body

    # Send email to company mailbox
    mail(subject: 'It Works!') #from: @email, Contact Request

    # Notify sender of successful delivery
    #mail(to: @email, subject: 'It Works!')
  end
end
