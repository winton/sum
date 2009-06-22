class IncomingMail
  def self.receive(email)
    $log.info email
  end
end