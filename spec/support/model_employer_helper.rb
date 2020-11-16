module EmployerHelper

  require 'csv'
  def create_csv(rows)
	let(:file_path) { "tmp/test.csv" }
	let!(:csv) do
	  CSV.open(file_path, "w") do |csv|
	    rows.each do |row|
	      csv << row.split(",")
	    end
	  end
	end
  end
end