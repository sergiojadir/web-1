require "csv"

class SaleFileService
  attr_reader :file, :path, :valid_header

	def initialize(file)
		@file = file
		@path = "#{Rails.root}/tmp/sale_files/#{file.id}"
	end

	def read_lines
		csv_options = { :encoding => 'ISO-8859-1:UTF-8', :skip_blanks => true, headers: true, :col_sep => "\t" }
  	csv = CSV.read(get_file, csv_options)
    csv
	end

	def get_file
		FileUtils.mkdir_p @path
		
		file_name = @file.file
		file = "#{@path}/#{file_name}"

		File.open(file, "wb") do | file|
  		file.write(@file.file.read)
	  	file.close
	 	end
		file
	end

  def remove_temp_file
    FileUtils.rm_rf(self.path)
  end

  def valid_header?(file_header, valid_header)
    return invalid_header(file_header) if file_header != valid_header
  end

  def invalid_header(file_header)
    @file.fire_events!(:falha)

    @logger.info("*** Arquivo importado com falha ***")
    raise "File with invalid header. Expected: #{HEADER_VALIDO}. File header: #{header_do_arquivo}"
  end
end