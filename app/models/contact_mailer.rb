class ContactMailer < ActionMailer::Base
  
  def contactadvertiser(classified, contact)
    @subject    = "#{SITENAME}: Message from a visitor"
    @recipients = classified.email
    @from = contact[:email]
    @sent_on  = Time.now
    @body["title"] = classified.title
    @body["email"] = contact[:email]    
    @body["msg"] = contact[:msg]    
  end
  
  def adactivationlink(classified)
    @subject    = "#{SITENAME}: Activate your Ad"
    @recipients = classified.email
    @from = "support@railslist.com"
    @sent_on  = Time.now
    @body[:title] = classified.title
    @body[:activateurl]  = "#{SITEURL}/activate/#{classified.activation_code}" 
    @body[:editurl] = "#{SITEURL}/edit/#{classified.activation_code}" 
    @body[:deleteurl] = "#{SITEURL}/delete/#{classified.activation_code}" 
  end
end
