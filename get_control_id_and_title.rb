# need to have spreadsheet gem in local
require "spreadsheet"
# specify the location for file_name variable as per your repo path
# it has to be, path of translated_control.rb which is having the most controls for that profile
file_name = "/Users/gokulks/Documents/code_repo/chef_repos/compliance-profiles/src/inspec/supported/cis-oraclelinux7-level2-server-v3.1.1/controls/translated-controls.rb"
output_file_name = "cont_id_title.xls"
file_content = File.read(file_name)
book = Spreadsheet::Workbook.new
sheet1 = book.create_worksheet
File.delete(output_file_name) if File.exist?(output_file_name)
control_id_list = []
row_count = 0
file_content.scan(/xccdf_org.cisecurity.benchmarks_rule_[\d\.]+_.*(?=\")/).each do |x|
  x = x.gsub("xccdf_org.cisecurity.benchmarks_rule_","")
  c_id = x.scan(/[\d.]+/)[0]
  title = x.scan(/(?<=_).*/)[0].gsub("_"," ")
  sheet1.update_row row_count, c_id, title 
  row_count += 1
end
sheet1.column(1).outline_level = 1
book.write output_file_name
