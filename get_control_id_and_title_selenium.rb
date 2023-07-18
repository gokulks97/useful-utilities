
# need to have spreadsheet gem in local
require 'spreadsheet'
require 'webdrivers'

email_id = ''
pwd = ''

# specify
print "Enter the CIS benchmark link from CIS website\nBenchmark Link: "
benchmark_link = gets.chomp
profile = benchmark_link.empty? ? '' : benchmark_link
raise "\nBenchmark link is not provided: Provide benchmark link" if profile.empty?

if email_id.nil? || email_id.empty?
  print "Enter the email id of CIS website: " 
  email_id_i = gets.chomp
  email_id = email_id_i.empty? ? '' : email_id_i
  raise "\n  Email ID is not provided: \nProvide Email ID or assign the email id in rb file directly" if email_id.empty?
end

if pwd.nil? || pwd.empty?
  print "Enter the password of CIS website: " 
  pwd_i = gets.chomp
  pwd = pwd_i.empty? ? '' : pwd_i
  raise "\n  Password is not provided: \nProvide provide or assign the password in rb file directly" if pwd.empty?
end

# output file
output_file_name = 'cont_id_title.xls'
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet
File.delete(output_file_name) if File.exist?(output_file_name)

def get_controls_link(profile, email_id, pwd)
  @options = Selenium::WebDriver::Chrome::Options.new
  @options.add_argument '--headless'
  @options.add_argument('user-agent=Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) \'Chrome/94.0.4606.81 Safari/537.36\'')
  @driver = Selenium::WebDriver.for :chrome, options: @options
  puts 'driver assigned with chrome driver'
  cis_http_link = 'https://workbench.cisecurity.org'
  @driver.get cis_http_link + '/'
  puts '$$ CIS login page reached $$'
  email_locator = @driver.find_element(name: 'login')
  password_locator = @driver.find_element(id: 'password')
  email_locator.send_key(email_id)
  password_locator.send_key(pwd)
  login_button = @driver.find_element(class: 'login-submit-btn')
  login_button.click
  puts '$$ Reaching CIS Profile $$'
  @driver.get cis_http_link + '/benchmarks/' + profile
  sleep 2
  html_page = @driver.page_source
  control_links = html_page.scan(/href.*recommendations.*title.*\s-.*?\"/)
  sleep 2
  controls = {}
  control_links.each do |control_w_link|
    id = control_w_link.scan(/(?<=title\=")[\d.]+\d(?=\s)/)[0]
    control_title = control_w_link.scan(/(?<=\d - ).*(?=\")/)[0]
    controls[id] = control_title unless id.nil?
  end
  puts 'controls obtained'
  @driver.quit
  controls
end

controls = get_controls_link profile.match?(%r{^http.*\/\d+$}) ? profile.scan(/(?<=benchmarks\/).*\d+$/)[0] : profile, email_id, pwd
row_count = 0
controls.each do |id, title|
  sheet1.update_row row_count, id, title
  row_count += 1
end
sheet1.column(1).outline_level = 1
book.write output_file_name

