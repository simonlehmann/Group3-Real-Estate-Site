class ContactController < ApplicationController
  def index
  end

  def send_mail
    # Create the contact from params
    first_name = params[:first_name]
    last_name = params[:last_name]
    email = params[:email]
    subject = params[:subject]
    body = params[:message]

    # Deliver the email
    ContactMailer.send_contact_email(first_name, last_name, email, subject, body).deliver_now

    # Deliver confirmation email
    ContactMailer.send_contact_confirmation_email(first_name, last_name, email, subject, body).deliver_now

    # Send Flash message to confirm
    flash[:notice] = "Message successfully sent"

    # Show message sent message
    redirect_to contact_path #, notice: 'Message sent'
  end
end
