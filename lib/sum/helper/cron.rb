Application.class_eval do
  helpers do
    
    def days(day)
      day == 1 ? "day" : "#{day} days"
    end
    
    def money(amount)
      "$#{sprintf("%.2f", amount)}"
    end
  end
end