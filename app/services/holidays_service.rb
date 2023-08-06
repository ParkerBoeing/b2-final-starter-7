class HolidaysService
  def self.upcoming_holidays
    url = 'https://date.nager.at/Api/v3/NextPublicHolidays/US'
    response = Faraday.get(url)
    parsed_holidays = JSON.parse(response.body)
    holidays = parsed_holidays.map { |holiday_data| Holiday.new(holiday_data)}
    holidays.first(3)
  end
end