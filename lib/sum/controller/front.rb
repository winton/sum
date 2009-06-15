Application.class_eval do
  get '/' do
    "#{self.class.environment}"
  end
end
