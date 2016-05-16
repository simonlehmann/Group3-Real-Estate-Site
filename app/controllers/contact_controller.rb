class ContactController < ApplicationController
  def index
  end

  def send_mail
    # Create the contact from params
    name = params[:name]
    email = params[:email]
    body = params[:comments]

    # Deliver the email
    ContactMailer.send_contact_email(name, email, body).deliver

    # Show message sent message
    redirect_to contact_path, notice: 'Message sent'
  end
end
