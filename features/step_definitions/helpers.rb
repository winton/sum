def fill_all_with_valid_data
  valid = {
    'savings' => '0',
    'income' => '0',
    'bills' => '0',
    'email' => 'cucumber@sumapp.com'
  }
  valid.each do |key, value|
    fill_in "user[#{key}]", :with => value
  end
end