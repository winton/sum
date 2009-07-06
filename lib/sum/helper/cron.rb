Application.class_eval do
  helpers do
    
    def days(day, include_number=nil)
      day == 1 ? "#{include_number ? "#{day} " : ''}day" : "#{day} days"
    end
    
    def money(amount)
      "$#{sprintf("%.2f", amount)}"
    end
  end
end